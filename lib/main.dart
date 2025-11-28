import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/firebase_options.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/main_screen.dart';
import 'package:flutter_todo_app/routes/routes.dart';
import 'package:flutter_todo_app/utils/theme_provider.dart';
import 'package:flutter_todo_app/utils/notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// 글로벌 로컬 알림 인스턴스
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 앱이 처음 시작될 때 실행되는 메인 함수입니다.
// 'async'는 이 함수 안에서 비동기(await) 작업을 할 것이라는 의미입니다.
void main() async {
  // Flutter 앱이 실행될 준비가 되었는지 확인합니다.
  // Firebase.initializeApp()과 같이 Flutter 프레임워크 초기화 이전에
  // Firebase, android, ios 같은 네이티브 코드를 호출해야 할 때 반드시 필요합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 서비스를 초기화합니다.
  // 'await'는 초기화가 끝날 때까지 기다리라는 의미입니다.
  // DefaultFirebaseOptions.currentPlatform는 현재 플랫폼(iOS, Android 등)에 맞는
  // Firebase 설정을 자동으로 가져옵니다.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 타임존 초기화 (예약 알림용)
  tz.initializeTimeZones();
  // UTC 기준으로 설정하고, DateTime.now()를 사용하면 자동으로 로컬 시간 변환됨
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  print('🌍 [Timezone] Asia/Seoul로 설정');

  // 로컬 알림 초기화
  await _initializeNotifications();

  // 배터리 최적화 제외 요청 (앱 시작 시 한 번)
  await NotificationHelper.requestIgnoreBatteryOptimization().catchError((e) {
    print('배터리 최적화 제외 요청 중 에러: $e');
    return false;
  });

  // 알림 권한 요청은 AddTaskScreen에서 토글 ON 시 요청함

  // 시스템 UI 오버레이 스타일을 설정하여 상단 상태 표시줄의 색상을 지정합니다.
  // 이 코드는 iOS와 Android 모두에서 일관된 상태 표시줄 스타일을 보장합니다.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // 상태 표시줄의 배경색을 초록색으로 설정합니다. (주로 Android에서 사용)
      statusBarColor: Colors.green,
      // 상태 표시줄의 아이콘(시간, 배터리 등) 색상을 밝게 설정합니다. (어두운 배경에 적합)
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ),
  );

  // 앱의 최상위 위젯을 실행합니다.
  // ProviderScope는 Riverpod를 사용하기 위해 앱 전체를 감싸주는 위젯입니다.
  // 이 위젯 하위에서는 Riverpod의 Provider들을 사용할 수 있습니다.
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp 클래스는 앱의 루트(root) 위젯입니다.
// ConsumerWidget을 상속받아 Riverpod의 Provider를 구독(watch)할 수 있습니다.
// 구독이라는것은 Provider의 상태가 변경될 때마다 이 위젯이 다시 그려지도록 하는 것입니다.
class MyApp extends ConsumerWidget {
  // 생성자. super.key는 부모 클래스에 key를 전달하는 역할을 합니다.
  // 여기에서 부모클래스는 ConsumerWidget입니다.
  const MyApp({super.key});

  // 이 위젯이 화면에 어떻게 보일지를 정의하는 build 메소드입니다.
  // context: 위젯 트리에 대한 정보
  // ref: Riverpod의 Provider에 접근하기 위한 객체
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 테마 모드 가져오기
    final themeMode = ref.watch(appThemeModeProvider);

    // MaterialApp.router는 GoRouter와 같은 라우팅 패키지를 사용할 때 쓰는 위젯입니다.
    return MaterialApp.router(
      // 라우팅 설정을 지정합니다.
      // ref.watch(goRouterProvider)는 goRouterProvider의 상태가 변경될 때마다
      // 이 위젯을 다시 그리도록 합니다.
      routerConfig: ref.watch(goRouterProvider),

      // 앱의 제목을 설정합니다. (예: 앱 전환기에서 보임)
      // 앱 전환기는 사용자가 현재 실행 중인 앱들을 볼 수 있는 화면입니다.
      title: 'Todo App',

      // 디버그 모드일 때 화면 오른쪽 위에 표시되는 'DEBUG' 배너를 숨깁니다.
      debugShowCheckedModeBanner: false,

      // 테마 모드 설정 (light, dark, system)
      themeMode: themeMode,

      // Light 테마 설정
      theme: lightTheme,

      // Dark 테마 설정
      darkTheme: darkTheme,
    );
  }
}

// 로컬 알림 초기화 함수
Future<void> _initializeNotifications() async {
  // Android 설정
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS 설정 (권한 요청은 토글 ON 시에만)
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  // 통합 설정
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // 초기화
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // 알림 탭 시 AllTasksScreen(탭 0)으로 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mainScreenKey.currentState?.changeTab(0);
      });
    },
  );

  // Android 알림 채널 생성 (Android 8.0+)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // 이름
    description: '중요한 알림을 위한 채널',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('notification'),
    enableLights: true,
    enableVibration: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
