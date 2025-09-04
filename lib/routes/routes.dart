import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/presentation/screens/register_screen.dart';
import 'package:flutter_todo_app/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/main_screen.dart';
import 'package:flutter_todo_app/routes/go_router_refresh_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

enum AppRoutes { main, signIn, register }

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

@riverpod
GoRouter goRouter(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  return GoRouter(
    initialLocation: '/main',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;
      // 로그인 상태에 따라 리다이렉트 경로 설정
      // 로그인 상태이고, 현재 경로가 '/signIn' 또는 '/register'인 경우 '/main'으로 리다이렉트
      // 비로그인 상태이고, 현재 경로가 '/main'으로 시작하는 경우 signIn으로 리다이렉트
      // 어느쪽도 아니경우 null 반환
      if (isLoggedIn &&
          (state.uri.toString() == '/signIn' ||
              state.uri.toString() == '/register')) {
        return '/main';
      } else if (!isLoggedIn && state.uri.toString().startsWith('/main')) {
        return '/signIn';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/main',
        name: AppRoutes.main.name,
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
