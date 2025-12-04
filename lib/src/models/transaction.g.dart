// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookTransactionImpl _$$BookTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$BookTransactionImpl(
  id: json['id'] as String,
  shelfId: json['shelfId'] as String,
  bookId: json['bookId'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  createdAt: const TimestampConverterNonNull().fromJson(json['createdAt']),
  createdByUid: json['createdByUid'] as String,
  remark: json['remark'] as String?,
  category: json['category'] as String?,
  paymentMode: json['paymentMode'] as String?,
  contactId: json['contactId'] as String?,
);

Map<String, dynamic> _$$BookTransactionImplToJson(
  _$BookTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'shelfId': instance.shelfId,
  'bookId': instance.bookId,
  'amount': instance.amount,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
  'createdByUid': instance.createdByUid,
  'remark': instance.remark,
  'category': instance.category,
  'paymentMode': instance.paymentMode,
  'contactId': instance.contactId,
};

const _$TransactionTypeEnumMap = {
  TransactionType.cashIn: 'cashIn',
  TransactionType.cashOut: 'cashOut',
};
