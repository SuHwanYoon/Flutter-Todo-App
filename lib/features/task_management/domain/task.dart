
// freezed문법을 사용해 dart data class를 작성
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    required String priority, // 'Low', 'Medium', 'High'
    required DateTime date,
    required bool isCompleted,
  }) = _Task;

  // Firestore에서 데이터를 읽어올 때 사용
  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
  
}
