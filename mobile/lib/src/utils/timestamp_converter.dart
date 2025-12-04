import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is String) return DateTime.tryParse(json);
    return null;
  }

  @override
  Object? toJson(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}

class TimestampConverterNonNull implements JsonConverter<DateTime, Object?> {
  const TimestampConverterNonNull();

  @override
  DateTime fromJson(Object? json) {
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is String) {
      final parsed = DateTime.tryParse(json);
      if (parsed != null) return parsed;
    }
    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  Object? toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}
