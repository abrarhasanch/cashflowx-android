import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/timestamp_converter.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@JsonEnum(alwaysCreate: true)
enum TransactionType {
  cashIn,
  cashOut,
}

@freezed
class AccountTransaction with _$AccountTransaction {
  const factory AccountTransaction({
    required String id,
    required String accountId,
    required double amount,
    required TransactionType type,
    @TimestampConverterNonNull() required DateTime createdAt,
    required String createdByUid,
    String? remark,
    String? category,
    String? paymentMode,
    String? contactId,
    @TimestampConverter() DateTime? dueDate,
    @Default(false) bool isPaid,
    @TimestampConverter() DateTime? paidAt,
  }) = _AccountTransaction;

  factory AccountTransaction.fromJson(Map<String, dynamic> json) => _$AccountTransactionFromJson(json);
}

// Aliases for consistency with flow diagram
typedef CashEntry = AccountTransaction;
typedef BookTransaction = AccountTransaction; // Backward compatibility
