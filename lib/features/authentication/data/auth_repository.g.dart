// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'fa5b8337b7daf1a6e6ab14268c91ea9089629ec0';

/// [authRepositoryProvider]는 [AuthRepository]의 인스턴스를 제공하는 Riverpod 프로바이더입니다.
///
/// 전역 서비스, 인증 상태 관리, DB 연결 등
/// 한 번 생성 후 계속 유지하고 싶은 객체에는 `keepAlive: true`로 앱 종료 전까지 Provider가 살아있습니다.
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authStateChangeHash() => r'490200634bc0a038c0b4e84317e9641196d56de3';

/// [authStateChangeProvider]는 인증 상태 변경 스트림을 제공하는 Riverpod 프로바이더입니다.
///
/// `authStateChange` Riverpod 메서드입니다.
///
/// Copied from [authStateChange].
@ProviderFor(authStateChange)
final authStateChangeProvider = StreamProvider<User?>.internal(
  authStateChange,
  name: r'authStateChangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateChangeRef = StreamProviderRef<User?>;
String _$currentUserHash() => r'f5ad9f4618788565910c35a3305bab0d62b13c99';

/// [currentUserProvider]는 현재 로그인된 사용자를 제공하는 Riverpod 프로바이더입니다.
///
/// `currentUser` Riverpod 메서드입니다.
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = Provider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = ProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
