import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_session_storage_service.freezed.dart';

@freezed
class StoredAuthSession with _$StoredAuthSession {
  const factory StoredAuthSession({
    required String accessToken,
    required int accessTokenExpiresIn,
    required String refreshToken,
    required int refreshTokenExpiresIn,
    required String userId,
    required String email,
    required List<String> roles,
    required DateTime issuedAt,
  }) = _StoredAuthSession;
}

class AuthSessionStorageService {
  static const _accessTokenKey = 'auth_access_token';
  static const _accessTokenExpiresInKey = 'auth_access_token_expires_in';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _refreshTokenExpiresInKey = 'auth_refresh_token_expires_in';
  static const _userIdKey = 'auth_user_id';
  static const _emailKey = 'auth_email';
  static const _rolesKey = 'auth_roles';
  static const _issuedAtKey = 'auth_token_issued_at';

  Future<StoredAuthSession?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);
    final userId = prefs.getString(_userIdKey);
    final email = prefs.getString(_emailKey) ?? '';
    final roles = prefs.getStringList(_rolesKey) ?? const <String>['USER'];
    final accessExpiresIn = prefs.getInt(_accessTokenExpiresInKey);
    final refreshExpiresIn = prefs.getInt(_refreshTokenExpiresInKey);
    final issuedAtMillis = prefs.getInt(_issuedAtKey);

    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty ||
        userId == null ||
        userId.isEmpty ||
        accessExpiresIn == null ||
        refreshExpiresIn == null ||
        issuedAtMillis == null) {
      return null;
    }

    return StoredAuthSession(
      accessToken: accessToken,
      accessTokenExpiresIn: accessExpiresIn,
      refreshToken: refreshToken,
      refreshTokenExpiresIn: refreshExpiresIn,
      userId: userId,
      email: email,
      roles: roles,
      issuedAt: DateTime.fromMillisecondsSinceEpoch(issuedAtMillis),
    );
  }

  Future<void> save(StoredAuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, session.accessToken);
    await prefs.setInt(_accessTokenExpiresInKey, session.accessTokenExpiresIn);
    await prefs.setString(_refreshTokenKey, session.refreshToken);
    await prefs.setInt(
      _refreshTokenExpiresInKey,
      session.refreshTokenExpiresIn,
    );
    await prefs.setString(_userIdKey, session.userId);
    await prefs.setString(_emailKey, session.email);
    await prefs.setStringList(_rolesKey, session.roles);
    await prefs.setInt(_issuedAtKey, session.issuedAt.millisecondsSinceEpoch);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_accessTokenExpiresInKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_refreshTokenExpiresInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_rolesKey);
    await prefs.remove(_issuedAtKey);
  }
}
