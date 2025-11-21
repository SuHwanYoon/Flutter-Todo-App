// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskNotification {

 String get id; String get taskId;// Associated task ID
@TimestampConverter() DateTime get notificationTime; bool get isActive;// Notification is active or disabled
 bool get isTriggered;
/// Create a copy of TaskNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskNotificationCopyWith<TaskNotification> get copyWith => _$TaskNotificationCopyWithImpl<TaskNotification>(this as TaskNotification, _$identity);

  /// Serializes this TaskNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.notificationTime, notificationTime) || other.notificationTime == notificationTime)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isTriggered, isTriggered) || other.isTriggered == isTriggered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,notificationTime,isActive,isTriggered);

@override
String toString() {
  return 'TaskNotification(id: $id, taskId: $taskId, notificationTime: $notificationTime, isActive: $isActive, isTriggered: $isTriggered)';
}


}

/// @nodoc
abstract mixin class $TaskNotificationCopyWith<$Res>  {
  factory $TaskNotificationCopyWith(TaskNotification value, $Res Function(TaskNotification) _then) = _$TaskNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String taskId,@TimestampConverter() DateTime notificationTime, bool isActive, bool isTriggered
});




}
/// @nodoc
class _$TaskNotificationCopyWithImpl<$Res>
    implements $TaskNotificationCopyWith<$Res> {
  _$TaskNotificationCopyWithImpl(this._self, this._then);

  final TaskNotification _self;
  final $Res Function(TaskNotification) _then;

/// Create a copy of TaskNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? notificationTime = null,Object? isActive = null,Object? isTriggered = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,notificationTime: null == notificationTime ? _self.notificationTime : notificationTime // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isTriggered: null == isTriggered ? _self.isTriggered : isTriggered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskNotification].
extension TaskNotificationPatterns on TaskNotification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskNotification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskNotification value)  $default,){
final _that = this;
switch (_that) {
case _TaskNotification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskNotification value)?  $default,){
final _that = this;
switch (_that) {
case _TaskNotification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId, @TimestampConverter()  DateTime notificationTime,  bool isActive,  bool isTriggered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskNotification() when $default != null:
return $default(_that.id,_that.taskId,_that.notificationTime,_that.isActive,_that.isTriggered);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId, @TimestampConverter()  DateTime notificationTime,  bool isActive,  bool isTriggered)  $default,) {final _that = this;
switch (_that) {
case _TaskNotification():
return $default(_that.id,_that.taskId,_that.notificationTime,_that.isActive,_that.isTriggered);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId, @TimestampConverter()  DateTime notificationTime,  bool isActive,  bool isTriggered)?  $default,) {final _that = this;
switch (_that) {
case _TaskNotification() when $default != null:
return $default(_that.id,_that.taskId,_that.notificationTime,_that.isActive,_that.isTriggered);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskNotification implements TaskNotification {
  const _TaskNotification({this.id = '', required this.taskId, @TimestampConverter() required this.notificationTime, this.isActive = true, this.isTriggered = false});
  factory _TaskNotification.fromJson(Map<String, dynamic> json) => _$TaskNotificationFromJson(json);

@override@JsonKey() final  String id;
@override final  String taskId;
// Associated task ID
@override@TimestampConverter() final  DateTime notificationTime;
@override@JsonKey() final  bool isActive;
// Notification is active or disabled
@override@JsonKey() final  bool isTriggered;

/// Create a copy of TaskNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskNotificationCopyWith<_TaskNotification> get copyWith => __$TaskNotificationCopyWithImpl<_TaskNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.notificationTime, notificationTime) || other.notificationTime == notificationTime)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isTriggered, isTriggered) || other.isTriggered == isTriggered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,notificationTime,isActive,isTriggered);

@override
String toString() {
  return 'TaskNotification(id: $id, taskId: $taskId, notificationTime: $notificationTime, isActive: $isActive, isTriggered: $isTriggered)';
}


}

/// @nodoc
abstract mixin class _$TaskNotificationCopyWith<$Res> implements $TaskNotificationCopyWith<$Res> {
  factory _$TaskNotificationCopyWith(_TaskNotification value, $Res Function(_TaskNotification) _then) = __$TaskNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId,@TimestampConverter() DateTime notificationTime, bool isActive, bool isTriggered
});




}
/// @nodoc
class __$TaskNotificationCopyWithImpl<$Res>
    implements _$TaskNotificationCopyWith<$Res> {
  __$TaskNotificationCopyWithImpl(this._self, this._then);

  final _TaskNotification _self;
  final $Res Function(_TaskNotification) _then;

/// Create a copy of TaskNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? notificationTime = null,Object? isActive = null,Object? isTriggered = null,}) {
  return _then(_TaskNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,notificationTime: null == notificationTime ? _self.notificationTime : notificationTime // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isTriggered: null == isTriggered ? _self.isTriggered : isTriggered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
