import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

/// Represents an account member with a role for permissions.
@JsonEnum(alwaysCreate: true)
enum MemberRole {
  owner,
  manager,
  editor,
  viewer,
}

extension MemberRoleX on MemberRole {
  bool get canEdit => this == MemberRole.owner || this == MemberRole.manager || this == MemberRole.editor;
  bool get canManage => this == MemberRole.owner || this == MemberRole.manager;
  String get label => switch (this) {
        MemberRole.owner => 'Owner',
        MemberRole.manager => 'Manager',
        MemberRole.editor => 'Editor',
        MemberRole.viewer => 'Viewer',
      };
}

@freezed
class AccountMember with _$AccountMember {
  const factory AccountMember({
    required String uid,
    @Default(MemberRole.viewer) MemberRole role,
  }) = _AccountMember;

  factory AccountMember.fromJson(Map<String, dynamic> json) => _$AccountMemberFromJson(json);
}

// Keep for backward compatibility during migration
@freezed
class ShelfMember with _$ShelfMember {
  const factory ShelfMember({
    required String uid,
    @Default(MemberRole.viewer) MemberRole role,
  }) = _ShelfMember;

  factory ShelfMember.fromJson(Map<String, dynamic> json) => _$ShelfMemberFromJson(json);
}
