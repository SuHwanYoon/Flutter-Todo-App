import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/common_wigets/async_value_ui.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:flutter_todo_app/features/task_management/domain/task_notification.dart';
import 'package:flutter_todo_app/features/task_management/data/notification_repository.dart';
import 'package:flutter_todo_app/features/task_management/presentation/controller/firestore_controller.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/main_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/widgets/title_description.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/size_config.dart';
import 'package:flutter_todo_app/utils/priority_colors.dart';
import 'package:flutter_todo_app/utils/notification_helper.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:app_settings/app_settings.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

// AddTaskScreen은 새로운 작업을 추가하는 화면을 담당하는 StatefulWidget입니다.
// ConsumerStatefulWidget을 상속하여 Riverpod의 상태 관리를 사용합니다.
class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  // 제목과 설명을 입력받기 위한 TextEditingController입니다.
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Description 필드의 포커스를 관리하기 위한 FocusNode입니다.
  final _descriptionFocusNode = FocusNode();

  // 우선순위 선택 버튼에 사용될 텍스트 리스트입니다.
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  // 현재 선택된 우선순위의 인덱스를 저장하는 변수입니다.
  int _selectedPriorityIndex = 0;

  // Notification settings
  bool _notificationEnabled = false;
  DateTime? _selectedNotificationTime;

  @override
  void dispose() {
    // 위젯이 dispose될 때 컨트롤러와 FocusNode를 정리하여 메모리 누수를 방지합니다.
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectNotificationDateTime() async {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 365)),
      onConfirm: (date) {
        setState(() {
          _selectedNotificationTime = date;
        });
      },
      currentTime: _selectedNotificationTime ?? DateTime.now(),
      locale: picker.LocaleType.ko,
    );
  }

  // 권한 거부 시 설정 이동 다이얼로그 표시
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission'),
        icon: const Icon(Icons.notifications_off, color: Colors.orange),
        content: const Text(
          'Notification permission is required to set reminders.\n\n'
          'Please enable notifications in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  // 정확한 알람 권한 거부 시 설정 이동 다이얼로그 표시 (Android 12+ 해당)
  void _showExactAlarmPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exact Alarm Permission'),
        icon: const Icon(Icons.alarm_add, color: Colors.blue),
        content: const Text(
          'To schedule notifications at a precise time, please grant the "Alarms & reminders" permission for this app in your settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await NotificationHelper.openExactAlarmSettings();
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  // widget을 그리는 build 메서드는 BuildContext를 매개변수로 받습니다.
  // BuildContext의 역할은 위젯 트리에서 현재 위젯의 위치를 나타내며,
  // 부모 위젯에 접근하거나 테마, 미디어 쿼리 등의 정보를 가져오는 데 사용됩니다.
  // 이 메서드에서는 화면의 레이아웃과 UI 요소들을 정의합니다.
  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따라 위젯 크기를 조절하기 위해 SizeConfig를 초기화합니다.
    SizeConfig.init(context);
    // 다크 모드 여부 확인
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // 현재 로그인된 사용자의 ID를 가져옵니다.
    // 실제 앱에서는 이 값을 사용하여 작업을 해당 사용자에게 연결해야 합니다.
    // 예를 들어, Firestore에 작업을 추가할 때 userId를 사용하여
    // 특정 사용자의 작업 컬렉션에 저장할 수 있습니다.
    final userId = ref.watch(currentUserProvider)?.uid ?? '';
    // 위젯 내부에서 사용될 FirestoreController의 상태를 구독해서 선언
    final state = ref.watch(firestoreControllerProvider);

    // 비동기 상태에 따라 UI를 업데이트합니다.
    // 오류가 발생하면 알림 대화상자를 표시합니다. 
    ref.listen<AsyncValue>(firestoreControllerProvider, (previous, state) {
      state.showAlertDialogOnError(context);
      // 작업 추가가 성공적으로 완료되었는지 확인합니다.
      // 이전 상태가 로딩 중이었고, 현재 상태에 에러가 없다면 성공으로 간주합니다.
      final isTaskAdded = previous is AsyncLoading && !state.hasError;
      if (isTaskAdded) {
        // GlobalKey를 사용하여 MainScreen의 탭을 AllTasksScreen(인덱스 0)으로 이동시킵니다.
        mainScreenKey.currentState?.changeTab(0);
        // MainScreen에서 SnackBar를 표시하도록 요청합니다.
        mainScreenKey.currentState?.showSnackBar(
          'Task가 성공적으로 작성되었습니다.',
          backgroundColor: Colors.green,
        );
        // 작업 추가가 완료되었으므로 입력 필드를 초기화합니다.
        _titleController.clear();
        _descriptionController.clear();
        // 우선순위 선택도 기본값(Low)으로 되돌립니다.
        // 알림 설정도 초기화합니다.
        setState(() {
          _selectedPriorityIndex = 0;
          _notificationEnabled = false;
          _selectedNotificationTime = null;
        });
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Task',
          ),
        ),
        body: KeyboardActions(
          config: _buildKeyboardActionsConfig(context, colorScheme, isDarkMode),
          child: GestureDetector(
            // 화면 탭하면 키보드 닫기
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Column(
                  children: [
              // 작업 제목을 입력받는 위젯입니다.
              TitleDescription(
                title: ' Task Title',
                prefixIcon: Icons.notes,
                hintText: 'Enter task title',
                maxLines: 1,
                controller: _titleController,
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
              // 작업 설명을 입력받는 위젯입니다.
              TitleDescription(
                title: ' Task Description',
                prefixIcon: Icons.description,
                hintText: 'Enter task description',
                minLines: 4,
                maxLines: 6,
                maxLength: 100,
                showCharacterCount: true,
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
              // 우선순위를 선택하는 위젯입니다. Wrap 위젯을 사용하여 화면 크기 및 폰트 크기에 따라 유연하게 반응합니다.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Priority',
                    style: Appstyles.headingTextStyle.copyWith(
                      fontSize: SizeConfig.getProportionateHeight(18),
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(8)),
                  Wrap(
                    spacing: SizeConfig.getProportionateWidth(8.0), // 버튼들 사이의 가로 간격
                    runSpacing: SizeConfig.getProportionateHeight(8.0), // 줄바꿈 시 세로 간격
                    children: List<Widget>.generate(
                      _priorities.length,
                      (index) {
                        final priority = _priorities[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPriorityIndex = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.getProportionateHeight(10.0),
                              horizontal: SizeConfig.getProportionateWidth(20.0),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // 선택된 우선순위에 따라 버튼 색상을 변경합니다.
                              color: _selectedPriorityIndex == index
                                  ? PriorityColors.getColor(priority)
                                  : Colors.grey,
                            ),
                            child: Text(
                              priority,
                              style: Appstyles.normalTextStyle.copyWith(
                                // 선택된 우선순위에 따라 텍스트 색상을 변경합니다.
                                color: _selectedPriorityIndex == index
                                    ? Colors.white
                                    : colorScheme.onSurface,
                                fontSize: 16, // 기본 폰트 크기를 약간 줄여 반응성에 더 유리하게 합니다.
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
              // Notification settings
              Row(
                children: [
                  Icon(Icons.notifications, size: 24, color: colorScheme.onSurface),
                  SizedBox(width: 8),
                  Text(
                    'Notification',
                    style: Appstyles.headingTextStyle.copyWith(
                      fontSize: SizeConfig.getProportionateHeight(18),
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Spacer(),
                  Switch(
                    value: _notificationEnabled,
                    onChanged: (value) async {
                      if (value) {
                        // 1. 일반 알림 권한 요청
                        final bool notificationGranted =
                            await NotificationHelper.requestNotificationPermission();
                        if (!mounted) return;

                        if (!notificationGranted) {
                          _showPermissionDeniedDialog();
                          return;
                        }

                        // 2. 정확한 알람 권한 확인 (Android 전용)
                        final bool exactAlarmGranted =
                            await NotificationHelper.canScheduleExactAlarms();
                        if (!mounted) return;

                        if (!exactAlarmGranted) {
                          _showExactAlarmPermissionDialog();
                          return;
                        }
                        
                        // 모든 권한이 허용된 경우
                        setState(() {
                          _notificationEnabled = true;
                        });

                      } else {
                        // 스위치 OFF
                        setState(() {
                          _notificationEnabled = false;
                          _selectedNotificationTime = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              if (_notificationEnabled) ...[
                SizedBox(height: SizeConfig.getProportionateHeight(12.0)),
                InkWell(
                  onTap: _selectNotificationDateTime,
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig.getProportionateHeight(12)),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? colorScheme.surfaceContainerHighest
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: colorScheme.primary),
                        SizedBox(width: 12),
                        Text(
                          _selectedNotificationTime == null
                              ? 'Select notification time'
                              : '${_selectedNotificationTime!.year}-${_selectedNotificationTime!.month.toString().padLeft(2, '0')}-${_selectedNotificationTime!.day.toString().padLeft(2, '0')} ${_selectedNotificationTime!.hour.toString().padLeft(2, '0')}:${_selectedNotificationTime!.minute.toString().padLeft(2, '0')}',
                          style: Appstyles.normalTextStyle.copyWith(
                            color: _selectedNotificationTime == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
              // ==================== 임시 디버그 버튼 ====================
              // ElevatedButton(
              //   onPressed: () async {
              //     print("--- 🐛 DEBUG BUTTON TAPPED ---");

              //     final bool notificationGranted = await NotificationHelper.requestNotificationPermission();
              //     print("1. 일반 알림 권한 상태: $notificationGranted");

              //     final bool exactAlarmGranted = await NotificationHelper.canScheduleExactAlarms();
              //     print("2. 정확한 알람 권한 상태: $exactAlarmGranted");

              //     if (!mounted) return;

              //     if (!notificationGranted) {
              //       print("-> 일반 알림 권한이 필요합니다. 다이얼로그 표시.");
              //       _showPermissionDeniedDialog();
              //     } else if (!exactAlarmGranted) {
              //       print("-> 정확한 알람 권한이 필요합니다. 다이얼로그 표시.");
              //       _showExactAlarmPermissionDialog();
              //     } else {
              //       print("✅ 모든 필수 권한이 허용된 상태입니다.");
              //       showDialog(
              //         context: context,
              //         builder: (context) => const AlertDialog(
              //           title: Text('권한 확인'),
              //           content: Text('필수 알림 권한이 모두 허용되어 있습니다.'),
              //         ),
              //       );
              //     }
              //   },
              //   child: const Text('Debug: Check Permissions'),
              // ),
              // SizedBox(height: SizeConfig.getProportionateHeight(10.0)),
              // ========================================================
              // InkWell 위젯은 탭 이벤트를 감지하는 위젯입니다.
              // 'Add Task' 버튼입니다.
              // onTap 속성은 사용자가 버튼을 탭했을 때 실행될 콜백 함수를 정의합니다.
              InkWell(
                onTap: () async {
                  final title = _titleController.text.trim();
                  final description = _descriptionController.text.trim();
                  String priority = _priorities[_selectedPriorityIndex];
                  DateTime date = DateTime.now();

                  final myTask = Task(
                    title: title,
                    description: description,
                    priority: priority,
                    date: date,
                  );
                  // ref.listen에서 상태 초기화가 먼저 일어날 수 있으므로
                  // notification 값을 미리 저장해둡니다.
                  final shouldSaveNotification = _notificationEnabled;
                  final notificationTime = _selectedNotificationTime;

                  // 사용자가 add task버튼을 누르면
                  // FirestoreController를 통해 새로운 작업을 추가합니다.
                  // userId와 myTask 객체를 전달하여 특정 사용자에게 작업을 연결합니다.
                  final taskId = await ref.read(firestoreControllerProvider.notifier).addTask(
                        userId: userId,
                        task: myTask,
                      );

                  // If notification is enabled and taskId was created successfully
                  if (shouldSaveNotification &&
                      notificationTime != null &&
                      taskId != null) {
                    final notification = TaskNotification(
                      taskId: taskId,
                      notificationTime: notificationTime,
                    );

                    // Firestore에 알림 정보 저장
                    await ref.read(notificationRepositoryProvider).addNotification(
                      userId: userId,
                      notification: notification,
                    );

                    // 실제 로컬 알림 스케줄링
                    await NotificationHelper.scheduleNotification(
                      id: taskId.hashCode,  // taskId를 기반으로 고유 ID 생성
                      title: title,          // Task 제목
                      scheduledTime: notificationTime,
                      payload: taskId,       // 알림 탭 시 taskId 전달
                    );

                    //  즉시 알림 (알림 시스템 작동 확인용)
                    final formattedTime = '${notificationTime.year}-${notificationTime.month.toString().padLeft(2, '0')}-${notificationTime.day.toString().padLeft(2, '0')} ${notificationTime.hour.toString().padLeft(2, '0')}:${notificationTime.minute.toString().padLeft(2, '0')}';
                    await NotificationHelper.showNotification(
                      id: 9999,
                      title: '✅ 알림예약',
                      body: '"$title"의 알림이 $formattedTime에 예약되었습니다!',
                    );

                    // 🧪 추가 테스트: 10초 후 알림 (에뮬레이터 테스트용)
                    // await NotificationHelper.scheduleNotification(
                    //   id: 8888,
                    //   title: '🧪 10초 테스트',
                    //   scheduledTime: DateTime.now().add(const Duration(seconds: 10)),
                    // );

                    // 🐛 디버그: 대기 중인 알림 확인
                    // await NotificationHelper.checkPendingNotifications();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.getProportionateHeight(50),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  // 버튼 내부의 내용을 조건에 따라 다르게 표시합니다.
                  // 로딩 중일 때는 CircularProgressIndicator를 표시하고, 아닐 때는 Row를 표시합니다.
                  child: state.isLoading? const CircularProgressIndicator() : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // 'Add Task' 버튼 내부에 아이콘과 텍스트를 배치합니다.
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 30),
                      Text(
                        'Add Task',
                        style: Appstyles.normalTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // KeyboardActions 설정을 반환하는 메서드
  KeyboardActionsConfig _buildKeyboardActionsConfig(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDarkMode,
  ) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: isDarkMode
          ? colorScheme.surfaceContainer
          : Colors.grey[300],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _descriptionFocusNode,
          toolbarButtons: [
            (node) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: () {
                    node.unfocus();
                  },
                  icon: Icon(
                    Icons.keyboard_hide_rounded,
                    color: colorScheme.primary,
                  ),
                  tooltip: '키보드 닫기',
                ),
              );
            },
          ],
        ),
      ],
    );
  }
}
