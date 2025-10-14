import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/common_wigets/async_value_ui.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:flutter_todo_app/features/task_management/presentation/controller/firestore_controller.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/main_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/widgets/title_description.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/size_config.dart';

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

  // 우선순위 선택 버튼에 사용될 텍스트 리스트입니다.
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  // 현재 선택된 우선순위의 인덱스를 저장하는 변수입니다.
  int _selectedPriorityIndex = 0;

  @override
  void dispose() {
    // 위젯이 dispose될 때 컨트롤러를 정리하여 메모리 누수를 방지합니다.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  // widget을 그리는 build 메서드는 BuildContext를 매개변수로 받습니다.
  // BuildContext의 역할은 위젯 트리에서 현재 위젯의 위치를 나타내며,
  // 부모 위젯에 접근하거나 테마, 미디어 쿼리 등의 정보를 가져오는 데 사용됩니다.
  // 이 메서드에서는 화면의 레이아웃과 UI 요소들을 정의합니다.
  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따라 위젯 크기를 조절하기 위해 SizeConfig를 초기화합니다.
    SizeConfig.init(context);
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
        mainScreenKey.currentState?.showSnackBar('Task가 성공적으로 작성되었습니다.');
        // 작업 추가가 완료되었으므로 입력 필드를 초기화합니다.
        _titleController.clear();
        _descriptionController.clear();
        // 우선순위 선택도 기본값(Low)으로 되돌립니다.
        setState(() => _selectedPriorityIndex = 0);
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Task',
          ),
        ),
        body: Padding(
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
                prefixIcon: Icons.notes,
                hintText: 'Enter task description',
                maxLines: 3,
                controller: _descriptionController,
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
              // 우선순위를 선택하는 Row 위젯입니다.
              Row(
                children: [
                  Text(
                    'Priority',
                    style: Appstyles.headingTextStyle.copyWith(
                      fontSize: SizeConfig.getProportionateHeight(18),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: SizeConfig.getProportionateHeight(40),
                      // 우선순위 버튼들을 가로로 나열하기 위해 ListView.builder를 사용합니다.
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _priorities.length,
                        itemBuilder: (context, index) {
                          final priority = _priorities[index];
                          // GestureDetector는 탭 이벤트를 감지하는 위젯입니다.
                          // 사용자가 우선순위 버튼을 탭하면 _selectedPriorityIndex를 업데이트하고
                          // 화면을 다시 그려 선택된 우선순위가 시각적으로 표시되도록 합니다.
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPriorityIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: SizeConfig.getProportionateWidth(8.0),
                              ),
                              padding: EdgeInsets.all(
                                SizeConfig.getProportionateHeight(8.0),
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // 선택된 우선순위에 따라 버튼 색상을 변경합니다.
                                color: _selectedPriorityIndex == index
                                    ? Colors.deepOrange
                                    : Colors.grey,
                              ),
                              child: Text(
                                priority,
                                style: Appstyles.normalTextStyle.copyWith(
                                  // 선택된 우선순위에 따라 텍스트 색상을 변경합니다.
                                  color: _selectedPriorityIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
              // InkWell 위젯은 탭 이벤트를 감지하는 위젯입니다.
              // 'Add Task' 버튼입니다.
              // onTap 속성은 사용자가 버튼을 탭했을 때 실행될 콜백 함수를 정의합니다.
              InkWell(
                onTap: () {
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
                  // 사용자가 add task버튼을 누르면
                  // FirestoreController를 통해 새로운 작업을 추가합니다.
                  // userId와 myTask 객체를 전달하여 특정 사용자에게 작업을 연결합니다.
                  ref.read(firestoreControllerProvider.notifier).addTask(
                        userId: userId, 
                        task: myTask,
                      );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.getProportionateHeight(50),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
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
    );
  }
}
