import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/common_wigets/async_value_ui.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';

class IncompleteTasksScreen extends ConsumerWidget {
  const IncompleteTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // firebase의 User에서 현재 사용자의 ID를 가져옵니다.
    final userId = ref.watch(currentUserProvider)?.uid;
    // userId가 null이 아니면 loadCompletedTasksProvider를 사용하여 작업 목록을 비동기적으로 로드합니다.
    // completeTasksAsyncValue는 Provider를 watch하고 있기때문에
    // AsyncValue 타입이며, 로딩, 오류, 데이터 상태를 포함할 수 있습니다.
    // 이 값을 사용하여 UI를 적절하게 렌더링할 수 있습니다.
    // loadCompletedTasksProvider가 userId String을 매개변수로 받기 때문에
    // userId가 null이 아닐 때만 호출되도록 합니다.
    final completeTasksAsyncValue = ref.watch(loadCompletedTasksProvider(userId!));

    ref.listen<AsyncValue>(loadCompletedTasksProvider(userId), (_, state) {
      // 만들어둔 asyncValueUi 확장의 showAlertDialogOnError 메서드를 호출하여
      // 에러가 발생했을 때 다이얼로그를 표시합니다.
      state.showAlertDialogOnError(context);
    });

    return const Scaffold(
      body: Center(
        child: Text('Incomplete Tasks Screen'),
      ),
    );
  }
}
