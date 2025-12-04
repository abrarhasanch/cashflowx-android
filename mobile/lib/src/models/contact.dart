import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/timestamp_converter.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String shelfId,
    required String bookId,
    required String name,
    String? phone,
    String? email,
    String? notes,
    @TimestampConverter() DateTime? createdAt,
    String? createdByUid,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
}
