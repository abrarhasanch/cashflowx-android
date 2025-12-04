import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/timestamp_converter.dart';

part 'loan_event.freezed.dart';
part 'loan_event.g.dart';

@JsonEnum(alwaysCreate: true)
enum LoanEventType {
  youLent,
  youBorrowed,
  repayment,
  settlement,
}

@freezed
class LoanEvent with _$LoanEvent {
  const factory LoanEvent({
    required String id,
    required String loanId,
    required String shelfId,
    required String bookId,
    required LoanEventType type,
    required double amount,
    @TimestampConverter() DateTime? createdAt,
    String? createdByUid,
    String? note,
  }) = _LoanEvent;

  factory LoanEvent.fromJson(Map<String, dynamic> json) => _$LoanEventFromJson(json);
}
