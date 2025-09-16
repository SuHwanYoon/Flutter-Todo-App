import 'dart:async';


import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// [AuthController]는 인증 관련 상태를 관리하고 비즈니스 로직을 처리합니다.
///
/// `AsyncNotifier`를 상속받아 비동기 상태를 관리하며,
/// `build` 메서드에서 초기 상태를 설정합니다.
///
/// 이 컨트롤러는 사용자 로그인, 회원가입, 로그아웃 등의 인증 작업을 수행합니다.
/// AsyncNotifier는 riverpod의 비동기 상태 관리용 베이스 클래스
/// state속성가지고, 상태를 AsyncLoading, AsyncError, AsyncData 형태로 다룸
@Riverpod(keepAlive: true)
class AuthController extends AsyncNotifier<void> {
  ///`FutureOr<T>`는 `Future<T>` 또는 `T` 타입이 될 수 있음을 나타냅니다.
  /// 즉, 비동기적으로 값을 반환하거나 동기적으로 값을 즉시 반환할 수 있습니다.
  /// 이 메서드는 Notifier가 처음 생성될 때 호출되며, 초기 상태를 설정합니다.
  @override
  FutureOr<void> build() {
    // 초기 상태는 아무것도 하지 않으므로 UnimplementedError를 발생시킵니다.
    // 실제 초기화 로직이 필요하다면 여기에 구현합니다.
    throw UnimplementedError();
  }

  /// createUserWithEmailAndPassword는 사용자 계정을 생성하는 비동기 메서드입니다.
  /// [email] 사용자의 이메일 주소
  /// [password] 사용자의 비밀번호
  /// state 상태변수가 바뀜
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // 상태를 로딩 중으로 설정하여 UI에 로딩 상태를 알립니다.
    state = const AsyncLoading();
    // authRepositoryProvider를 통해 실제 회원가입 로직을 호출하고,
    // 결과를 AsyncValue.guard를 통해 상태에 반영합니다.
    // guard는 예외가 발생하면 AsyncError로 상태를 변경해줍니다.
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(email, password),
    );
  }

  /// signInWithEmailAndPassword는 사용자 로그인을 처리하는 비동기 메서드입니다.
  /// [email] 사용자의 이메일 주소
  /// [password] 사용자의 비밀번호
  /// state 상태변수가 바뀜
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // 상태를 로딩 중으로 설정하여 UI에 로딩 상태를 알립니다.
    state = const AsyncLoading();
    // authRepositoryProvider를 통해 실제 로그인 로직을 호출하고,
    // 결과를 AsyncValue.guard를 통해 상태에 반영합니다.
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password),
    );
  }

  /// signOut는 사용자 로그아웃을 처리하는 비동기 메서드입니다.
  /// state 상태변수가 바뀜
  Future<void> signOut() async {
    // 상태를 로딩 중으로 설정하여 UI에 로딩 상태를 알립니다.
    state = const AsyncLoading();
    // authRepositoryProvider를 통해 실제 로그아웃 로직을 호출하고,
    // 결과를 AsyncValue.guard를 통해 상태에 반영합니다.
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
  }

}