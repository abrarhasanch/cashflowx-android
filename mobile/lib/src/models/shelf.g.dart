// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShelfImpl _$$ShelfImplFromJson(Map<String, dynamic> json) => _$ShelfImpl(
  id: json['id'] as String,
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
);

Map<String, dynamic> _$$ShelfImplToJson(_$ShelfImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'currency': instance.currency,
      'ownerUid': instance.ownerUid,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
      'members': instance.members,
      'memberUids': instance.memberUids,
    };
