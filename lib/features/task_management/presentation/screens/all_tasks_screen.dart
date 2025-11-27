import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/common_wigets/async_value_ui.dart';
import 'package:flutter_todo_app/common_wigets/async_value_widget.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/notification_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:flutter_todo_app/features/task_management/presentation/controller/task_sort_controller.dart';
import 'package:flutter_todo_app/features/task_management/presentation/controller/firestore_controller.dart';
import 'package:flutter_todo_app/features/task_management/presentation/controller/task_sort_controller.dart';
import 'package:flutter_todo_app/features/task_management/presentation/widgets/task_item.dart';

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({super.key});

  // 우선순위를 숫자로 변환하는 헬퍼 함수
  int _priorityToNumber(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // firebase의 User에서 현재 사용자의 ID를 가져옵니다.
    final userId = ref.watch(currentUserProvider)?.uid;
    // 현재 정렬 옵션을 가져옵니다.
    final sortOption = ref.watch(taskSortControllerProvider);

    // userId가 null이 아니면 loadTasksProvider를 사용하여 작업 목록을 비동기적으로 로드합니다.
    final taskAsyncValue = userId == null
        ? const AsyncData<List<Task>>([])
        : ref.watch(loadTasksProvider(userId));

    // 알림 시간순 정렬을 위한 알림 목록 (알림 정렬일 때만 사용)
    final notificationsAsync =
        userId != null && sortOption == TaskSortOption.notificationTime
            ? ref.watch(loadNotificationsProvider(userId))
            : null;

    // userId가 null이 아닐 때만 provider를 listen합니다.
    if (userId != null) {
      ref.listen<AsyncValue>(loadTasksProvider(userId), (_, state) {
        state.whenOrNull(
          error: (error, stackTrace) {
            debugPrint('loadTasks error: $error');
            debugPrint('$stackTrace');
            state.showAlertDialogOnError(context);
          },
        );
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          actions: [
            // 전체 작업 관리 메뉴
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: '전체 작업 관리',
              onSelected: (value) async {
                if (userId == null) return;

                switch (value) {
                  case 'complete_all':
                    await _showCompleteAllDialog(
                        context, ref, userId, taskAsyncValue);
                    break;
                  case 'incomplete_all':
                    await _showIncompleteAllDialog(
                        context, ref, userId, taskAsyncValue);
                    break;
                  case 'delete_all':
                    await _showDeleteAllDialog(
                        context, ref, userId, taskAsyncValue);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'complete_all',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 20),
                      SizedBox(width: 12),
                      Text('전체 완료'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'incomplete_all',
                  child: Row(
                    children: [
                      Icon(Icons.radio_button_unchecked, size: 20),
                      SizedBox(width: 12),
                      Text('전체 미완료'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 12),
                      Text('전체 삭제', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // 정렬 UI
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<TaskSortOption>(
                    tooltip: 'Sort tasks',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            sortOption.displayName,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_downward,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),
                    onSelected: (option) {
                      ref
                          .read(taskSortControllerProvider.notifier)
                          .setSortOption(option);
                    },
                    itemBuilder: (context) =>
                        TaskSortOption.values.map((option) {
                      final isSelected = sortOption == option;
                      return PopupMenuItem<TaskSortOption>(
                        value: option,
                        child: Row(
                          children: [
                            Icon(
                              option.icon,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              option.displayName,
                              style: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                            ),
                            if (isSelected) ...[
                              const Spacer(),
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Task 목록
            Expanded(
              child: AsyncValueWidget<List<Task>>(
                value: taskAsyncValue,
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Center(child: Text('No tasks'));
                  }

                  // 정렬된 Task 목록 생성
                  List<Task> sortedTasks = List.from(tasks);

                  // 알림 시간순 정렬인 경우
                  if (sortOption == TaskSortOption.notificationTime &&
                      notificationsAsync != null) {
                    return notificationsAsync.when(
                      data: (notifications) {
                        // taskId -> notificationTime 매핑
                        final notificationMap = {
                          for (var n in notifications)
                            n.taskId: n.notificationTime
                        };

                        sortedTasks.sort((a, b) {
                          final aTime = notificationMap[a.id];
                          final bTime = notificationMap[b.id];

                          // 알림이 없는 항목은 맨 뒤로
                          if (aTime == null && bTime == null) return 0;
                          if (aTime == null) return 1;
                          if (bTime == null) return -1;

                          return aTime.compareTo(bTime);
                        });

                        return _buildTaskList(sortedTasks);
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) =>
                          _buildTaskList(_sortTasks(sortedTasks, sortOption)),
                    );
                  }

                  // 일반 정렬
                  sortedTasks = _sortTasks(sortedTasks, sortOption);
                  return _buildTaskList(sortedTasks);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Task 정렬 로직
  List<Task> _sortTasks(List<Task> tasks, TaskSortOption sortOption) {
    final sortedTasks = List<Task>.from(tasks);

    switch (sortOption) {
      case TaskSortOption.dateNewest:
        sortedTasks.sort((a, b) => b.date.compareTo(a.date));
        break;
      case TaskSortOption.dateOldest:
        sortedTasks.sort((a, b) => a.date.compareTo(b.date));
        break;
      case TaskSortOption.priorityHigh:
        sortedTasks.sort((a, b) =>
            _priorityToNumber(b.priority)
                .compareTo(_priorityToNumber(a.priority)));
        break;
      case TaskSortOption.completedFirst:
        sortedTasks.sort((a, b) {
          if (a.isCompleted == b.isCompleted) return 0;
          return a.isCompleted ? -1 : 1;
        });
        break;
      case TaskSortOption.incompleteFirst:
        sortedTasks.sort((a, b) {
          if (a.isCompleted == b.isCompleted) return 0;
          return a.isCompleted ? 1 : -1;
        });
        break;
      case TaskSortOption.notificationTime:
        // 알림 시간순은 별도 처리
        break;
    }

    return sortedTasks;
  }

  // Task 목록 위젯 빌드
  Widget _buildTaskList(List<Task> tasks) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(task);
      },
      separatorBuilder: (context, height) =>
          const Divider(height: 2, color: Colors.blue),
      itemCount: tasks.length,
    );
  }

  // 전체 완료 다이얼로그
  Future<void> _showCompleteAllDialog(
    BuildContext context,
    WidgetRef ref,
    String userId,
    AsyncValue<List<Task>> taskAsyncValue,
  ) async {
    final tasksToComplete =
        taskAsyncValue.value?.where((task) => !task.isCompleted).toList() ?? [];

    if (tasksToComplete.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('완료할 작업이 없습니다')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 완료'),
        content: Text('${tasksToComplete.length}개의 작업을 모두 완료 처리하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('완료'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final taskIds = tasksToComplete.map((task) => task.id).toList();
      await ref.read(firestoreControllerProvider.notifier).batchUpdateTasksCompletion(
            userId: userId,
            taskIds: taskIds,
            isCompleted: true,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${tasksToComplete.length}개 작업을 완료했습니다')),
        );
      }
    }
  }

  // 전체 미완료 다이얼로그
  Future<void> _showIncompleteAllDialog(
    BuildContext context,
    WidgetRef ref,
    String userId,
    AsyncValue<List<Task>> taskAsyncValue,
  ) async {
    final tasksToIncomplete =
        taskAsyncValue.value?.where((task) => task.isCompleted).toList() ?? [];

    if (tasksToIncomplete.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('미완료 처리할 작업이 없습니다')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 미완료'),
        content: Text('${tasksToIncomplete.length}개의 작업을 모두 미완료 처리하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('미완료'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final taskIds = tasksToIncomplete.map((task) => task.id).toList();
      await ref.read(firestoreControllerProvider.notifier).batchUpdateTasksCompletion(
            userId: userId,
            taskIds: taskIds,
            isCompleted: false,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${tasksToIncomplete.length}개 작업을 미완료로 변경했습니다')),
        );
      }
    }
  }

  // 전체 삭제 다이얼로그
  Future<void> _showDeleteAllDialog(
    BuildContext context,
    WidgetRef ref,
    String userId,
    AsyncValue<List<Task>> taskAsyncValue,
  ) async {
    final tasks = taskAsyncValue.value ?? [];
    if (tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제할 작업이 없습니다')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 삭제'),
        content: Text(
          '${tasks.length}개의 작업을 모두 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final taskIds = tasks.map((task) => task.id).toList();

      // 알림도 함께 삭제
      await ref.read(notificationRepositoryProvider).batchDeleteNotificationsForTasks(
            userId: userId,
            taskIds: taskIds,
          );

      // Task 삭제
      await ref.read(firestoreControllerProvider.notifier).batchDeleteTasks(
            userId: userId,
            taskIds: taskIds,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${tasks.length}개 작업을 삭제했습니다')),
        );
      }
    }
  }
}
