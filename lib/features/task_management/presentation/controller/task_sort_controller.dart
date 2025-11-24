import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_sort_controller.g.dart';

// 정렬 옵션 enum
enum TaskSortOption {
  dateNewest,      // 생성일 (최신순)
  dateOldest,      // 생성일 (오래된순)
  priorityHigh,    // 우선순위 (높은순)
  completedFirst,  // 완료 상태 (완료 먼저)
  incompleteFirst, // 완료 상태 (미완료 먼저)
  notificationTime,// 알림 시간순
}

// 정렬 옵션 표시 이름
extension TaskSortOptionExtension on TaskSortOption {
  String get displayName {
    switch (this) {
      case TaskSortOption.dateNewest:
        return 'Newest First';
      case TaskSortOption.dateOldest:
        return 'Oldest First';
      case TaskSortOption.priorityHigh:
        return 'Priority (High to Low)';
      case TaskSortOption.completedFirst:
        return 'Completed First';
      case TaskSortOption.incompleteFirst:
        return 'Incomplete First';
      case TaskSortOption.notificationTime:
        return 'Notification Time';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskSortOption.dateNewest:
      case TaskSortOption.dateOldest:
        return Icons.calendar_today;
      case TaskSortOption.priorityHigh:
        return Icons.flag;
      case TaskSortOption.completedFirst:
      case TaskSortOption.incompleteFirst:
        return Icons.check_circle;
      case TaskSortOption.notificationTime:
        return Icons.notifications;
    }
  }
}

// 정렬 상태 Provider
@Riverpod(keepAlive: true)
class TaskSortController extends _$TaskSortController {
  @override
  TaskSortOption build() {
    return TaskSortOption.dateNewest; // 기본값: 최신순
  }

  void setSortOption(TaskSortOption option) {
    state = option;
  }
}
