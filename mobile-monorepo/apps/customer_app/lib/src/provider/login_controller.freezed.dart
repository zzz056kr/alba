// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginState {
  UiMessage? get message => throw _privateConstructorUsedError;
  bool get isLoggingIn => throw _privateConstructorUsedError;
  bool get rememberId => throw _privateConstructorUsedError;
  bool get showValidation => throw _privateConstructorUsedError;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginStateCopyWith<LoginState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
    LoginState value,
    $Res Function(LoginState) then,
  ) = _$LoginStateCopyWithImpl<$Res, LoginState>;
  @useResult
  $Res call({
    UiMessage? message,
    bool isLoggingIn,
    bool rememberId,
    bool showValidation,
  });

  $UiMessageCopyWith<$Res>? get message;
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res, $Val extends LoginState>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? isLoggingIn = null,
    Object? rememberId = null,
    Object? showValidation = null,
  }) {
    return _then(
      _value.copyWith(
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as UiMessage?,
            isLoggingIn: null == isLoggingIn
                ? _value.isLoggingIn
                : isLoggingIn // ignore: cast_nullable_to_non_nullable
                      as bool,
            rememberId: null == rememberId
                ? _value.rememberId
                : rememberId // ignore: cast_nullable_to_non_nullable
                      as bool,
            showValidation: null == showValidation
                ? _value.showValidation
                : showValidation // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginState
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
abstract class _$$LoginStateImplCopyWith<$Res>
    implements $LoginStateCopyWith<$Res> {
  factory _$$LoginStateImplCopyWith(
    _$LoginStateImpl value,
    $Res Function(_$LoginStateImpl) then,
  ) = __$$LoginStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UiMessage? message,
    bool isLoggingIn,
    bool rememberId,
    bool showValidation,
  });

  @override
  $UiMessageCopyWith<$Res>? get message;
}

/// @nodoc
class __$$LoginStateImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginStateImpl>
    implements _$$LoginStateImplCopyWith<$Res> {
  __$$LoginStateImplCopyWithImpl(
    _$LoginStateImpl _value,
    $Res Function(_$LoginStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? isLoggingIn = null,
    Object? rememberId = null,
    Object? showValidation = null,
  }) {
    return _then(
      _$LoginStateImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as UiMessage?,
        isLoggingIn: null == isLoggingIn
            ? _value.isLoggingIn
            : isLoggingIn // ignore: cast_nullable_to_non_nullable
                  as bool,
        rememberId: null == rememberId
            ? _value.rememberId
            : rememberId // ignore: cast_nullable_to_non_nullable
                  as bool,
        showValidation: null == showValidation
            ? _value.showValidation
            : showValidation // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LoginStateImpl implements _LoginState {
  const _$LoginStateImpl({
    this.message,
    this.isLoggingIn = false,
    this.rememberId = false,
    this.showValidation = false,
  });

  @override
  final UiMessage? message;
  @override
  @JsonKey()
  final bool isLoggingIn;
  @override
  @JsonKey()
  final bool rememberId;
  @override
  @JsonKey()
  final bool showValidation;

  @override
  String toString() {
    return 'LoginState(message: $message, isLoggingIn: $isLoggingIn, rememberId: $rememberId, showValidation: $showValidation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginStateImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isLoggingIn, isLoggingIn) ||
                other.isLoggingIn == isLoggingIn) &&
            (identical(other.rememberId, rememberId) ||
                other.rememberId == rememberId) &&
            (identical(other.showValidation, showValidation) ||
                other.showValidation == showValidation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    isLoggingIn,
    rememberId,
    showValidation,
  );

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginStateImplCopyWith<_$LoginStateImpl> get copyWith =>
      __$$LoginStateImplCopyWithImpl<_$LoginStateImpl>(this, _$identity);
}

abstract class _LoginState implements LoginState {
  const factory _LoginState({
    final UiMessage? message,
    final bool isLoggingIn,
    final bool rememberId,
    final bool showValidation,
  }) = _$LoginStateImpl;

  @override
  UiMessage? get message;
  @override
  bool get isLoggingIn;
  @override
  bool get rememberId;
  @override
  bool get showValidation;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginStateImplCopyWith<_$LoginStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
