import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/firebase_options.dart';
import 'package:flutter_todo_app/routes/routes.dart';

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

      // theme는 앱 전체의 디자인 스타일(색상, 글꼴 등)을 지정합니다.
      theme: ThemeData(
        // 앱의 기본 색상 팔레트를 설정합니다.
        // seedColor 하나만 지정하면 Material 3 디자인 시스템에 따라
        // 관련된 여러 색상(primary, secondary 등)이 자동으로 생성됩니다.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),

        // 앱 전체에 Material 3 디자인을 적용합니다.
        // 최신 안드로이드 디자인 가이드라인으로, 더 현대적인 UI를 제공합니다.
        // ios의 경우 Cupertino 디자인이 기본이지만,
        // Material 3를 적용하면 안드로이드와 유사한 디자인이 됩니다
        useMaterial3: true,
      ),
    );
  }
}
