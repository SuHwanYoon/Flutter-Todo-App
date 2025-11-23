import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:timezone/timezone.dart' as tz;

/// 알림 권한 요청 및 관리 헬퍼 클래스
class NotificationHelper {
  /// Android 13 이상에서 알림 권한 요청
  ///
  /// Android 13(API 33) 이상에서는 런타임에 알림 권한을 요청해야 합니다.
  /// iOS는 앱 첫 실행 시 자동으로 권한 요청 다이얼로그가 표시됩니다.
  ///
  /// Returns: 권한이 허용되면 true, 거부되면 false
  static Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();

      return granted ?? false;
    }

    // iOS 권한 요청
    if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iOSImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>();

      final bool? granted = await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return granted ?? false;
    }

    return false;
  }

  /// 알림 권한 상태 확인
  ///
  /// Android에서만 동작하며, 현재 알림 권한이 허용되었는지 확인합니다.
  /// iOS는 항상 true를 반환합니다.
  static Future<bool> checkNotificationPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.areNotificationsEnabled();

      return granted ?? false;
    }

    return true;
  }

  /// 즉시 알림 보내기
  ///
  /// [id]: 알림 ID (같은 ID를 사용하면 기존 알림이 업데이트됨)
  /// [title]: 알림 제목
  /// [body]: 알림 내용
  /// [payload]: 알림 탭 시 전달될 데이터 (선택사항)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: '중요한 알림을 위한 채널',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// 예약된 알림 스케줄링
  ///
  /// [id]: 알림 ID (같은 ID를 사용하면 기존 알림이 업데이트됨)
  /// [title]: 알림 제목 (Task title)
  /// [scheduledTime]: 알림이 발송될 시간
  /// [payload]: 알림 탭 시 전달될 데이터 (선택사항)
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: '중요한 알림을 위한 채널',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // DateTime을 TZDateTime으로 변환
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      "Don't forget!",  // 고정 메시지
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// 특정 알림 취소
  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// 모든 알림 취소
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
