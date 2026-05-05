// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SendAuthCodeRequest _$SendAuthCodeRequestFromJson(Map<String, dynamic> json) {
  return _SendAuthCodeRequest.fromJson(json);
}

/// @nodoc
mixin _$SendAuthCodeRequest {
  String get email => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this SendAuthCodeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendAuthCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendAuthCodeRequestCopyWith<SendAuthCodeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendAuthCodeRequestCopyWith<$Res> {
  factory $SendAuthCodeRequestCopyWith(
    SendAuthCodeRequest value,
    $Res Function(SendAuthCodeRequest) then,
  ) = _$SendAuthCodeRequestCopyWithImpl<$Res, SendAuthCodeRequest>;
  @useResult
  $Res call({String email, String type});
}

/// @nodoc
class _$SendAuthCodeRequestCopyWithImpl<$Res, $Val extends SendAuthCodeRequest>
    implements $SendAuthCodeRequestCopyWith<$Res> {
  _$SendAuthCodeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendAuthCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? type = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendAuthCodeRequestImplCopyWith<$Res>
    implements $SendAuthCodeRequestCopyWith<$Res> {
  factory _$$SendAuthCodeRequestImplCopyWith(
    _$SendAuthCodeRequestImpl value,
    $Res Function(_$SendAuthCodeRequestImpl) then,
  ) = __$$SendAuthCodeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String type});
}

/// @nodoc
class __$$SendAuthCodeRequestImplCopyWithImpl<$Res>
    extends _$SendAuthCodeRequestCopyWithImpl<$Res, _$SendAuthCodeRequestImpl>
    implements _$$SendAuthCodeRequestImplCopyWith<$Res> {
  __$$SendAuthCodeRequestImplCopyWithImpl(
    _$SendAuthCodeRequestImpl _value,
    $Res Function(_$SendAuthCodeRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendAuthCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? type = null}) {
    return _then(
      _$SendAuthCodeRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SendAuthCodeRequestImpl implements _SendAuthCodeRequest {
  const _$SendAuthCodeRequestImpl({required this.email, required this.type});

  factory _$SendAuthCodeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendAuthCodeRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String type;

  @override
  String toString() {
    return 'SendAuthCodeRequest(email: $email, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendAuthCodeRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, type);

  /// Create a copy of SendAuthCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendAuthCodeRequestImplCopyWith<_$SendAuthCodeRequestImpl> get copyWith =>
      __$$SendAuthCodeRequestImplCopyWithImpl<_$SendAuthCodeRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SendAuthCodeRequestImplToJson(this);
  }
}

abstract class _SendAuthCodeRequest implements SendAuthCodeRequest {
  const factory _SendAuthCodeRequest({
    required final String email,
    required final String type,
  }) = _$SendAuthCodeRequestImpl;

  factory _SendAuthCodeRequest.fromJson(Map<String, dynamic> json) =
      _$SendAuthCodeRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get type;

  /// Create a copy of SendAuthCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendAuthCodeRequestImplCopyWith<_$SendAuthCodeRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerifyEmailRequest _$VerifyEmailRequestFromJson(Map<String, dynamic> json) {
  return _VerifyEmailRequest.fromJson(json);
}

/// @nodoc
mixin _$VerifyEmailRequest {
  String get email => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this VerifyEmailRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyEmailRequestCopyWith<VerifyEmailRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyEmailRequestCopyWith<$Res> {
  factory $VerifyEmailRequestCopyWith(
    VerifyEmailRequest value,
    $Res Function(VerifyEmailRequest) then,
  ) = _$VerifyEmailRequestCopyWithImpl<$Res, VerifyEmailRequest>;
  @useResult
  $Res call({String email, String code, String type});
}

/// @nodoc
class _$VerifyEmailRequestCopyWithImpl<$Res, $Val extends VerifyEmailRequest>
    implements $VerifyEmailRequestCopyWith<$Res> {
  _$VerifyEmailRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? code = null, Object? type = null}) {
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerifyEmailRequestImplCopyWith<$Res>
    implements $VerifyEmailRequestCopyWith<$Res> {
  factory _$$VerifyEmailRequestImplCopyWith(
    _$VerifyEmailRequestImpl value,
    $Res Function(_$VerifyEmailRequestImpl) then,
  ) = __$$VerifyEmailRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String code, String type});
}

/// @nodoc
class __$$VerifyEmailRequestImplCopyWithImpl<$Res>
    extends _$VerifyEmailRequestCopyWithImpl<$Res, _$VerifyEmailRequestImpl>
    implements _$$VerifyEmailRequestImplCopyWith<$Res> {
  __$$VerifyEmailRequestImplCopyWithImpl(
    _$VerifyEmailRequestImpl _value,
    $Res Function(_$VerifyEmailRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerifyEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? code = null, Object? type = null}) {
    return _then(
      _$VerifyEmailRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyEmailRequestImpl implements _VerifyEmailRequest {
  const _$VerifyEmailRequestImpl({
    required this.email,
    required this.code,
    required this.type,
  });

  factory _$VerifyEmailRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyEmailRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String code;
  @override
  final String type;

  @override
  String toString() {
    return 'VerifyEmailRequest(email: $email, code: $code, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyEmailRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, code, type);

  /// Create a copy of VerifyEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyEmailRequestImplCopyWith<_$VerifyEmailRequestImpl> get copyWith =>
      __$$VerifyEmailRequestImplCopyWithImpl<_$VerifyEmailRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyEmailRequestImplToJson(this);
  }
}

abstract class _VerifyEmailRequest implements VerifyEmailRequest {
  const factory _VerifyEmailRequest({
    required final String email,
    required final String code,
    required final String type,
  }) = _$VerifyEmailRequestImpl;

  factory _VerifyEmailRequest.fromJson(Map<String, dynamic> json) =
      _$VerifyEmailRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get code;
  @override
  String get type;

  /// Create a copy of VerifyEmailRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyEmailRequestImplCopyWith<_$VerifyEmailRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
