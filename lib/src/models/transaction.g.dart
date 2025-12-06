// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountTransactionImpl _$$AccountTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$AccountTransactionImpl(
  id: json['id'] as String,
  accountId: json['accountId'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  createdAt: const TimestampConverterNonNull().fromJson(json['createdAt']),
  createdByUid: json['createdByUid'] as String,
  remark: json['remark'] as String?,
  category: json['category'] as String?,
  paymentMode: json['paymentMode'] as String?,
  contactId: json['contactId'] as String?,
  dueDate: const TimestampConverter().fromJson(json['dueDate']),
  isPaid: json['isPaid'] as bool? ?? false,
  paidAt: const TimestampConverter().fromJson(json['paidAt']),
);

Map<String, dynamic> _$$AccountTransactionImplToJson(
  _$AccountTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'accountId': instance.accountId,
  'amount': instance.amount,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
  'createdByUid': instance.createdByUid,
  'remark': instance.remark,
  'category': instance.category,
  'paymentMode': instance.paymentMode,
  'contactId': instance.contactId,
  'dueDate': const TimestampConverter().toJson(instance.dueDate),
  'isPaid': instance.isPaid,
  'paidAt': const TimestampConverter().toJson(instance.paidAt),
};

const _$TransactionTypeEnumMap = {
  TransactionType.cashIn: 'cashIn',
  TransactionType.cashOut: 'cashOut',
};
