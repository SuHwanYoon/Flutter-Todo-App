import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';

/// 알림 권한 요청 및 관리 헬퍼 클래스
class NotificationHelper {
  // 네이티브 채널 (배터리 최적화 제외 요청용)
  static const platform = MethodChannel('com.yoon.flutter_todo_app/battery');
  
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

  /// Android에서 정확한 알람 권한 설정 화면으로 이동
  static Future<void> openExactAlarmSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.alarm);
  }

  /// 배터리 최적화 화이트리스트 요청 (Android 12+)
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

  /// Android에서 정확한 알람 권한 확인 (Android 12+)
  static Future<bool> canScheduleExactAlarms() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? canSchedule =
          await androidImplementation?.canScheduleExactNotifications();

      print('🔔 [Notification] 정확한 알람 권한: ${canSchedule == true ? "허용됨 ✅" : "거부됨 ❌"}');

      return canSchedule ?? false;
    }
    return true; // iOS는 항상 true
  }

  /// 예약된 알림 스케줄링
  ///
  /// [id]: 알림 ID (같은 ID를 사용하면 기존 알림이 업데이트됨)
  /// [title]: 알림 제목 (Task title)
  /// [scheduledTime]: 알림이 발송될 시간
  /// [payload]: 알림 탭 시 전달될 데이터 (선택사항)
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
      print('⚠️ [Notification] 정확한 알람 권한이 없습니다. Inexact 알람으로 대체합니다.');
    }

    // 2. 알림 설정 객체 생성
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: '중요한 알림을 위한 채널',
      importance: Importance.max,
      priority: Priority.max,
      // 중요: 앱이 제거되어도 알림이 유지되도록
      onlyAlertOnce: false,
      // 백그라운드에서도 울리도록
      showWhen: true,
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

    // 3. 시간 변환
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      print('⚠️ [Notification] 과거 시간입니다. 알림을 예약하지 않습니다.');
      return;
    }

    print('📅 [Notification] 예약 시간: $tzScheduledTime');
    print('📅 [Notification] 현재 시간: ${tz.TZDateTime.now(tz.local)}');
    print('📅 [Notification] 시간차: ${tzScheduledTime.difference(tz.TZDateTime.now(tz.local)).inMinutes}분');

    // 4. 알람 등록 - zonedSchedule 사용
    try {
      print('⏳ [Notification] zonedSchedule 호출 시도... ID: $id, Title: $title');
      
      // 정확한 알람 권한이 있으면 exactAllowWhileIdle 사용, 없으면 inexactAllowWhileIdle 사용
      final scheduleMode = canSchedule 
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
      
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        "Don't forget!",
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: scheduleMode,
        payload: payload,
      );
      print('✅ [Notification] 알림 스케줄링 성공: ID $id (Mode: ${scheduleMode.toString()})');
    } catch (e) {
      print('❌ [Notification] 알림 스케줄링 중 에러 발생: $e');
      rethrow;
    }
  }

  /// 특정 알림 취소
  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// 모든 알림 취소
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// 대기 중인 알림 목록 조회 (디버깅용)
  static Future<void> checkPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    print('🔔 [Notification] 대기 중인 알림 개수: ${pendingNotifications.length}');
    for (final notification in pendingNotifications) {
      print('  - ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }

    if (pendingNotifications.isEmpty) {
      print('⚠️ [Notification] 대기 중인 알림이 없습니다!');
    }
  }
}
