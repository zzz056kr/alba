// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_form_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RegisterFormValue {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;

  /// Create a copy of RegisterFormValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterFormValueCopyWith<RegisterFormValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterFormValueCopyWith<$Res> {
  factory $RegisterFormValueCopyWith(
    RegisterFormValue value,
    $Res Function(RegisterFormValue) then,
  ) = _$RegisterFormValueCopyWithImpl<$Res, RegisterFormValue>;
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    String password,
    String confirmPassword,
  });
}

/// @nodoc
class _$RegisterFormValueCopyWithImpl<$Res, $Val extends RegisterFormValue>
    implements $RegisterFormValueCopyWith<$Res> {
  _$RegisterFormValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterFormValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RegisterFormValueImplCopyWith<$Res>
    implements $RegisterFormValueCopyWith<$Res> {
  factory _$$RegisterFormValueImplCopyWith(
    _$RegisterFormValueImpl value,
    $Res Function(_$RegisterFormValueImpl) then,
  ) = __$$RegisterFormValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    String password,
    String confirmPassword,
  });
}

/// @nodoc
class __$$RegisterFormValueImplCopyWithImpl<$Res>
    extends _$RegisterFormValueCopyWithImpl<$Res, _$RegisterFormValueImpl>
    implements _$$RegisterFormValueImplCopyWith<$Res> {
  __$$RegisterFormValueImplCopyWithImpl(
    _$RegisterFormValueImpl _value,
    $Res Function(_$RegisterFormValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterFormValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
  }) {
    return _then(
      _$RegisterFormValueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
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

class _$RegisterFormValueImpl implements _RegisterFormValue {
  const _$RegisterFormValueImpl({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String password;
  @override
  final String confirmPassword;

  @override
  String toString() {
    return 'RegisterFormValue(id: $id, name: $name, email: $email, password: $password, confirmPassword: $confirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterFormValueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, email, password, confirmPassword);

  /// Create a copy of RegisterFormValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterFormValueImplCopyWith<_$RegisterFormValueImpl> get copyWith =>
      __$$RegisterFormValueImplCopyWithImpl<_$RegisterFormValueImpl>(
        this,
        _$identity,
      );
}

abstract class _RegisterFormValue implements RegisterFormValue {
  const factory _RegisterFormValue({
    required final String id,
    required final String name,
    required final String email,
    required final String password,
    required final String confirmPassword,
  }) = _$RegisterFormValueImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get password;
  @override
  String get confirmPassword;

  /// Create a copy of RegisterFormValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterFormValueImplCopyWith<_$RegisterFormValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
