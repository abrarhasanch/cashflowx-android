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
class BookTransaction with _$BookTransaction {
  const factory BookTransaction({
    required String id,
    required String shelfId,
    required String bookId,
    required double amount,
    required TransactionType type,
    @TimestampConverterNonNull() required DateTime createdAt,
    required String createdByUid,
    String? remark,
    String? category,
    String? paymentMode,
    String? contactId,
  }) = _BookTransaction;

  factory BookTransaction.fromJson(Map<String, dynamic> json) => _$BookTransactionFromJson(json);
}
