// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RegisterState {
  UiMessage? get message => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get showValidation => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterStateCopyWith<RegisterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterStateCopyWith<$Res> {
  factory $RegisterStateCopyWith(
    RegisterState value,
    $Res Function(RegisterState) then,
  ) = _$RegisterStateCopyWithImpl<$Res, RegisterState>;
  @useResult
  $Res call({
    UiMessage? message,
    bool isSubmitting,
    bool showValidation,
    bool isSuccess,
  });

  $UiMessageCopyWith<$Res>? get message;
}

/// @nodoc
class _$RegisterStateCopyWithImpl<$Res, $Val extends RegisterState>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? isSubmitting = null,
    Object? showValidation = null,
    Object? isSuccess = null,
  }) {
    return _then(
      _value.copyWith(
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as UiMessage?,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            showValidation: null == showValidation
                ? _value.showValidation
                : showValidation // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UiMessageCopyWith<$Res>? get message {
    if (_value.message == null) {
      return null;
    }

    return $UiMessageCopyWith<$Res>(_value.message!, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegisterStateImplCopyWith<$Res>
    implements $RegisterStateCopyWith<$Res> {
  factory _$$RegisterStateImplCopyWith(
    _$RegisterStateImpl value,
    $Res Function(_$RegisterStateImpl) then,
  ) = __$$RegisterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UiMessage? message,
    bool isSubmitting,
    bool showValidation,
    bool isSuccess,
  });

  @override
  $UiMessageCopyWith<$Res>? get message;
}

/// @nodoc
class __$$RegisterStateImplCopyWithImpl<$Res>
    extends _$RegisterStateCopyWithImpl<$Res, _$RegisterStateImpl>
    implements _$$RegisterStateImplCopyWith<$Res> {
  __$$RegisterStateImplCopyWithImpl(
    _$RegisterStateImpl _value,
    $Res Function(_$RegisterStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? isSubmitting = null,
    Object? showValidation = null,
    Object? isSuccess = null,
  }) {
    return _then(
      _$RegisterStateImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as UiMessage?,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        showValidation: null == showValidation
            ? _value.showValidation
            : showValidation // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RegisterStateImpl implements _RegisterState {
  const _$RegisterStateImpl({
    this.message,
    this.isSubmitting = false,
    this.showValidation = false,
    this.isSuccess = false,
  });

  @override
  final UiMessage? message;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool showValidation;
  @override
  @JsonKey()
  final bool isSuccess;

  @override
  String toString() {
    return 'RegisterState(message: $message, isSubmitting: $isSubmitting, showValidation: $showValidation, isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterStateImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.showValidation, showValidation) ||
                other.showValidation == showValidation) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    isSubmitting,
    showValidation,
    isSuccess,
  );

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterStateImplCopyWith<_$RegisterStateImpl> get copyWith =>
      __$$RegisterStateImplCopyWithImpl<_$RegisterStateImpl>(this, _$identity);
}

abstract class _RegisterState implements RegisterState {
  const factory _RegisterState({
    final UiMessage? message,
    final bool isSubmitting,
    final bool showValidation,
    final bool isSuccess,
  }) = _$RegisterStateImpl;

  @override
  UiMessage? get message;
  @override
  bool get isSubmitting;
  @override
  bool get showValidation;
  @override
  bool get isSuccess;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterStateImplCopyWith<_$RegisterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
