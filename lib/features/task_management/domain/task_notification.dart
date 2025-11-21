import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_todo_app/utils/time_stamp_converter.dart';

part 'task_notification.freezed.dart';
part 'task_notification.g.dart';

@freezed
abstract class TaskNotification with _$TaskNotification {
  const factory TaskNotification({
    @Default('') String id,
    required String taskId, // Associated task ID
    @TimestampConverter() required DateTime notificationTime,
    @Default(true) bool isActive, // Notification is active or disabled
    @Default(false) bool isTriggered, // Notification has been triggered
  }) = _TaskNotification;

  factory TaskNotification.fromJson(Map<String, dynamic> json) =>
      _$TaskNotificationFromJson(json);
}

