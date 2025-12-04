// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_loan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FriendLoan _$FriendLoanFromJson(Map<String, dynamic> json) {
  return _FriendLoan.fromJson(json);
}

/// @nodoc
mixin _$FriendLoan {
  String get id => throw _privateConstructorUsedError;
  String get shelfId => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  String get contactId => throw _privateConstructorUsedError;
  double get totalYouGave => throw _privateConstructorUsedError;
  double get totalYouTook => throw _privateConstructorUsedError;
  double get net => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdByUid => throw _privateConstructorUsedError;

  /// Serializes this FriendLoan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendLoan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendLoanCopyWith<FriendLoan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendLoanCopyWith<$Res> {
  factory $FriendLoanCopyWith(
    FriendLoan value,
    $Res Function(FriendLoan) then,
  ) = _$FriendLoanCopyWithImpl<$Res, FriendLoan>;
  @useResult
  $Res call({
    String id,
    String shelfId,
    String bookId,
    String contactId,
    double totalYouGave,
    double totalYouTook,
    double net,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    String? createdByUid,
  });
}

/// @nodoc
class _$FriendLoanCopyWithImpl<$Res, $Val extends FriendLoan>
    implements $FriendLoanCopyWith<$Res> {
  _$FriendLoanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendLoan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shelfId = null,
    Object? bookId = null,
    Object? contactId = null,
    Object? totalYouGave = null,
    Object? totalYouTook = null,
    Object? net = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdByUid = freezed,
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
            bookId: null == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as String,
            contactId: null == contactId
                ? _value.contactId
                : contactId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalYouGave: null == totalYouGave
                ? _value.totalYouGave
                : totalYouGave // ignore: cast_nullable_to_non_nullable
                      as double,
            totalYouTook: null == totalYouTook
                ? _value.totalYouTook
                : totalYouTook // ignore: cast_nullable_to_non_nullable
                      as double,
            net: null == net
                ? _value.net
                : net // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdByUid: freezed == createdByUid
                ? _value.createdByUid
                : createdByUid // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendLoanImplCopyWith<$Res>
    implements $FriendLoanCopyWith<$Res> {
  factory _$$FriendLoanImplCopyWith(
    _$FriendLoanImpl value,
    $Res Function(_$FriendLoanImpl) then,
  ) = __$$FriendLoanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String shelfId,
    String bookId,
    String contactId,
    double totalYouGave,
    double totalYouTook,
    double net,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    String? createdByUid,
  });
}

/// @nodoc
class __$$FriendLoanImplCopyWithImpl<$Res>
    extends _$FriendLoanCopyWithImpl<$Res, _$FriendLoanImpl>
    implements _$$FriendLoanImplCopyWith<$Res> {
  __$$FriendLoanImplCopyWithImpl(
    _$FriendLoanImpl _value,
    $Res Function(_$FriendLoanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendLoan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shelfId = null,
    Object? bookId = null,
    Object? contactId = null,
    Object? totalYouGave = null,
    Object? totalYouTook = null,
    Object? net = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdByUid = freezed,
  }) {
    return _then(
      _$FriendLoanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        shelfId: null == shelfId
            ? _value.shelfId
            : shelfId // ignore: cast_nullable_to_non_nullable
                  as String,
        bookId: null == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as String,
        contactId: null == contactId
            ? _value.contactId
            : contactId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalYouGave: null == totalYouGave
            ? _value.totalYouGave
            : totalYouGave // ignore: cast_nullable_to_non_nullable
                  as double,
        totalYouTook: null == totalYouTook
            ? _value.totalYouTook
            : totalYouTook // ignore: cast_nullable_to_non_nullable
                  as double,
        net: null == net
            ? _value.net
            : net // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdByUid: freezed == createdByUid
            ? _value.createdByUid
            : createdByUid // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendLoanImpl implements _FriendLoan {
  const _$FriendLoanImpl({
    required this.id,
    required this.shelfId,
    required this.bookId,
    required this.contactId,
    this.totalYouGave = 0.0,
    this.totalYouTook = 0.0,
    this.net = 0.0,
    @TimestampConverter() this.createdAt,
    @TimestampConverter() this.updatedAt,
    this.createdByUid,
  });

  factory _$FriendLoanImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendLoanImplFromJson(json);

  @override
  final String id;
  @override
  final String shelfId;
  @override
  final String bookId;
  @override
  final String contactId;
  @override
  @JsonKey()
  final double totalYouGave;
  @override
  @JsonKey()
  final double totalYouTook;
  @override
  @JsonKey()
  final double net;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;
  @override
  final String? createdByUid;

  @override
  String toString() {
    return 'FriendLoan(id: $id, shelfId: $shelfId, bookId: $bookId, contactId: $contactId, totalYouGave: $totalYouGave, totalYouTook: $totalYouTook, net: $net, createdAt: $createdAt, updatedAt: $updatedAt, createdByUid: $createdByUid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendLoanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shelfId, shelfId) || other.shelfId == shelfId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.totalYouGave, totalYouGave) ||
                other.totalYouGave == totalYouGave) &&
            (identical(other.totalYouTook, totalYouTook) ||
                other.totalYouTook == totalYouTook) &&
            (identical(other.net, net) || other.net == net) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdByUid, createdByUid) ||
                other.createdByUid == createdByUid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    shelfId,
    bookId,
    contactId,
    totalYouGave,
    totalYouTook,
    net,
    createdAt,
    updatedAt,
    createdByUid,
  );

  /// Create a copy of FriendLoan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendLoanImplCopyWith<_$FriendLoanImpl> get copyWith =>
      __$$FriendLoanImplCopyWithImpl<_$FriendLoanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendLoanImplToJson(this);
  }
}

abstract class _FriendLoan implements FriendLoan {
  const factory _FriendLoan({
    required final String id,
    required final String shelfId,
    required final String bookId,
    required final String contactId,
    final double totalYouGave,
    final double totalYouTook,
    final double net,
    @TimestampConverter() final DateTime? createdAt,
    @TimestampConverter() final DateTime? updatedAt,
    final String? createdByUid,
  }) = _$FriendLoanImpl;

  factory _FriendLoan.fromJson(Map<String, dynamic> json) =
      _$FriendLoanImpl.fromJson;

  @override
  String get id;
  @override
  String get shelfId;
  @override
  String get bookId;
  @override
  String get contactId;
  @override
  double get totalYouGave;
  @override
  double get totalYouTook;
  @override
  double get net;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;
  @override
  String? get createdByUid;

  /// Create a copy of FriendLoan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendLoanImplCopyWith<_$FriendLoanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
