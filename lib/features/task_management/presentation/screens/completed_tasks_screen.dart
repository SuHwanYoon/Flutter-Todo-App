import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/common_wigets/async_value_ui.dart';
import 'package:flutter_todo_app/common_wigets/async_value_widget.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:flutter_todo_app/features/task_management/presentation/widgets/task_item.dart';

class CompletedTasksScreen extends ConsumerWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        // firebase의 User에서 현재 사용자의 ID를 가져옵니다.
    final userId = ref.watch(currentUserProvider)?.uid;
    // userId가 null이 아니면 loadCompletedTasksProvider를 사용하여 작업 목록을 비동기적으로 로드합니다.
    // completeTasksAsyncValue는 Provider를 watch하고 있기때문에
    // AsyncValue 타입이며, 로딩, 오류, 데이터 상태를 포함할 수 있습니다.
    // 이 값을 사용하여 UI를 적절하게 렌더링할 수 있습니다.
    // loadIncompleteTasksProvider가 userId String을 매개변수로 받기 때문에
    // userId가 null이 아닐 때만 호출되도록 합니다.
    final completeTasksAsyncValue = userId == null
        ? const AsyncData<List<Task>>([])
        : ref.watch(loadCompletedTasksProvider(userId));

    if (userId != null) {
      ref.listen<AsyncValue>(loadCompletedTasksProvider(userId), (_, state) {
        state.whenOrNull(
          error: (error, stackTrace) {
            // 에러가 발생했을 때 콘솔에 에러 메시지를 출력합니다.
            // ignore: avoid_print
            debugPrint('loadCompleteTasks error: $error');
            debugPrint('$stackTrace');
            // 만들어둔 asyncValueUi 확장의 showAlertDialogOnError 메서드를 호출하여
            // 에러가 발생했을 때 다이얼로그를 표시합니다.
            state.showAlertDialogOnError(context);
          },
        );
        // state.showAlertDialogOnError(context);
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Complete Tasks')),
        // 작업 목록을 표시하는 본문입니다.
        // AsyncValue를 사용하여 비동기적으로 작업 목록을 로드하고 상태에 따라 UI를 업데이트합니다.
        // value: taskAsyncValue를 전달하여 현재 상태를 반영합니다.
        // data 콜백 함수는 작업 목록이 성공적으로 로드되었을 때 호출됩니다.
        body: AsyncValueWidget<List<Task>>(
          value: completeTasksAsyncValue,
          data: (tasks) {
            // 작업 목록이 비어있으면 'No tasks' 메시지를 표시합니다.
            // 그렇지 않으면 ListView.separated를 사용하여 작업 목록을 표시합니다.
            return tasks.isEmpty
                ? const Center(child: Text('No tasks'))
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskItem(task);
                    },
                    separatorBuilder: (context, height) =>
                        const Divider(height: 2, color: Colors.blue),
                    itemCount: tasks.length,
                  );
          },
        ),
      ),
    );
  }
}