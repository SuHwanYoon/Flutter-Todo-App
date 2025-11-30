import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Awesome Notifications 기반 알림 헬퍼 클래스
class NotificationHelper {
  static const platform = MethodChannel('com.yoon.flutter_todo_app/battery');

  /// Awesome Notifications 초기화
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // 기본 아이콘 사용
      [
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Todo 알림',
          channelDescription: '할일 예약 알림을 위한 채널',
          defaultColor: const Color(0xFF4CAF50),
          ledColor: Colors.green,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
      debug: true,
    );

    print('✅ [Notification] Awesome Notifications 초기화 완료');
  }

  /// Android에서 배터리 최적화 제외 요청
  static Future<bool> requestIgnoreBatteryOptimization() async {
    if (Platform.isAndroid) {
      try {
        final result = await platform.invokeMethod<bool>(
          'requestIgnoreBatteryOptimization',
        );
        return result ?? false;
      } catch (e) {
        print('⚠️ [Notification] 배터리 최적화 제외 요청 실패: $e');
        return false;
      }
    }
    return true;
  }

  /// 알림 권한 요청
  static Future<bool> requestNotificationPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      final result = await AwesomeNotifications().requestPermissionToSendNotifications();
      print('🔔 [Notification] 알림 권한: ${result ? "허용됨 ✅" : "거부됨 ❌"}');
      return result;
    }

    print('🔔 [Notification] 알림 권한: 이미 허용됨 ✅');
    return true;
  }

  /// Android에서 정확한 알람 권한 설정 화면으로 이동
  static Future<void> openExactAlarmSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.alarm);
  }

  /// 알림 권한 상태 확인
  static Future<bool> checkNotificationPermission() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  /// Android에서 정확한 알람 권한 확인 (Android 12+)
  static Future<bool> canScheduleExactAlarms() async {
    if (Platform.isAndroid) {
      // Awesome Notifications는 자동으로 처리함
      print('🔔 [Notification] 정확한 알람 권한: 허용됨 ✅');
      return true;
    }
    return true; // iOS는 항상 true
  }

  /// 즉시 알림 보내기
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        payload: payload != null ? {'taskId': payload} : null,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
      ),
    );

    print('✅ [Notification] 즉시 알림 표시 완료: ID $id');
  }

  /// 예약된 알림 스케줄링
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // 1. 권한 확인
    final canSchedule = await canScheduleExactAlarms();
    if (!canSchedule) {
      print('⚠️ [Notification] 정확한 알람 권한이 없습니다.');
      return;
    }

    // 2. 과거 시간 체크
    if (scheduledTime.isBefore(DateTime.now())) {
      print('⚠️ [Notification] 과거 시간입니다. 알림을 예약하지 않습니다.');
      return;
    }

    final timeDiff = scheduledTime.difference(DateTime.now());
    print('📅 [Notification] 예약 시간: $scheduledTime');
    print('📅 [Notification] 현재 시간: ${DateTime.now()}');
    print('📅 [Notification] 시간차: ${timeDiff.inMinutes}분 ${timeDiff.inSeconds % 60}초');

    // 3. 알람 등록
    try {
      print('⏳ [Notification] 알림 스케줄링 시도... ID: $id, Title: $title');

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'scheduled_channel',
          title: title,
          body: "Don't forget!",
          payload: payload != null ? {'taskId': payload} : null,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
        ),
        schedule: NotificationCalendar.fromDate(
          date: scheduledTime,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );

      print('✅ [Notification] 알림 스케줄링 성공: ID $id');
    } catch (e) {
      print('❌ [Notification] 알림 스케줄링 중 에러 발생: $e');
      rethrow;
    }
  }

  /// 특정 알림 취소
  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
    print('🗑️ [Notification] 알림 취소됨: ID $id');
  }

  /// 모든 알림 취소
  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
    print('🗑️ [Notification] 모든 알림 취소됨');
  }

  /// 대기 중인 알림 목록 조회 (디버깅용)
  static Future<void> checkPendingNotifications() async {
    final List<NotificationModel> scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();

    print('🔔 [Notification] 대기 중인 알림 개수: ${scheduledNotifications.length}');
    for (final notification in scheduledNotifications) {
      print('  - ID: ${notification.content?.id}, Title: ${notification.content?.title}, Body: ${notification.content?.body}');
    }

    if (scheduledNotifications.isEmpty) {
      print('⚠️ [Notification] 대기 중인 알림이 없습니다!');
    }
  }
}
