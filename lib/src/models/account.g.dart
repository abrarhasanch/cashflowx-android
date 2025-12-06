// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      currency: json['currency'] as String,
      ownerUid: json['ownerUid'] as String,
      createdAt: const TimestampConverterNonNull().fromJson(json['createdAt']),
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => AccountMember.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
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
