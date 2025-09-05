import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/presentation/screens/register_screen.dart';
import 'package:flutter_todo_app/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/main_screen.dart';
import 'package:flutter_todo_app/routes/go_router_refresh_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

// 'part'는 이 파일의 일부임을 나타냅니다.
// 'routes.g.dart' 파일은 riverpod_generator가 자동으로 생성하는 코드를 담고 있습니다.
// riverpod_generator는 이 파일을 기반으로 필요한 코드를 자동으로 생성합니다.
// 예를 들어, goRouter 함수에 대한 Provider 코드를 생성합니다.
part 'routes.g.dart';

// 앱에서 사용할 라우트(화면 경로)들의 이름을 안전하게 관리하기 위한 열거형(enum)입니다.
// 이렇게 하면 'main' 대신 AppRoutes.main.name처럼 오타 없이 사용할 수 있습니다.
enum AppRoutes { main, signIn, register }

// FirebaseAuth 인스턴스를 제공하는 Riverpod Provider입니다.
// Provider란 Riverpod에서 데이터를 제공하는 객체입니다.
// 여기서는 FirebaseAuth.instance라는 FirebaseAuth 클래스의 싱글톤 인스턴스를 제공합니다.
// 앱의 다른 부분에서 FirebaseAuth.instance를 쉽게 가져와 사용할 수 있게 해줍니다.
// final은 변경 불가능한 변수를 선언할 때 사용합니다.
// 여기서 firebaseAuthProvider를 final로 선언한 이유는 FirebaseAuth 인스턴스는
// 변경되지 않는다는 것을 명확히 하기 위함입니다.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Riverpod Annotation을 사용하여 GoRouter 인스턴스를 제공하는 Provider를 생성합니다.
// 이 클래스는 앱의 전체적인 라우팅 설정을 담당합니다.
// Ref 객체는 Riverpod의 다른 Provider에 접근하거나, Provider의 상태를 감시(watch)하고 읽을(read) 수 있게 해줍니다.
@riverpod
GoRouter goRouter(Ref ref) {
  // ref.watch를 사용하여 위에서 선언한 firebaseAuthProvider 인스턴스의 상태를 감시합니다.
  // FirebaseAuth 인스턴스를 가져옵니다.
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  // GoRouter의 설정을 정의하고 인스턴스를 생성하여 반환합니다.
  return GoRouter(
    // 앱이 처음 시작될 때 보여줄 경로를 지정합니다.
    // redirect 로직에 따라 실제로는 로그인 상태를 확인 후 다른 화면으로 이동될 수 있습니다.
    initialLocation: '/main',

    // 라우팅 관련 동작을 콘솔에 로그로 출력할지 여부를 설정합니다. 개발 중 디버깅에 유용합니다.
    debugLogDiagnostics: true,

    // 화면 이동이 발생하기 전에 특정 조건에 따라 다른 경로로 리다이렉트(방향 전환)하는 로직입니다.
    // context는 GoRouterState 객체로, 현재 라우팅 상태에 대한 정보를 담고 있습니다.
    // state는 현재 라우팅 상태를 나타내며, 사용자가 이동하려는 경로 등의 정보를 포함합니다.
    redirect: (context, state) {
      // 현재 사용자가 로그인했는지 여부를 확인합니다. (currentUser가 null이 아니면 true)
      final isLoggedIn = firebaseAuth.currentUser != null;

      // 사용자가 가려고 하는 경로(URI)를 문자열로 가져옵니다.
      final goingTo = state.uri.toString();

      // 일반적으로 로그인한 사용자가 로그인, 회원가입페이지를 볼수는 없지만
      // 앱내부 링크 등에서 다른 화면에서 잘못된 경로로 이동하려고 할때
      // 앱이 켜질때 초기경로(/signIn)등 이 설정되어있을경우
      // 이러한 예외상황을 방지하기 위한 로직
      // 1. 이미 로그인한 사용자가 로그인 페이지나 회원가입 페이지로 가려고 할 때
      if (isLoggedIn && (goingTo == '/signIn' || goingTo == '/register')) {
        // 메인 화면('/main')으로 보냅니다.
        return '/main';
      }
      // 2. 로그인하지 않은 사용자가 로그인이 필요한 페이지('/main'으로 시작하는 모든 경로)로 가려고 할 때
      else if (!isLoggedIn && goingTo.startsWith('/main')) {
        // 로그인 화면('/signIn')으로 보냅니다.
        return '/signIn';
      }

      // 3. 위의 두 가지 경우에 해당하지 않으면, 아무런 처리도 하지 않고 원래 가려던 경로로 이동시킵니다.
      // 경로 변경이 필요없는 경우는 사용자가 요청한 화면으로 그냥 이동
      return null;
    },

    // refreshListenable은 라우팅 상태를 다시 평가해야 할 때를 알려주는 프로퍼티
    // 라우팅상태를 다시 평가할때라는것은 즉 redirect 로직을 다시 실행할때를 의미
    // 여기서는 Firebase의 인증 상태(로그인, 로그아웃)가 변경될 때마다
    // 위의 redirect 로직을 다시 실행하도록 설정합니다.
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),

    // 앱에서 사용될 모든 경로와 해당 경로에 연결될 화면을 정의합니다.
    routes: [
      GoRoute(
        // 경로 주소
        path: '/main',
        // 경로 이름 상단에 선언된 (AppRoutes enum 사용)
        name: AppRoutes.main.name,
        // 이 경로로 이동했을 때 보여줄 위젯(화면)
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoutes.signIn.name,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}
