// freezed, part 키워드를 사용하여 freezed와 json_serializable 라이브러리를 현재 파일에 연결합니다.
// 이를 통해 불변 데이터 클래스와 직렬화 코드를 자동으로 생성할 수 있습니다.
import 'package:flutter_todo_app/utils/time_stamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

// @freezed 어노테이션은 freezed 라이브러리가 이 클래스를 처리하도록 지시합니다.
// Task 클래스는 불변(immutable) 데이터 클래스로 정의되며, _$Task 믹인을 사용하여
// copyWith, equality, toString, hashCode 등의 메서드를 자동으로 구현합니다.
@freezed
abstract class Task with _$Task {
  // Task 클래스의 생성자입니다.
  // required 키워드를 사용하여 모든 필드가 필수적으로 초기화되어야 함을 명시합니다.
  const factory Task({
    @Default('') String id, // 작업의 고유 ID
    required String title, // 작업 제목
    required String description, // 작업 설명
    required String priority, // 우선순위 ('Low', 'Medium', 'High')
    @TimestampConverter() required DateTime date, // 작업 날짜
    @Default(false) bool isCompleted, // 완료 여부
  }) = _Task; // _Task는 freezed에 의해 생성될 구현 클래스입니다.

  // JSON 데이터를 Task 객체로 변환하는 factory 생성자입니다.
  // Firestore와 같은 외부 데이터 소스에서 데이터를 읽어올 때 사용됩니다.
  // _$TaskFromJson 함수는 json_serializable에 의해 자동으로 생성됩니다.
  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}