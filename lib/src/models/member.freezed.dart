// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AccountMember _$AccountMemberFromJson(Map<String, dynamic> json) {
  return _AccountMember.fromJson(json);
}

/// @nodoc
mixin _$AccountMember {
  String get uid => throw _privateConstructorUsedError;
  MemberRole get role => throw _privateConstructorUsedError;

  /// Serializes this AccountMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountMemberCopyWith<AccountMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountMemberCopyWith<$Res> {
  factory $AccountMemberCopyWith(
    AccountMember value,
    $Res Function(AccountMember) then,
  ) = _$AccountMemberCopyWithImpl<$Res, AccountMember>;
  @useResult
  $Res call({String uid, MemberRole role});
}

/// @nodoc
class _$AccountMemberCopyWithImpl<$Res, $Val extends AccountMember>
    implements $AccountMemberCopyWith<$Res> {
  _$AccountMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? uid = null, Object? role = null}) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as MemberRole,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountMemberImplCopyWith<$Res>
    implements $AccountMemberCopyWith<$Res> {
  factory _$$AccountMemberImplCopyWith(
    _$AccountMemberImpl value,
    $Res Function(_$AccountMemberImpl) then,
  ) = __$$AccountMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, MemberRole role});
}

/// @nodoc
class __$$AccountMemberImplCopyWithImpl<$Res>
    extends _$AccountMemberCopyWithImpl<$Res, _$AccountMemberImpl>
    implements _$$AccountMemberImplCopyWith<$Res> {
  __$$AccountMemberImplCopyWithImpl(
    _$AccountMemberImpl _value,
    $Res Function(_$AccountMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? uid = null, Object? role = null}) {
    return _then(
      _$AccountMemberImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as MemberRole,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountMemberImpl implements _AccountMember {
  const _$AccountMemberImpl({required this.uid, this.role = MemberRole.viewer});

  factory _$AccountMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountMemberImplFromJson(json);

  @override
  final String uid;
  @override
  @JsonKey()
  final MemberRole role;

  @override
  String toString() {
    return 'AccountMember(uid: $uid, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountMemberImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, role);

  /// Create a copy of AccountMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountMemberImplCopyWith<_$AccountMemberImpl> get copyWith =>
      __$$AccountMemberImplCopyWithImpl<_$AccountMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountMemberImplToJson(this);
  }
}

abstract class _AccountMember implements AccountMember {
  const factory _AccountMember({
    required final String uid,
    final MemberRole role,
  }) = _$AccountMemberImpl;

  factory _AccountMember.fromJson(Map<String, dynamic> json) =
      _$AccountMemberImpl.fromJson;

  @override
  String get uid;
  @override
  MemberRole get role;

  /// Create a copy of AccountMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountMemberImplCopyWith<_$AccountMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShelfMember _$ShelfMemberFromJson(Map<String, dynamic> json) {
  return _ShelfMember.fromJson(json);
}

/// @nodoc
mixin _$ShelfMember {
  String get uid => throw _privateConstructorUsedError;
  MemberRole get role => throw _privateConstructorUsedError;

  /// Serializes this ShelfMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShelfMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShelfMemberCopyWith<ShelfMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShelfMemberCopyWith<$Res> {
  factory $ShelfMemberCopyWith(
    ShelfMember value,
    $Res Function(ShelfMember) then,
  ) = _$ShelfMemberCopyWithImpl<$Res, ShelfMember>;
  @useResult
  $Res call({String uid, MemberRole role});
}

/// @nodoc
class _$ShelfMemberCopyWithImpl<$Res, $Val extends ShelfMember>
    implements $ShelfMemberCopyWith<$Res> {
  _$ShelfMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShelfMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? uid = null, Object? role = null}) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as MemberRole,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShelfMemberImplCopyWith<$Res>
    implements $ShelfMemberCopyWith<$Res> {
  factory _$$ShelfMemberImplCopyWith(
    _$ShelfMemberImpl value,
    $Res Function(_$ShelfMemberImpl) then,
  ) = __$$ShelfMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, MemberRole role});
}

/// @nodoc
class __$$ShelfMemberImplCopyWithImpl<$Res>
    extends _$ShelfMemberCopyWithImpl<$Res, _$ShelfMemberImpl>
    implements _$$ShelfMemberImplCopyWith<$Res> {
  __$$ShelfMemberImplCopyWithImpl(
    _$ShelfMemberImpl _value,
    $Res Function(_$ShelfMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShelfMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? uid = null, Object? role = null}) {
    return _then(
      _$ShelfMemberImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as MemberRole,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShelfMemberImpl implements _ShelfMember {
  const _$ShelfMemberImpl({required this.uid, this.role = MemberRole.viewer});

  factory _$ShelfMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShelfMemberImplFromJson(json);

  @override
  final String uid;
  @override
  @JsonKey()
  final MemberRole role;

  @override
  String toString() {
    return 'ShelfMember(uid: $uid, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShelfMemberImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, role);

  /// Create a copy of ShelfMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShelfMemberImplCopyWith<_$ShelfMemberImpl> get copyWith =>
      __$$ShelfMemberImplCopyWithImpl<_$ShelfMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShelfMemberImplToJson(this);
  }
}

abstract class _ShelfMember implements ShelfMember {
  const factory _ShelfMember({
    required final String uid,
    final MemberRole role,
  }) = _$ShelfMemberImpl;

  factory _ShelfMember.fromJson(Map<String, dynamic> json) =
      _$ShelfMemberImpl.fromJson;

  @override
  String get uid;
  @override
  MemberRole get role;

  /// Create a copy of ShelfMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShelfMemberImplCopyWith<_$ShelfMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
