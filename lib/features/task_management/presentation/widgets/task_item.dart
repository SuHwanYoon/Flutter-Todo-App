import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
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
                          color: Colors.deepOrange,
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
                      }else {
                        // isCompleted 상태가 변경되면 FirestoreRepository를 통해 업데이트합니다.
                        // 현재로그인한 사용자의 id를 가져오고
                        // ref.read를 사용하여 isCompleted 상태를 업데이트하기 위해서
                        // FirestoreRepository 인스턴스를 가져오고 
                        // updateTaskCompletion 메서드를 호출해 
                        final userId = ref.watch(currentUserProvider)?.uid;
                        ref.read(firestoreRepositoryProvider)
                          .updateTaskCompletion(
                            userId: userId!,
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
                        // TODO: 수정 액션
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 30),
                      onPressed: () {
                        // TODO: 삭제 액션
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
