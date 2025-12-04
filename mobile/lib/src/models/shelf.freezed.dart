// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelf.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Shelf _$ShelfFromJson(Map<String, dynamic> json) {
  return _Shelf.fromJson(json);
}

/// @nodoc
mixin _$Shelf {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get ownerUid => throw _privateConstructorUsedError;
  @TimestampConverterNonNull()
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<ShelfMember> get members => throw _privateConstructorUsedError;
  List<String> get memberUids => throw _privateConstructorUsedError;

  /// Serializes this Shelf to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shelf
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShelfCopyWith<Shelf> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShelfCopyWith<$Res> {
  factory $ShelfCopyWith(Shelf value, $Res Function(Shelf) then) =
      _$ShelfCopyWithImpl<$Res, Shelf>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    String currency,
    String ownerUid,
    @TimestampConverterNonNull() DateTime createdAt,
    List<ShelfMember> members,
    List<String> memberUids,
  });
}

/// @nodoc
class _$ShelfCopyWithImpl<$Res, $Val extends Shelf>
    implements $ShelfCopyWith<$Res> {
  _$ShelfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shelf
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? currency = null,
    Object? ownerUid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? memberUids = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerUid: null == ownerUid
                ? _value.ownerUid
                : ownerUid // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<ShelfMember>,
            memberUids: null == memberUids
                ? _value.memberUids
                : memberUids // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShelfImplCopyWith<$Res> implements $ShelfCopyWith<$Res> {
  factory _$$ShelfImplCopyWith(
    _$ShelfImpl value,
    $Res Function(_$ShelfImpl) then,
  ) = __$$ShelfImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    String currency,
    String ownerUid,
    @TimestampConverterNonNull() DateTime createdAt,
    List<ShelfMember> members,
    List<String> memberUids,
  });
}

/// @nodoc
class __$$ShelfImplCopyWithImpl<$Res>
    extends _$ShelfCopyWithImpl<$Res, _$ShelfImpl>
    implements _$$ShelfImplCopyWith<$Res> {
  __$$ShelfImplCopyWithImpl(
    _$ShelfImpl _value,
    $Res Function(_$ShelfImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Shelf
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? currency = null,
    Object? ownerUid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? memberUids = null,
  }) {
    return _then(
      _$ShelfImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerUid: null == ownerUid
            ? _value.ownerUid
            : ownerUid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ShelfMember>,
        memberUids: null == memberUids
            ? _value._memberUids
            : memberUids // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShelfImpl implements _Shelf {
  const _$ShelfImpl({
    required this.id,
    required this.title,
    this.description,
    required this.currency,
    required this.ownerUid,
    @TimestampConverterNonNull() required this.createdAt,
    final List<ShelfMember> members = const [],
    final List<String> memberUids = const [],
  }) : _members = members,
       _memberUids = memberUids;

  factory _$ShelfImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShelfImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String currency;
  @override
  final String ownerUid;
  @override
  @TimestampConverterNonNull()
  final DateTime createdAt;
  final List<ShelfMember> _members;
  @override
  @JsonKey()
  List<ShelfMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<String> _memberUids;
  @override
  @JsonKey()
  List<String> get memberUids {
    if (_memberUids is EqualUnmodifiableListView) return _memberUids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberUids);
  }

  @override
  String toString() {
    return 'Shelf(id: $id, title: $title, description: $description, currency: $currency, ownerUid: $ownerUid, createdAt: $createdAt, members: $members, memberUids: $memberUids)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShelfImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(
              other._memberUids,
              _memberUids,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    currency,
    ownerUid,
    createdAt,
    const DeepCollectionEquality().hash(_members),
    const DeepCollectionEquality().hash(_memberUids),
  );

  /// Create a copy of Shelf
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShelfImplCopyWith<_$ShelfImpl> get copyWith =>
      __$$ShelfImplCopyWithImpl<_$ShelfImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShelfImplToJson(this);
  }
}

abstract class _Shelf implements Shelf {
  const factory _Shelf({
    required final String id,
    required final String title,
    final String? description,
    required final String currency,
    required final String ownerUid,
    @TimestampConverterNonNull() required final DateTime createdAt,
    final List<ShelfMember> members,
    final List<String> memberUids,
  }) = _$ShelfImpl;

  factory _Shelf.fromJson(Map<String, dynamic> json) = _$ShelfImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get currency;
  @override
  String get ownerUid;
  @override
  @TimestampConverterNonNull()
  DateTime get createdAt;
  @override
  List<ShelfMember> get members;
  @override
  List<String> get memberUids;

  /// Create a copy of Shelf
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShelfImplCopyWith<_$ShelfImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
