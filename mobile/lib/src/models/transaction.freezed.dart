// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookTransaction _$BookTransactionFromJson(Map<String, dynamic> json) {
  return _BookTransaction.fromJson(json);
}

/// @nodoc
mixin _$BookTransaction {
  String get id => throw _privateConstructorUsedError;
  String get shelfId => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  @TimestampConverterNonNull()
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get createdByUid => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get paymentMode => throw _privateConstructorUsedError;
  String? get contactId => throw _privateConstructorUsedError;

  /// Serializes this BookTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookTransactionCopyWith<BookTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookTransactionCopyWith<$Res> {
  factory $BookTransactionCopyWith(
    BookTransaction value,
    $Res Function(BookTransaction) then,
  ) = _$BookTransactionCopyWithImpl<$Res, BookTransaction>;
  @useResult
  $Res call({
    String id,
    String shelfId,
    String bookId,
    double amount,
    TransactionType type,
    @TimestampConverterNonNull() DateTime createdAt,
    String createdByUid,
    String? remark,
    String? category,
    String? paymentMode,
    String? contactId,
  });
}

/// @nodoc
class _$BookTransactionCopyWithImpl<$Res, $Val extends BookTransaction>
    implements $BookTransactionCopyWith<$Res> {
  _$BookTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shelfId = null,
    Object? bookId = null,
    Object? amount = null,
    Object? type = null,
    Object? createdAt = null,
    Object? createdByUid = null,
    Object? remark = freezed,
    Object? category = freezed,
    Object? paymentMode = freezed,
    Object? contactId = freezed,
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
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdByUid: null == createdByUid
                ? _value.createdByUid
                : createdByUid // ignore: cast_nullable_to_non_nullable
                      as String,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentMode: freezed == paymentMode
                ? _value.paymentMode
                : paymentMode // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactId: freezed == contactId
                ? _value.contactId
                : contactId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookTransactionImplCopyWith<$Res>
    implements $BookTransactionCopyWith<$Res> {
  factory _$$BookTransactionImplCopyWith(
    _$BookTransactionImpl value,
    $Res Function(_$BookTransactionImpl) then,
  ) = __$$BookTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String shelfId,
    String bookId,
    double amount,
    TransactionType type,
    @TimestampConverterNonNull() DateTime createdAt,
    String createdByUid,
    String? remark,
    String? category,
    String? paymentMode,
    String? contactId,
  });
}

/// @nodoc
class __$$BookTransactionImplCopyWithImpl<$Res>
    extends _$BookTransactionCopyWithImpl<$Res, _$BookTransactionImpl>
    implements _$$BookTransactionImplCopyWith<$Res> {
  __$$BookTransactionImplCopyWithImpl(
    _$BookTransactionImpl _value,
    $Res Function(_$BookTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shelfId = null,
    Object? bookId = null,
    Object? amount = null,
    Object? type = null,
    Object? createdAt = null,
    Object? createdByUid = null,
    Object? remark = freezed,
    Object? category = freezed,
    Object? paymentMode = freezed,
    Object? contactId = freezed,
  }) {
    return _then(
      _$BookTransactionImpl(
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
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdByUid: null == createdByUid
            ? _value.createdByUid
            : createdByUid // ignore: cast_nullable_to_non_nullable
                  as String,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentMode: freezed == paymentMode
            ? _value.paymentMode
            : paymentMode // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactId: freezed == contactId
            ? _value.contactId
            : contactId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookTransactionImpl implements _BookTransaction {
  const _$BookTransactionImpl({
    required this.id,
    required this.shelfId,
    required this.bookId,
    required this.amount,
    required this.type,
    @TimestampConverterNonNull() required this.createdAt,
    required this.createdByUid,
    this.remark,
    this.category,
    this.paymentMode,
    this.contactId,
  });

  factory _$BookTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String shelfId;
  @override
  final String bookId;
  @override
  final double amount;
  @override
  final TransactionType type;
  @override
  @TimestampConverterNonNull()
  final DateTime createdAt;
  @override
  final String createdByUid;
  @override
  final String? remark;
  @override
  final String? category;
  @override
  final String? paymentMode;
  @override
  final String? contactId;

  @override
  String toString() {
    return 'BookTransaction(id: $id, shelfId: $shelfId, bookId: $bookId, amount: $amount, type: $type, createdAt: $createdAt, createdByUid: $createdByUid, remark: $remark, category: $category, paymentMode: $paymentMode, contactId: $contactId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shelfId, shelfId) || other.shelfId == shelfId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdByUid, createdByUid) ||
                other.createdByUid == createdByUid) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.paymentMode, paymentMode) ||
                other.paymentMode == paymentMode) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    shelfId,
    bookId,
    amount,
    type,
    createdAt,
    createdByUid,
    remark,
    category,
    paymentMode,
    contactId,
  );

  /// Create a copy of BookTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookTransactionImplCopyWith<_$BookTransactionImpl> get copyWith =>
      __$$BookTransactionImplCopyWithImpl<_$BookTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookTransactionImplToJson(this);
  }
}

abstract class _BookTransaction implements BookTransaction {
  const factory _BookTransaction({
    required final String id,
    required final String shelfId,
    required final String bookId,
    required final double amount,
    required final TransactionType type,
    @TimestampConverterNonNull() required final DateTime createdAt,
    required final String createdByUid,
    final String? remark,
    final String? category,
    final String? paymentMode,
    final String? contactId,
  }) = _$BookTransactionImpl;

  factory _BookTransaction.fromJson(Map<String, dynamic> json) =
      _$BookTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get shelfId;
  @override
  String get bookId;
  @override
  double get amount;
  @override
  TransactionType get type;
  @override
  @TimestampConverterNonNull()
  DateTime get createdAt;
  @override
  String get createdByUid;
  @override
  String? get remark;
  @override
  String? get category;
  @override
  String? get paymentMode;
  @override
  String? get contactId;

  /// Create a copy of BookTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookTransactionImplCopyWith<_$BookTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
