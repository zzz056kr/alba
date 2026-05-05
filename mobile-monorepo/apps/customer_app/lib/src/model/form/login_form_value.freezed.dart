// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_form_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginFormValue {
  String get id => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Create a copy of LoginFormValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginFormValueCopyWith<LoginFormValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginFormValueCopyWith<$Res> {
  factory $LoginFormValueCopyWith(
    LoginFormValue value,
    $Res Function(LoginFormValue) then,
  ) = _$LoginFormValueCopyWithImpl<$Res, LoginFormValue>;
  @useResult
  $Res call({String id, String password});
}

/// @nodoc
class _$LoginFormValueCopyWithImpl<$Res, $Val extends LoginFormValue>
    implements $LoginFormValueCopyWith<$Res> {
  _$LoginFormValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginFormValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginFormValueImplCopyWith<$Res>
    implements $LoginFormValueCopyWith<$Res> {
  factory _$$LoginFormValueImplCopyWith(
    _$LoginFormValueImpl value,
    $Res Function(_$LoginFormValueImpl) then,
  ) = __$$LoginFormValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String password});
}

/// @nodoc
class __$$LoginFormValueImplCopyWithImpl<$Res>
    extends _$LoginFormValueCopyWithImpl<$Res, _$LoginFormValueImpl>
    implements _$$LoginFormValueImplCopyWith<$Res> {
  __$$LoginFormValueImplCopyWithImpl(
    _$LoginFormValueImpl _value,
    $Res Function(_$LoginFormValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginFormValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? password = null}) {
    return _then(
      _$LoginFormValueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoginFormValueImpl implements _LoginFormValue {
  const _$LoginFormValueImpl({required this.id, required this.password});

  @override
  final String id;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginFormValue(id: $id, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginFormValueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, password);

  /// Create a copy of LoginFormValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginFormValueImplCopyWith<_$LoginFormValueImpl> get copyWith =>
      __$$LoginFormValueImplCopyWithImpl<_$LoginFormValueImpl>(
        this,
        _$identity,
      );
}

abstract class _LoginFormValue implements LoginFormValue {
  const factory _LoginFormValue({
    required final String id,
    required final String password,
  }) = _$LoginFormValueImpl;

  @override
  String get id;
  @override
  String get password;

  /// Create a copy of LoginFormValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginFormValueImplCopyWith<_$LoginFormValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
