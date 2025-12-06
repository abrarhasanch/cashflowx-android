// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanEventImpl _$$LoanEventImplFromJson(Map<String, dynamic> json) =>
    _$LoanEventImpl(
      id: json['id'] as String,
      loanId: json['loanId'] as String,
      accountId: json['accountId'] as String,
      type: $enumDecode(_$LoanEventTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      createdByUid: json['createdByUid'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$LoanEventImplToJson(_$LoanEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loanId': instance.loanId,
      'accountId': instance.accountId,
      'type': _$LoanEventTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'createdByUid': instance.createdByUid,
      'note': instance.note,
    };

const _$LoanEventTypeEnumMap = {
  LoanEventType.youLent: 'youLent',
  LoanEventType.youBorrowed: 'youBorrowed',
  LoanEventType.repayment: 'repayment',
  LoanEventType.settlement: 'settlement',
};
