// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookImpl _$$BookImplFromJson(Map<String, dynamic> json) => _$BookImpl(
  id: json['id'] as String,
  shelfId: json['shelfId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  currency: json['currency'] as String,
  ownerUid: json['ownerUid'] as String,
  createdAt: const TimestampConverterNonNull().fromJson(json['createdAt']),
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => ShelfMember.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  memberUids:
      (json['memberUids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  totalIn: (json['totalIn'] as num?)?.toDouble() ?? 0.0,
  totalOut: (json['totalOut'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$BookImplToJson(_$BookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shelfId': instance.shelfId,
      'title': instance.title,
      'description': instance.description,
      'currency': instance.currency,
      'ownerUid': instance.ownerUid,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
      'members': instance.members,
      'memberUids': instance.memberUids,
      'totalIn': instance.totalIn,
      'totalOut': instance.totalOut,
    };
