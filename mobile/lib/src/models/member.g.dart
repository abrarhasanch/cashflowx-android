// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShelfMemberImpl _$$ShelfMemberImplFromJson(Map<String, dynamic> json) =>
    _$ShelfMemberImpl(
      uid: json['uid'] as String,
      role:
          $enumDecodeNullable(_$MemberRoleEnumMap, json['role']) ??
          MemberRole.viewer,
    );

Map<String, dynamic> _$$ShelfMemberImplToJson(_$ShelfMemberImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'role': _$MemberRoleEnumMap[instance.role]!,
    };

const _$MemberRoleEnumMap = {
  MemberRole.owner: 'owner',
  MemberRole.editor: 'editor',
  MemberRole.viewer: 'viewer',
};
