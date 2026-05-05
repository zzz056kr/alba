import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../service/auth_session_storage_service.dart';
import 'app_providers.dart';

part 'auth_session_controller.freezed.dart';

@freezed
class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    required String accessToken,
    required int accessTokenExpiresIn,
    required String refreshToken,
    required int refreshTokenExpiresIn,
    required String userId,
    required DateTime issuedAt,
  }) = _AuthSession;

  factory AuthSession.fromTokenResponse(
    TokenResponse token, {
    DateTime? issuedAt,
  }) {
    return AuthSession(
      accessToken: token.accessToken,
      accessTokenExpiresIn: token.accessTokenExpiresIn,
      refreshToken: token.refreshToken,
      refreshTokenExpiresIn: token.refreshTokenExpiresIn,
      userId: token.userId,
      issuedAt: issuedAt ?? DateTime.now(),
    );
  }

  TokenResponse toTokenResponse() {
    return TokenResponse(
      accessToken: accessToken,
      accessTokenExpiresIn: accessTokenExpiresIn,
      refreshToken: refreshToken,
      refreshTokenExpiresIn: refreshTokenExpiresIn,
      userId: userId,
    );
  }

  StoredAuthSession toStored() {
    return StoredAuthSession(
      accessToken: accessToken,
      accessTokenExpiresIn: accessTokenExpiresIn,
      refreshToken: refreshToken,
      refreshTokenExpiresIn: refreshTokenExpiresIn,
      userId: userId,
      issuedAt: issuedAt,
    );
  }
}

class AuthSessionController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final stored = await ref.read(authSessionStorageServiceProvider).load();
    if (stored == null) {
      return null;
    }

    return AuthSession(
      accessToken: stored.accessToken,
      accessTokenExpiresIn: stored.accessTokenExpiresIn,
      refreshToken: stored.refreshToken,
      refreshTokenExpiresIn: stored.refreshTokenExpiresIn,
      userId: stored.userId,
      issuedAt: stored.issuedAt,
    );
  }

  Future<void> setAuthenticated(TokenResponse token) async {
    final session = AuthSession.fromTokenResponse(token);
    await ref.read(authSessionStorageServiceProvider).save(session.toStored());
    state = AsyncData(session);
  }

  Future<void> logout() async {
    await ref.read(authSessionStorageServiceProvider).clear();
    state = const AsyncData(null);
  }
}

final authSessionControllerProvider =
    AsyncNotifierProvider<AuthSessionController, AuthSession?>(
      AuthSessionController.new,
    );
