// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Book _$BookFromJson(Map<String, dynamic> json) {
  return _Book.fromJson(json);
}

/// @nodoc
mixin _$Book {
  String get id => throw _privateConstructorUsedError;
  String get shelfId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get ownerUid => throw _privateConstructorUsedError;
  @TimestampConverterNonNull()
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<ShelfMember> get members => throw _privateConstructorUsedError;
  List<String> get memberUids => throw _privateConstructorUsedError;
  double get totalIn => throw _privateConstructorUsedError;
  double get totalOut => throw _privateConstructorUsedError;

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookCopyWith<Book> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookCopyWith<$Res> {
  factory $BookCopyWith(Book value, $Res Function(Book) then) =
      _$BookCopyWithImpl<$Res, Book>;
  @useResult
  $Res call({
    String id,
    String shelfId,
    String title,
    String? description,
    String currency,
    String ownerUid,
    @TimestampConverterNonNull() DateTime createdAt,
    List<ShelfMember> members,
    List<String> memberUids,
    double totalIn,
    double totalOut,
  });
}

/// @nodoc
class _$BookCopyWithImpl<$Res, $Val extends Book>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shelfId = null,
    Object? title = null,
    Object? description = freezed,
    Object? currency = null,
    Object? ownerUid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? memberUids = null,
    Object? totalIn = null,
    Object? totalOut = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            shelfId: null == shelfId
                ? _value.shelfId
                : shelfId // ignore: cast_nullable_to_non_nullable
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
            totalIn: null == totalIn
                ? _value.totalIn
                : totalIn // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOut: null == totalOut
                ? _value.totalOut
                : totalOut // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookImplCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$$BookImplCopyWith(
    _$BookImpl value,
    $Res Function(_$BookImpl) then,
  ) = __$$BookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String shelfId,
    String title,
    String? description,
    String currency,
    String ownerUid,
    @TimestampConverterNonNull() DateTime createdAt,
    List<ShelfMember> members,
    List<String> memberUids,
    double totalIn,
    double totalOut,
  });
}

/// @nodoc
class __$$BookImplCopyWithImpl<$Res>
    extends _$BookCopyWithImpl<$Res, _$BookImpl>
    implements _$$BookImplCopyWith<$Res> {
  __$$BookImplCopyWithImpl(_$BookImpl _value, $Res Function(_$BookImpl) _then)
    : super(_value, _then);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shelfId = null,
    Object? title = null,
    Object? description = freezed,
    Object? currency = null,
    Object? ownerUid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? memberUids = null,
    Object? totalIn = null,
    Object? totalOut = null,
  }) {
    return _then(
      _$BookImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        shelfId: null == shelfId
            ? _value.shelfId
            : shelfId // ignore: cast_nullable_to_non_nullable
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
        totalIn: null == totalIn
            ? _value.totalIn
            : totalIn // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOut: null == totalOut
            ? _value.totalOut
            : totalOut // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookImpl implements _Book {
  const _$BookImpl({
    required this.id,
    required this.shelfId,
    required this.title,
    this.description,
    required this.currency,
    required this.ownerUid,
    @TimestampConverterNonNull() required this.createdAt,
    final List<ShelfMember> members = const [],
    final List<String> memberUids = const [],
    this.totalIn = 0.0,
    this.totalOut = 0.0,
  }) : _members = members,
       _memberUids = memberUids;

  factory _$BookImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookImplFromJson(json);

  @override
  final String id;
  @override
  final String shelfId;
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
  @JsonKey()
  final double totalIn;
  @override
  @JsonKey()
  final double totalOut;

  @override
  String toString() {
    return 'Book(id: $id, shelfId: $shelfId, title: $title, description: $description, currency: $currency, ownerUid: $ownerUid, createdAt: $createdAt, members: $members, memberUids: $memberUids, totalIn: $totalIn, totalOut: $totalOut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shelfId, shelfId) || other.shelfId == shelfId) &&
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
            ) &&
            (identical(other.totalIn, totalIn) || other.totalIn == totalIn) &&
            (identical(other.totalOut, totalOut) ||
                other.totalOut == totalOut));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    shelfId,
    title,
    description,
    currency,
    ownerUid,
    createdAt,
    const DeepCollectionEquality().hash(_members),
    const DeepCollectionEquality().hash(_memberUids),
    totalIn,
    totalOut,
  );

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      __$$BookImplCopyWithImpl<_$BookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookImplToJson(this);
  }
}

abstract class _Book implements Book {
  const factory _Book({
    required final String id,
    required final String shelfId,
    required final String title,
    final String? description,
    required final String currency,
    required final String ownerUid,
    @TimestampConverterNonNull() required final DateTime createdAt,
    final List<ShelfMember> members,
    final List<String> memberUids,
    final double totalIn,
    final double totalOut,
  }) = _$BookImpl;

  factory _Book.fromJson(Map<String, dynamic> json) = _$BookImpl.fromJson;

  @override
  String get id;
  @override
  String get shelfId;
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
  @override
  double get totalIn;
  @override
  double get totalOut;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
