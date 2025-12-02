import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'auth_repository.g.dart';

/// [AuthRepository] 클래스는 Firebase 인증을 처리하는 역할을 합니다.
/// 이 클래스는 FirebaseAuth 인스턴스를 사용하여 이메일과 비밀번호로 사용자를 생성하고 로그인하며,
/// 인증 상태 변경을 스트리밍하고, 현재 사용자를 가져오고, 사용자를 로그아웃하는 메서드를 제공합니다.
class AuthRepository {
  /// [AuthRepository] 생성자입니다.
  /// FirebaseAuth 인스턴스를 매개변수로 받습니다.
  AuthRepository(this._auth);

  /// FirebaseAuth 인스턴스입니다.
  // final _auth = FirebaseAuth.instance;
  final FirebaseAuth _auth;

  /// FirebaseAuth로 이메일과 비밀번호로 사용자를 로그인합니다.
  ///
  /// [Future]는 한 번만 반환되는 비동기 작업의 결과를 표현하는 객체입니다.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// FirebaseAuth로 이메일과 비밀번호로 새로운 사용자를 생성합니다.
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// 현재 로그인된 사용자를 가져옵니다.
  ///
  /// `get`은 getter 메소드를 정의할 때 사용합니다.
  User? get currentUser {
    return _auth.currentUser;
  }

  /// 인증 상태 변경을 스트리밍합니다.
  ///
  /// [Stream]은 여러 번 연속적으로 발생하는 비동기 데이터 흐름을 표현하는 객체입니다.
  /// 인증 상태 변경 이벤트가 발생할 때마다 새 값을 내보냅니다.
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// 현재 사용자를 로그아웃합니다.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// 비밀번호로 재인증합니다.
  /// 계정 삭제 전 비밀번호 확인용으로 사용합니다.
  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('User not found');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  /// 현재 사용자의 계정을 삭제합니다.
  /// 재인증 후 호출해야 합니다.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not found');
    }
    await user.delete();
  }

  /// Google 계정으로 로그인합니다.
  /// Google Sign-In 플로우를 시작하고, 사용자가 인증을 완료하면
  /// Firebase Authentication에 Google 자격 증명으로 로그인합니다.
  /// 사용자가 로그인을 취소하면 null을 반환합니다.
  Future<UserCredential?> signInWithGoogle() async {
    // Google Sign-In 인스턴스 생성
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Google 로그인 플로우 시작
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // 사용자가 로그인을 취소한 경우
    if (googleUser == null) {
      return null;
    }

    // Google 인증 정보 가져오기
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Firebase 인증 자격 증명 생성
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase에 로그인
    return await _auth.signInWithCredential(credential);
  }

  /// Apple 계정으로 로그인합니다.
  /// Sign in with Apple 플로우를 시작하고, 사용자가 인증을 완료하면
  /// Firebase Authentication에 Apple 자격 증명으로 로그인합니다.
  Future<UserCredential> signInWithApple() async {
    // Apple Sign-In 플로우 시작
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.yoon.flutterTodoApp.web', // 1-1에서 생성한 Service ID
        redirectUri: Uri.parse(
          'https://flutter-firebase-fd0f7.firebaseapp.com/__/auth/handler',
        ),
      ),
    );

    // Firebase 인증 자격 증명 생성
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Firebase에 로그인
    return await _auth.signInWithCredential(oauthCredential);
  }
}

/// [authRepositoryProvider]는 [AuthRepository]의 인스턴스를 제공하는 Riverpod 프로바이더입니다.
///
/// 전역 서비스, 인증 상태 관리, DB 연결 등
/// 한 번 생성 후 계속 유지하고 싶은 객체에는 `keepAlive: true`로 앱 종료 전까지 Provider가 살아있습니다.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance);
}

/// [authStateChangeProvider]는 인증 상태 변경 스트림을 제공하는 Riverpod 프로바이더입니다.
///
/// `authStateChange` Riverpod 메서드입니다.
@Riverpod(keepAlive: true)
Stream<User?> authStateChange(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}

/// [currentUserProvider]는 현재 로그인된 사용자를 제공하는 Riverpod 프로바이더입니다.
///
/// `currentUser` Riverpod 메서드입니다.
@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  // final authRepository = ref.watch(authRepositoryProvider);
  // return authRepository.currentUser;

  // authStateChangeProvider는 인증상태변경스트림(Stream<User?>)을 구독해서
  // 자신의 상태를 자동으로 업데이트하도록 만듬
  // authStateChangeProvider를 watch하여 인증 상태 변경을 감지하고,
  // 스트림이 새로운 User 객체를 전달하면 그 값을 반환합니다.
  return ref.watch(authStateChangeProvider).value;
}
