import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:flutter_todo_app/features/task_management/presentation/controller/firestore_controller.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/main_screen.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/priority_colors.dart';
import 'package:flutter_todo_app/utils/size_config.dart';
import 'package:intl/intl.dart';

// intl 패키지를 사용하여 날짜 형식을 지정합니다.
// 포맷팅을 할 함수를 정의 합니다.
String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

// TaskItem 위젯은 개별 작업 항목을 표시하는 데 사용됩니다.
// ConsumerStatefulWidget는 상태를 관리하고, 상태가 변경될 때 UI를 업데이트하는 데 사용됩니다.
// ConsumerStatefulWidget를 extends함으로서 Riverpod의 상태 관리 기능을 활용할 수 있습니다.
class TaskItem extends ConsumerStatefulWidget {
  const TaskItem(this.task, {super.key});
  // build 메서드에서 사용할 task 객체를 final 필드로 선언합니다.
  // 이 필드는 생성자에서 초기화되며, 변경할 수 없습니다.
  final Task task;

  // createState 메서드는 이 위젯의 상태를 관리하는 State 객체를 생성합니다.
  // State 클래스 안에는 get widget => widget;이 정의되어 있어
  // widget 필드를 통해 TaskItem 위젯에 접근할 수 있습니다.
  // _TaskItemState 클래스는 TaskItem 위젯의 상태를 관리합니다.
  // 이 클래스는 ConsumerState를 상속하여 Riverpod의 상태 관리 기능을 사용할 수 있습니다.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  // 삭제액션에 들어갈 함수를 정의
  // 이함수는 widget.task.id를 사용하여 특정 작업을 삭제합니다.
  // 삭제 전에 사용자에게 확인을 요청하는 다이얼로그를 표시합니다.
  void _deleteTask(String taskId) {
    // 다이얼로그를 띄우기 전에 필요한 값을 ref.read로 미리 읽어옵니다.
    // ref.watch를 사용하면 위젯이 재빌드되어 context가 무효화될 수 있습니다.
    final userId = ref.read(currentUserProvider)?.uid;
    // showDialog를 사용하여 삭제 확인 다이얼로그를 표시합니다.
    // showDialog의 구성요소는
    // context, builder, AlertDialog, title, icon, content, actions 등이 있습니다.
    // context는 현재 위젯 트리에서의 위치를 나타내며,
    // builder는 다이얼로그의 내용을 정의하는 함수입니다.
    // AlertDialog는 제목, 아이콘, 내용, 작업 버튼 등을 포함하는 다이얼로그 위젯입니다.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        icon: const Icon(Icons.warning, color: Colors.red),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            // Navigator는 현재 위젯 트리에서의 위치를 나타내며,
            // pop 메서드는 현재 화면을 닫고 이전 화면으로 돌아갑니다.
            onPressed: () => Navigator.of(context).pop(), // 다이얼로그 닫기
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // 비동기작업이 진행되는 동안 사용자가 다른 화면으로 이동하거나 현재 위젯이 화면에서 사라질수 있음
              // 그렇게 되면 해당위젯이 가지고 있던 buildContext는 유효하지 않게됨
              // 1. async gap 전에 필요한 값들을 미리 변수에 저장합니다.
              final navigator = Navigator.of(context);
              if (userId == null) {
                navigator.pop();
                return;
              }
              // 2. 비동기 작업 수행 (여기서는 삭제)
              await ref
                  .read(firestoreControllerProvider.notifier)
                  .deleteTask(userId: userId, taskId: taskId);
              // MainScreen에서 SnackBar를 표시하도록 요청합니다.
              mainScreenKey.currentState?.showSnackBar(
                'Task가 성공적으로 삭제되었습니다.',
                backgroundColor: Colors.red,
              );
              // 3. 저장해둔 navigator를 사용하여 다이얼로그 닫기
              navigator.pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 수정액션에 들어갈 함수를 정의
  void _updateTask() {
    // TextEditingController를 사용하여 텍스트 필드의 초기값을 설정하고,
    // 사용자가 입력한 값을 읽어올 수 있습니다.
    TextEditingController titleController = TextEditingController(
      text: widget.task.title,
    );
    TextEditingController descriptionController = TextEditingController(
      text: widget.task.description,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Task'),
        icon: const Icon(Icons.edit, color: Colors.blue),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // 다이얼로그 닫기
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // 1. async gap 전에 Navigator를 변수에 저장
              // ref.watch 대신 ref.read를 사용하여 context 문제를 방지합니다.
              final navigator = Navigator.of(context);
              final userId = ref.read(currentUserProvider)?.uid;
              if (userId == null) {
                navigator.pop();
                return;
              }

              final updatedTask = Task(
                id: widget.task.id,
                title: titleController.text,
                description: descriptionController.text,
                date: DateTime.now(),
                priority: widget.task.priority,
                isCompleted: widget.task.isCompleted,
              );

              // 2. 비동기 작업 수행 (여기서는 수정)
              await ref
                  .read(firestoreControllerProvider.notifier)
                  .updateTask(
                    userId: userId,
                    taskId: widget.task.id,
                    task: updatedTask,
                  );
              // MainScreen에서 SnackBar를 표시하도록 요청합니다.
              mainScreenKey.currentState?.showSnackBar(
                'Task가 성공적으로 수정되었습니다.',
                backgroundColor: Colors.blue,
              );
              // 3. 저장해둔 navigator를 사용하여 다이얼로그 닫기
              navigator.pop();
            },
            child: const Text('Update', style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[300],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Column 자식들을 왼쪽 정렬합니다.
              children: [
                Text(
                  widget.task.title,
                  style: Appstyles.headingTextStyle.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(8)),
                Text(
                  widget.task.description,
                  style: Appstyles.normalTextStyle.copyWith(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),
                // 날짜 및 우선순위 표시
                Row(
                  children: [
                    // priority 표시 박스
                    // priority: 최소 너비를 보장하기 위해 SizedBox로 고정 너비 제공
                    SizedBox(
                      width: SizeConfig.getProportionateWidth(90),
                      child: Container(
                        alignment: Alignment.center,
                        height: SizeConfig.getProportionateHeight(40),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: PriorityColors.getColor(widget.task.priority),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.task.priority.toUpperCase(),
                            style: Appstyles.normalTextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateWidth(10)),
                    // 날짜 표시영역
                    // date: 남은 공간을 차지하도록 Expanded 사용
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: SizeConfig.getProportionateHeight(40),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // 날짜와 아이콘을 Row로 배치
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 가운데 정렬을 위해 추가
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: SizeConfig.getProportionateWidth(5),
                            ),
                            Flexible(
                              // Text 위젯도 Flexible로 감싸기
                              child: Text(
                                formatDate(widget.task.date),
                                style: Appstyles.normalTextStyle.copyWith(
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // 텍스트가 넘칠 경우 ...으로 표시
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 오른쪽 액션 영역: 고정 너비를 주어 왼쪽 레이아웃이 영향을 덜 받게 함
          SizedBox(
            width: SizeConfig.getProportionateWidth(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 체크박스 (상태 연동은 추후 구현)
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: widget.task.isCompleted,
                    onChanged: (bool? value) {
                      // 체크박스 상태 변경 액션
                      if (value == null) {
                        return;
                      } else {
                        // isCompleted 상태가 변경되면 FirestoreRepository를 통해 업데이트합니다.
                        // 현재로그인한 사용자의 id를 가져오고
                        // ref.read를 사용하여 isCompleted 상태를 업데이트하기 위해서
                        // firestoreRepositoryProvider 인스턴스를 가져오고
                        // updateTaskCompletion 메서드를 호출해
                        final userId = ref.read(currentUserProvider)?.uid;
                        ref
                            .read(firestoreRepositoryProvider)
                            .updateTaskCompletion(
                              userId: userId,
                              taskId: widget.task.id,
                              isCompleted: value,
                            );
                      }
                    },
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 30),
                      onPressed: () {
                        _updateTask();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 30),
                      onPressed: () {
                        _deleteTask(widget.task.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
