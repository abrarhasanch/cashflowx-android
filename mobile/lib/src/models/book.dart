import 'package:freezed_annotation/freezed_annotation.dart';

import 'member.dart';
import '../utils/timestamp_converter.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required String id,
    required String shelfId,
    required String title,
    String? description,
    required String currency,
    required String ownerUid,
    @TimestampConverterNonNull() required DateTime createdAt,
    @Default([]) List<ShelfMember> members,
    @Default([]) List<String> memberUids,
    @Default(0.0) double totalIn,
    @Default(0.0) double totalOut,
  }) = _Book;

  factory Book.empty({required String shelfId, required String ownerUid, String currency = 'USD'}) => Book(
        id: '',
        shelfId: shelfId,
        title: '',
        description: '',
        currency: currency,
        ownerUid: ownerUid,
        createdAt: DateTime.now(),
        members: [ShelfMember(uid: ownerUid, role: MemberRole.owner)],
        memberUids: [ownerUid],
      );

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
