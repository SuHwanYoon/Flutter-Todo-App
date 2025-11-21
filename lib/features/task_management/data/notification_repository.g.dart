// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRepositoryHash() =>
    r'ef7f36e7094dfb0507f157c91660d7c773a80b0e';

/// See also [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    Provider<NotificationRepository>.internal(
      notificationRepository,
      name: r'notificationRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationRepositoryRef = ProviderRef<NotificationRepository>;
String _$taskNotificationHash() => r'13422d264a27b2cdf0aebe3a62fb13c601b97e89';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [taskNotification].
@ProviderFor(taskNotification)
const taskNotificationProvider = TaskNotificationFamily();

/// See also [taskNotification].
class TaskNotificationFamily extends Family<AsyncValue<TaskNotification?>> {
  /// See also [taskNotification].
  const TaskNotificationFamily();

  /// See also [taskNotification].
  TaskNotificationProvider call({
    required String userId,
    required String taskId,
  }) {
    return TaskNotificationProvider(userId: userId, taskId: taskId);
  }

  @override
  TaskNotificationProvider getProviderOverride(
    covariant TaskNotificationProvider provider,
  ) {
    return call(userId: provider.userId, taskId: provider.taskId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskNotificationProvider';
}

/// See also [taskNotification].
class TaskNotificationProvider
    extends AutoDisposeStreamProvider<TaskNotification?> {
  /// See also [taskNotification].
  TaskNotificationProvider({required String userId, required String taskId})
    : this._internal(
        (ref) => taskNotification(
          ref as TaskNotificationRef,
          userId: userId,
          taskId: taskId,
        ),
        from: taskNotificationProvider,
        name: r'taskNotificationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$taskNotificationHash,
        dependencies: TaskNotificationFamily._dependencies,
        allTransitiveDependencies:
            TaskNotificationFamily._allTransitiveDependencies,
        userId: userId,
        taskId: taskId,
      );

  TaskNotificationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.taskId,
  }) : super.internal();

  final String userId;
  final String taskId;

  @override
  Override overrideWith(
    Stream<TaskNotification?> Function(TaskNotificationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskNotificationProvider._internal(
        (ref) => create(ref as TaskNotificationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TaskNotification?> createElement() {
    return _TaskNotificationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskNotificationProvider &&
        other.userId == userId &&
        other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskNotificationRef on AutoDisposeStreamProviderRef<TaskNotification?> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskNotificationProviderElement
    extends AutoDisposeStreamProviderElement<TaskNotification?>
    with TaskNotificationRef {
  _TaskNotificationProviderElement(super.provider);

  @override
  String get userId => (origin as TaskNotificationProvider).userId;
  @override
  String get taskId => (origin as TaskNotificationProvider).taskId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
