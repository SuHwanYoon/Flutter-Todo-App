// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authControllerHash() => r'7967f5b6c88d896c333f945df7009caa0debe9db';

/// [AuthController]는 인증 관련 상태를 관리하고 비즈니스 로직을 처리합니다.
///
/// `AsyncNotifier`를 상속받아 비동기 상태를 관리하며,
/// `build` 메서드에서 초기 상태를 설정합니다.
///
/// 이 컨트롤러는 사용자 로그인, 회원가입, 로그아웃 등의 인증 작업을 수행합니다.
/// AsyncNotifier는 riverpod의 비동기 상태 관리용 베이스 클래스
/// state속성가지고, 상태를 AsyncLoading, AsyncError, AsyncData 형태로 다룸
///
/// Copied from [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>.internal(
      AuthController.new,
      name: r'authControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthController = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
