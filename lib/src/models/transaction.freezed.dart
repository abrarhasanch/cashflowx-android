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

AccountTransaction _$AccountTransactionFromJson(Map<String, dynamic> json) {
  return _AccountTransaction.fromJson(json);
}

/// @nodoc
mixin _$AccountTransaction {
  String get id => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  @TimestampConverterNonNull()
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get createdByUid => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get paymentMode => throw _privateConstructorUsedError;
  String? get contactId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get dueDate => throw _privateConstructorUsedError;
  bool get isPaid => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get paidAt => throw _privateConstructorUsedError;

  /// Serializes this AccountTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountTransactionCopyWith<AccountTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountTransactionCopyWith<$Res> {
  factory $AccountTransactionCopyWith(
    AccountTransaction value,
    $Res Function(AccountTransaction) then,
  ) = _$AccountTransactionCopyWithImpl<$Res, AccountTransaction>;
  @useResult
  $Res call({
    String id,
    String accountId,
    double amount,
    TransactionType type,
    @TimestampConverterNonNull() DateTime createdAt,
    String createdByUid,
    String? remark,
    String? category,
    String? paymentMode,
    String? contactId,
    @TimestampConverter() DateTime? dueDate,
    bool isPaid,
    @TimestampConverter() DateTime? paidAt,
  });
}

/// @nodoc
class _$AccountTransactionCopyWithImpl<$Res, $Val extends AccountTransaction>
    implements $AccountTransactionCopyWith<$Res> {
  _$AccountTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? amount = null,
    Object? type = null,
    Object? createdAt = null,
    Object? createdByUid = null,
    Object? remark = freezed,
    Object? category = freezed,
    Object? paymentMode = freezed,
    Object? contactId = freezed,
    Object? dueDate = freezed,
    Object? isPaid = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
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
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isPaid: null == isPaid
                ? _value.isPaid
                : isPaid // ignore: cast_nullable_to_non_nullable
                      as bool,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountTransactionImplCopyWith<$Res>
    implements $AccountTransactionCopyWith<$Res> {
  factory _$$AccountTransactionImplCopyWith(
    _$AccountTransactionImpl value,
    $Res Function(_$AccountTransactionImpl) then,
  ) = __$$AccountTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String accountId,
    double amount,
    TransactionType type,
    @TimestampConverterNonNull() DateTime createdAt,
    String createdByUid,
    String? remark,
    String? category,
    String? paymentMode,
    String? contactId,
    @TimestampConverter() DateTime? dueDate,
    bool isPaid,
    @TimestampConverter() DateTime? paidAt,
  });
}

/// @nodoc
class __$$AccountTransactionImplCopyWithImpl<$Res>
    extends _$AccountTransactionCopyWithImpl<$Res, _$AccountTransactionImpl>
    implements _$$AccountTransactionImplCopyWith<$Res> {
  __$$AccountTransactionImplCopyWithImpl(
    _$AccountTransactionImpl _value,
    $Res Function(_$AccountTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? amount = null,
    Object? type = null,
    Object? createdAt = null,
    Object? createdByUid = null,
    Object? remark = freezed,
    Object? category = freezed,
    Object? paymentMode = freezed,
    Object? contactId = freezed,
    Object? dueDate = freezed,
    Object? isPaid = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _$AccountTransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
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
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isPaid: null == isPaid
            ? _value.isPaid
            : isPaid // ignore: cast_nullable_to_non_nullable
                  as bool,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountTransactionImpl implements _AccountTransaction {
  const _$AccountTransactionImpl({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.type,
    @TimestampConverterNonNull() required this.createdAt,
    required this.createdByUid,
    this.remark,
    this.category,
    this.paymentMode,
    this.contactId,
    @TimestampConverter() this.dueDate,
    this.isPaid = false,
    @TimestampConverter() this.paidAt,
  });

  factory _$AccountTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String accountId;
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
  @TimestampConverter()
  final DateTime? dueDate;
  @override
  @JsonKey()
  final bool isPaid;
  @override
  @TimestampConverter()
  final DateTime? paidAt;

  @override
  String toString() {
    return 'AccountTransaction(id: $id, accountId: $accountId, amount: $amount, type: $type, createdAt: $createdAt, createdByUid: $createdByUid, remark: $remark, category: $category, paymentMode: $paymentMode, contactId: $contactId, dueDate: $dueDate, isPaid: $isPaid, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
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
                other.contactId == contactId) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    accountId,
    amount,
    type,
    createdAt,
    createdByUid,
    remark,
    category,
    paymentMode,
    contactId,
    dueDate,
    isPaid,
    paidAt,
  );

  /// Create a copy of AccountTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountTransactionImplCopyWith<_$AccountTransactionImpl> get copyWith =>
      __$$AccountTransactionImplCopyWithImpl<_$AccountTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountTransactionImplToJson(this);
  }
}

abstract class _AccountTransaction implements AccountTransaction {
  const factory _AccountTransaction({
    required final String id,
    required final String accountId,
    required final double amount,
    required final TransactionType type,
    @TimestampConverterNonNull() required final DateTime createdAt,
    required final String createdByUid,
    final String? remark,
    final String? category,
    final String? paymentMode,
    final String? contactId,
    @TimestampConverter() final DateTime? dueDate,
    final bool isPaid,
    @TimestampConverter() final DateTime? paidAt,
  }) = _$AccountTransactionImpl;

  factory _AccountTransaction.fromJson(Map<String, dynamic> json) =
      _$AccountTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get accountId;
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
  @override
  @TimestampConverter()
  DateTime? get dueDate;
  @override
  bool get isPaid;
  @override
  @TimestampConverter()
  DateTime? get paidAt;

  /// Create a copy of AccountTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountTransactionImplCopyWith<_$AccountTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
