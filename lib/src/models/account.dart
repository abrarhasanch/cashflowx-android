import 'package:freezed_annotation/freezed_annotation.dart';

import 'member.dart';
import '../utils/timestamp_converter.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String title,
    String? description,
    required String currency,
    required String ownerUid,
    @TimestampConverterNonNull() required DateTime createdAt,
    @Default([]) List<AccountMember> members,
    @Default([]) List<String> memberUids,
    @Default(0.0) double totalIn,
    @Default(0.0) double totalOut,
  }) = _Account;

  factory Account.empty({required String ownerUid, String currency = 'USD'}) => Account(
        id: '',
        title: '',
        description: '',
        currency: currency,
        ownerUid: ownerUid,
        createdAt: DateTime.now(),
        members: [AccountMember(uid: ownerUid, role: MemberRole.owner)],
        memberUids: [ownerUid],
      );

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}
