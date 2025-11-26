import 'dart:async';

import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';
import 'package:flutter_todo_app/features/task_management/data/notification_repository.dart';
import 'package:flutter_todo_app/utils/notification_helper.dart';
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

    // 로그인 성공 시 알림 재스케줄링
    if (!state.hasError) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await _rescheduleNotifications(user.uid);
      }
    }
  }

  /// signInWithGoogle은 Google 계정으로 로그인을 처리하는 비동기 메서드입니다.
  /// state 상태변수가 바뀜
  Future<void> signInWithGoogle() async {
    // 상태를 로딩 중으로 설정하여 UI에 로딩 상태를 알립니다.
    state = const AsyncLoading();
    // authRepositoryProvider를 통해 Google 로그인 로직을 호출하고,
    // 결과를 AsyncValue.guard를 통해 상태에 반영합니다.
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signInWithGoogle(),
    );

    // 로그인 성공 시 알림 재스케줄링
    if (!state.hasError) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await _rescheduleNotifications(user.uid);
      }
    }
  }

  /// signInWithApple은 Apple 계정으로 로그인을 처리하는 비동기 메서드입니다.
  /// state 상태변수가 바뀜
  Future<void> signInWithApple() async {
    // 상태를 로딩 중으로 설정하여 UI에 로딩 상태를 알립니다.
    state = const AsyncLoading();
    // authRepositoryProvider를 통해 Apple 로그인 로직을 호출하고,
    // 결과를 AsyncValue.guard를 통해 상태에 반영합니다.
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signInWithApple(),
    );

    // 로그인 성공 시 알림 재스케줄링
    if (!state.hasError) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        await _rescheduleNotifications(user.uid);
      }
    }
  }

  /// signOut는 사용자 로그아웃을 처리하는 비동기 메서드입니다.
  /// state 상태변수가 바뀜
  Future<void> signOut() async {
    // 상태를 로딩 중으로 설정하여 UI에 로딩 상태를 알립니다.
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();

    // 로그아웃 전에 모든 로컬 알림 취소
    await NotificationHelper.cancelAllNotifications();

    state = await AsyncValue.guard(authRepository.signOut);

    /// invalidate는 특정 프로바이더의 상태를 무효화하여 다음에 해당 프로바이더를 읽을 때
    /// 새로운 상태를 생성하도록 지시합니다.
    /// 여기서는 로그아웃 성공 시 currentUserProvider와 AuthController 자체의 상태를 무효화하여
    /// 사용자 정보 및 인증 컨트롤러의 상태를 초기화합니다.

    if (!state.hasError) {
      // 로그아웃 성공 시 관련된 프로바이더들을 초기화합니다.
      ref.invalidate(currentUserProvider);
      ref.invalidateSelf();
    }
  }

  /// 로그인 시 Firestore에서 알림 데이터를 가져와 로컬 알림으로 재스케줄링
  Future<void> _rescheduleNotifications(String userId) async {
    final notificationRepository = ref.read(notificationRepositoryProvider);
    final notifications = await notificationRepository.getAllNotifications(userId: userId);

    final now = DateTime.now();
    for (final notification in notifications) {
      // 미래의 알림만 스케줄링
      if (notification.notificationTime.isAfter(now)) {
        await NotificationHelper.scheduleNotification(
          id: notification.taskId.hashCode,
          title: 'Task Reminder', // Task 제목을 가져오려면 추가 쿼리 필요
          scheduledTime: notification.notificationTime,
          payload: notification.taskId,
        );
      }
    }
  }

  /// deleteAccount는 사용자 계정을 완전히 삭제하는 비동기 메서드입니다.
  /// [password]를 사용하여 재인증 후 삭제합니다.
  /// 1. 재인증 (비밀번호 확인) - 먼저 확인해야 데이터 손실 방지
  /// 2. 모든 로컬 알림 취소
  /// 3. Firestore에서 사용자 데이터 삭제 (tasks, notifications)
  /// 4. Firebase Auth에서 계정 삭제
  Future<void> deleteAccount({required String password}) async {
    state = const AsyncLoading();

    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncError('User not found', StackTrace.current);
      return;
    }

    final userId = user.uid;
    final authRepository = ref.read(authRepositoryProvider);

    // 1. 먼저 비밀번호 확인 (재인증)
    try {
      await authRepository.reauthenticate(password);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return;
    }

    // 2. 재인증 성공 후 데이터 삭제 진행
    state = await AsyncValue.guard(() async {
      // 모든 로컬 알림 취소
      await NotificationHelper.cancelAllNotifications();

      // Firestore에서 사용자 데이터 삭제
      final firestoreRepository = ref.read(firestoreRepositoryProvider);
      await firestoreRepository.deleteUserData(userId: userId);

      // Firebase Auth에서 계정 삭제
      await authRepository.deleteAccount();
    });

    if (!state.hasError) {
      // 계정 삭제 성공 시 관련된 프로바이더들을 초기화합니다.
      ref.invalidate(currentUserProvider);
      ref.invalidateSelf();
    }
  }
}
