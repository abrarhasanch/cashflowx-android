import 'package:freezed_annotation/freezed_annotation.dart';

import 'member.dart';
import '../utils/timestamp_converter.dart';

part 'shelf.freezed.dart';
part 'shelf.g.dart';

@freezed
class Shelf with _$Shelf {
  const factory Shelf({
    required String id,
    required String title,
    String? description,
    required String currency,
    required String ownerUid,
    @TimestampConverterNonNull() required DateTime createdAt,
    @Default([]) List<ShelfMember> members,
    @Default([]) List<String> memberUids,
  }) = _Shelf;

  factory Shelf.empty({required String ownerUid, String currency = 'USD'}) => Shelf(
        id: '',
        title: '',
        description: '',
        currency: currency,
        ownerUid: ownerUid,
        createdAt: DateTime.now(),
        members: [ShelfMember(uid: ownerUid, role: MemberRole.owner)],
        memberUids: [ownerUid],
      );

  factory Shelf.fromJson(Map<String, dynamic> json) => _$ShelfFromJson(json);
}
