import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/timestamp_converter.dart';

part 'friend_loan.freezed.dart';
part 'friend_loan.g.dart';

@freezed
class FriendLoan with _$FriendLoan {
  const factory FriendLoan({
    required String id,
    required String accountId,
    required String contactId,
    @Default(0.0) double totalYouGave,
    @Default(0.0) double totalYouTook,
    @Default(0.0) double net,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    String? createdByUid,
  }) = _FriendLoan;

  factory FriendLoan.fromJson(Map<String, dynamic> json) => _$FriendLoanFromJson(json);
}
