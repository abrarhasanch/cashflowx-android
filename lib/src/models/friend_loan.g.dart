// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendLoanImpl _$$FriendLoanImplFromJson(Map<String, dynamic> json) =>
    _$FriendLoanImpl(
      id: json['id'] as String,
      shelfId: json['shelfId'] as String,
      bookId: json['bookId'] as String,
      contactId: json['contactId'] as String,
      totalYouGave: (json['totalYouGave'] as num?)?.toDouble() ?? 0.0,
      totalYouTook: (json['totalYouTook'] as num?)?.toDouble() ?? 0.0,
      net: (json['net'] as num?)?.toDouble() ?? 0.0,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      createdByUid: json['createdByUid'] as String?,
    );

Map<String, dynamic> _$$FriendLoanImplToJson(_$FriendLoanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shelfId': instance.shelfId,
      'bookId': instance.bookId,
      'contactId': instance.contactId,
      'totalYouGave': instance.totalYouGave,
      'totalYouTook': instance.totalYouTook,
      'net': instance.net,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'createdByUid': instance.createdByUid,
    };
