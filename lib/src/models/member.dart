import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

/// Represents a shelf or book member with a role for permissions.
@JsonEnum(alwaysCreate: true)
enum MemberRole {
  owner,
  editor,
  viewer,
}

extension MemberRoleX on MemberRole {
  bool get canEdit => this == MemberRole.owner || this == MemberRole.editor;
  String get label => switch (this) {
        MemberRole.owner => 'Owner',
        MemberRole.editor => 'Editor',
        MemberRole.viewer => 'Viewer',
      };
}

@freezed
class ShelfMember with _$ShelfMember {
  const factory ShelfMember({
    required String uid,
    @Default(MemberRole.viewer) MemberRole role,
  }) = _ShelfMember;

  factory ShelfMember.fromJson(Map<String, dynamic> json) => _$ShelfMemberFromJson(json);
}
