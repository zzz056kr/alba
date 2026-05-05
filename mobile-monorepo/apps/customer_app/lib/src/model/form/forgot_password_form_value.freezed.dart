// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_form_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ForgotPasswordFormValue {
  String get email => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordFormValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordFormValueCopyWith<ForgotPasswordFormValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordFormValueCopyWith<$Res> {
  factory $ForgotPasswordFormValueCopyWith(
    ForgotPasswordFormValue value,
    $Res Function(ForgotPasswordFormValue) then,
  ) = _$ForgotPasswordFormValueCopyWithImpl<$Res, ForgotPasswordFormValue>;
  @useResult
  $Res call({
    String email,
    String code,
    String newPassword,
    String confirmPassword,
  });
}

/// @nodoc
class _$ForgotPasswordFormValueCopyWithImpl<
  $Res,
  $Val extends ForgotPasswordFormValue
>
    implements $ForgotPasswordFormValueCopyWith<$Res> {
  _$ForgotPasswordFormValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordFormValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? code = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            newPassword: null == newPassword
                ? _value.newPassword
                : newPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            confirmPassword: null == confirmPassword
                ? _value.confirmPassword
                : confirmPassword // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForgotPasswordFormValueImplCopyWith<$Res>
    implements $ForgotPasswordFormValueCopyWith<$Res> {
  factory _$$ForgotPasswordFormValueImplCopyWith(
    _$ForgotPasswordFormValueImpl value,
    $Res Function(_$ForgotPasswordFormValueImpl) then,
  ) = __$$ForgotPasswordFormValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String email,
    String code,
    String newPassword,
    String confirmPassword,
  });
}

/// @nodoc
class __$$ForgotPasswordFormValueImplCopyWithImpl<$Res>
    extends
        _$ForgotPasswordFormValueCopyWithImpl<
          $Res,
          _$ForgotPasswordFormValueImpl
        >
    implements _$$ForgotPasswordFormValueImplCopyWith<$Res> {
  __$$ForgotPasswordFormValueImplCopyWithImpl(
    _$ForgotPasswordFormValueImpl _value,
    $Res Function(_$ForgotPasswordFormValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgotPasswordFormValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? code = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(
      _$ForgotPasswordFormValueImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        newPassword: null == newPassword
            ? _value.newPassword
            : newPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        confirmPassword: null == confirmPassword
            ? _value.confirmPassword
            : confirmPassword // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ForgotPasswordFormValueImpl implements _ForgotPasswordFormValue {
  const _$ForgotPasswordFormValueImpl({
    required this.email,
    required this.code,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  final String email;
  @override
  final String code;
  @override
  final String newPassword;
  @override
  final String confirmPassword;

  @override
  String toString() {
    return 'ForgotPasswordFormValue(email: $email, code: $code, newPassword: $newPassword, confirmPassword: $confirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordFormValueImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, code, newPassword, confirmPassword);

  /// Create a copy of ForgotPasswordFormValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordFormValueImplCopyWith<_$ForgotPasswordFormValueImpl>
  get copyWith =>
      __$$ForgotPasswordFormValueImplCopyWithImpl<
        _$ForgotPasswordFormValueImpl
      >(this, _$identity);
}

abstract class _ForgotPasswordFormValue implements ForgotPasswordFormValue {
  const factory _ForgotPasswordFormValue({
    required final String email,
    required final String code,
    required final String newPassword,
    required final String confirmPassword,
  }) = _$ForgotPasswordFormValueImpl;

  @override
  String get email;
  @override
  String get code;
  @override
  String get newPassword;
  @override
  String get confirmPassword;

  /// Create a copy of ForgotPasswordFormValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordFormValueImplCopyWith<_$ForgotPasswordFormValueImpl>
  get copyWith => throw _privateConstructorUsedError;
}
