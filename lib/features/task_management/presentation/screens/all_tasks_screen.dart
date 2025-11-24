import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/common_wigets/async_value_ui.dart';
import 'package:flutter_todo_app/common_wigets/async_value_widget.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/notification_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
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
    final notificationsAsync = userId != null && sortOption == TaskSortOption.notificationTime
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
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
                      ref.read(taskSortControllerProvider.notifier).setSortOption(option);
                    },
                    itemBuilder: (context) => TaskSortOption.values.map((option) {
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
            if (sortOption == TaskSortOption.notificationTime && notificationsAsync != null) {
              return notificationsAsync.when(
                data: (notifications) {
                  // taskId -> notificationTime 매핑
                  final notificationMap = {
                    for (var n in notifications) n.taskId: n.notificationTime
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => _buildTaskList(_sortTasks(sortedTasks, sortOption)),
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
            _priorityToNumber(b.priority).compareTo(_priorityToNumber(a.priority)));
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
}
