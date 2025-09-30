import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json is Timestamp) return json.toDate(); // ✅ Firestore Timestamp → DateTime
    if (json is String) return DateTime.parse(json); // 혹시 문자열로 저장된 경우 대비
    throw ArgumentError('Invalid date format: $json');
  }

  @override
  Object? toJson(DateTime date) => Timestamp.fromDate(date); // ✅ DateTime → Firestore Timestamp
}