// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_storage_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StoredAuthSession {
  String get accessToken => throw _privateConstructorUsedError;
  int get accessTokenExpiresIn => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  int get refreshTokenExpiresIn => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  DateTime get issuedAt => throw _privateConstructorUsedError;

  /// Create a copy of StoredAuthSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoredAuthSessionCopyWith<StoredAuthSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoredAuthSessionCopyWith<$Res> {
  factory $StoredAuthSessionCopyWith(
    StoredAuthSession value,
    $Res Function(StoredAuthSession) then,
  ) = _$StoredAuthSessionCopyWithImpl<$Res, StoredAuthSession>;
  @useResult
  $Res call({
    String accessToken,
    int accessTokenExpiresIn,
    String refreshToken,
    int refreshTokenExpiresIn,
    String userId,
    String email,
    List<String> roles,
    DateTime issuedAt,
  });
}

/// @nodoc
class _$StoredAuthSessionCopyWithImpl<$Res, $Val extends StoredAuthSession>
    implements $StoredAuthSessionCopyWith<$Res> {
  _$StoredAuthSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoredAuthSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? accessTokenExpiresIn = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresIn = null,
    Object? userId = null,
    Object? email = null,
    Object? roles = null,
    Object? issuedAt = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            accessTokenExpiresIn: null == accessTokenExpiresIn
                ? _value.accessTokenExpiresIn
                : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                      as int,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshTokenExpiresIn: null == refreshTokenExpiresIn
                ? _value.refreshTokenExpiresIn
                : refreshTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            issuedAt: null == issuedAt
                ? _value.issuedAt
                : issuedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoredAuthSessionImplCopyWith<$Res>
    implements $StoredAuthSessionCopyWith<$Res> {
  factory _$$StoredAuthSessionImplCopyWith(
    _$StoredAuthSessionImpl value,
    $Res Function(_$StoredAuthSessionImpl) then,
  ) = __$$StoredAuthSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String accessToken,
    int accessTokenExpiresIn,
    String refreshToken,
    int refreshTokenExpiresIn,
    String userId,
    String email,
    List<String> roles,
    DateTime issuedAt,
  });
}

/// @nodoc
class __$$StoredAuthSessionImplCopyWithImpl<$Res>
    extends _$StoredAuthSessionCopyWithImpl<$Res, _$StoredAuthSessionImpl>
    implements _$$StoredAuthSessionImplCopyWith<$Res> {
  __$$StoredAuthSessionImplCopyWithImpl(
    _$StoredAuthSessionImpl _value,
    $Res Function(_$StoredAuthSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoredAuthSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? accessTokenExpiresIn = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresIn = null,
    Object? userId = null,
    Object? email = null,
    Object? roles = null,
    Object? issuedAt = null,
  }) {
    return _then(
      _$StoredAuthSessionImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        accessTokenExpiresIn: null == accessTokenExpiresIn
            ? _value.accessTokenExpiresIn
            : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshTokenExpiresIn: null == refreshTokenExpiresIn
            ? _value.refreshTokenExpiresIn
            : refreshTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        issuedAt: null == issuedAt
            ? _value.issuedAt
            : issuedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$StoredAuthSessionImpl implements _StoredAuthSession {
  const _$StoredAuthSessionImpl({
    required this.accessToken,
    required this.accessTokenExpiresIn,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
    required this.userId,
    required this.email,
    required final List<String> roles,
    required this.issuedAt,
  }) : _roles = roles;

  @override
  final String accessToken;
  @override
  final int accessTokenExpiresIn;
  @override
  final String refreshToken;
  @override
  final int refreshTokenExpiresIn;
  @override
  final String userId;
  @override
  final String email;
  final List<String> _roles;
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final DateTime issuedAt;

  @override
  String toString() {
    return 'StoredAuthSession(accessToken: $accessToken, accessTokenExpiresIn: $accessTokenExpiresIn, refreshToken: $refreshToken, refreshTokenExpiresIn: $refreshTokenExpiresIn, userId: $userId, email: $email, roles: $roles, issuedAt: $issuedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoredAuthSessionImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.accessTokenExpiresIn, accessTokenExpiresIn) ||
                other.accessTokenExpiresIn == accessTokenExpiresIn) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.refreshTokenExpiresIn, refreshTokenExpiresIn) ||
                other.refreshTokenExpiresIn == refreshTokenExpiresIn) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessToken,
    accessTokenExpiresIn,
    refreshToken,
    refreshTokenExpiresIn,
    userId,
    email,
    const DeepCollectionEquality().hash(_roles),
    issuedAt,
  );

  /// Create a copy of StoredAuthSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoredAuthSessionImplCopyWith<_$StoredAuthSessionImpl> get copyWith =>
      __$$StoredAuthSessionImplCopyWithImpl<_$StoredAuthSessionImpl>(
        this,
        _$identity,
      );
}

abstract class _StoredAuthSession implements StoredAuthSession {
  const factory _StoredAuthSession({
    required final String accessToken,
    required final int accessTokenExpiresIn,
    required final String refreshToken,
    required final int refreshTokenExpiresIn,
    required final String userId,
    required final String email,
    required final List<String> roles,
    required final DateTime issuedAt,
  }) = _$StoredAuthSessionImpl;

  @override
  String get accessToken;
  @override
  int get accessTokenExpiresIn;
  @override
  String get refreshToken;
  @override
  int get refreshTokenExpiresIn;
  @override
  String get userId;
  @override
  String get email;
  @override
  List<String> get roles;
  @override
  DateTime get issuedAt;

  /// Create a copy of StoredAuthSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoredAuthSessionImplCopyWith<_$StoredAuthSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
