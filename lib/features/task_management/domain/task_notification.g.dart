// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskNotification _$TaskNotificationFromJson(Map<String, dynamic> json) =>
    _TaskNotification(
      id: json['id'] as String? ?? '',
      taskId: json['taskId'] as String,
      notificationTime: const TimestampConverter().fromJson(
        json['notificationTime'],
      ),
      isActive: json['isActive'] as bool? ?? true,
      isTriggered: json['isTriggered'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskNotificationToJson(_TaskNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'notificationTime': const TimestampConverter().toJson(
        instance.notificationTime,
      ),
      'isActive': instance.isActive,
      'isTriggered': instance.isTriggered,
    };
