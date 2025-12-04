// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoanEvent _$LoanEventFromJson(Map<String, dynamic> json) {
  return _LoanEvent.fromJson(json);
}

/// @nodoc
mixin _$LoanEvent {
  String get id => throw _privateConstructorUsedError;
  String get loanId => throw _privateConstructorUsedError;
  String get shelfId => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  LoanEventType get type => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get createdByUid => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this LoanEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoanEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanEventCopyWith<LoanEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanEventCopyWith<$Res> {
  factory $LoanEventCopyWith(LoanEvent value, $Res Function(LoanEvent) then) =
      _$LoanEventCopyWithImpl<$Res, LoanEvent>;
  @useResult
  $Res call({
    String id,
    String loanId,
    String shelfId,
    String bookId,
    LoanEventType type,
    double amount,
    @TimestampConverter() DateTime? createdAt,
    String? createdByUid,
    String? note,
  });
}

/// @nodoc
class _$LoanEventCopyWithImpl<$Res, $Val extends LoanEvent>
    implements $LoanEventCopyWith<$Res> {
  _$LoanEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoanEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loanId = null,
    Object? shelfId = null,
    Object? bookId = null,
    Object? type = null,
    Object? amount = null,
    Object? createdAt = freezed,
    Object? createdByUid = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            loanId: null == loanId
                ? _value.loanId
                : loanId // ignore: cast_nullable_to_non_nullable
                      as String,
            shelfId: null == shelfId
                ? _value.shelfId
                : shelfId // ignore: cast_nullable_to_non_nullable
                      as String,
            bookId: null == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as LoanEventType,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdByUid: freezed == createdByUid
                ? _value.createdByUid
                : createdByUid // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoanEventImplCopyWith<$Res>
    implements $LoanEventCopyWith<$Res> {
  factory _$$LoanEventImplCopyWith(
    _$LoanEventImpl value,
    $Res Function(_$LoanEventImpl) then,
  ) = __$$LoanEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String loanId,
    String shelfId,
    String bookId,
    LoanEventType type,
    double amount,
    @TimestampConverter() DateTime? createdAt,
    String? createdByUid,
    String? note,
  });
}

/// @nodoc
class __$$LoanEventImplCopyWithImpl<$Res>
    extends _$LoanEventCopyWithImpl<$Res, _$LoanEventImpl>
    implements _$$LoanEventImplCopyWith<$Res> {
  __$$LoanEventImplCopyWithImpl(
    _$LoanEventImpl _value,
    $Res Function(_$LoanEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoanEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? loanId = null,
    Object? shelfId = null,
    Object? bookId = null,
    Object? type = null,
    Object? amount = null,
    Object? createdAt = freezed,
    Object? createdByUid = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _$LoanEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        loanId: null == loanId
            ? _value.loanId
            : loanId // ignore: cast_nullable_to_non_nullable
                  as String,
        shelfId: null == shelfId
            ? _value.shelfId
            : shelfId // ignore: cast_nullable_to_non_nullable
                  as String,
        bookId: null == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as LoanEventType,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdByUid: freezed == createdByUid
            ? _value.createdByUid
            : createdByUid // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanEventImpl implements _LoanEvent {
  const _$LoanEventImpl({
    required this.id,
    required this.loanId,
    required this.shelfId,
    required this.bookId,
    required this.type,
    required this.amount,
    @TimestampConverter() this.createdAt,
    this.createdByUid,
    this.note,
  });

  factory _$LoanEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanEventImplFromJson(json);

  @override
  final String id;
  @override
  final String loanId;
  @override
  final String shelfId;
  @override
  final String bookId;
  @override
  final LoanEventType type;
  @override
  final double amount;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  final String? createdByUid;
  @override
  final String? note;

  @override
  String toString() {
    return 'LoanEvent(id: $id, loanId: $loanId, shelfId: $shelfId, bookId: $bookId, type: $type, amount: $amount, createdAt: $createdAt, createdByUid: $createdByUid, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.loanId, loanId) || other.loanId == loanId) &&
            (identical(other.shelfId, shelfId) || other.shelfId == shelfId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdByUid, createdByUid) ||
                other.createdByUid == createdByUid) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    loanId,
    shelfId,
    bookId,
    type,
    amount,
    createdAt,
    createdByUid,
    note,
  );

  /// Create a copy of LoanEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanEventImplCopyWith<_$LoanEventImpl> get copyWith =>
      __$$LoanEventImplCopyWithImpl<_$LoanEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanEventImplToJson(this);
  }
}

abstract class _LoanEvent implements LoanEvent {
  const factory _LoanEvent({
    required final String id,
    required final String loanId,
    required final String shelfId,
    required final String bookId,
    required final LoanEventType type,
    required final double amount,
    @TimestampConverter() final DateTime? createdAt,
    final String? createdByUid,
    final String? note,
  }) = _$LoanEventImpl;

  factory _LoanEvent.fromJson(Map<String, dynamic> json) =
      _$LoanEventImpl.fromJson;

  @override
  String get id;
  @override
  String get loanId;
  @override
  String get shelfId;
  @override
  String get bookId;
  @override
  LoanEventType get type;
  @override
  double get amount;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  String? get createdByUid;
  @override
  String? get note;

  /// Create a copy of LoanEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanEventImplCopyWith<_$LoanEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
