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
    required String email,
    required List<String> roles,
    required DateTime issuedAt,
  }) = _AuthSession;

  bool get isVerifiedUser => roles.contains('USER');
  bool get requiresEmailVerification =>
      roles.contains('GUEST') && !roles.contains('USER');

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
      email: token.email,
      roles: token.roles,
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
      email: email,
      roles: roles,
    );
  }

  StoredAuthSession toStored() {
    return StoredAuthSession(
      accessToken: accessToken,
      accessTokenExpiresIn: accessTokenExpiresIn,
      refreshToken: refreshToken,
      refreshTokenExpiresIn: refreshTokenExpiresIn,
      userId: userId,
      email: email,
      roles: roles,
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
      email: stored.email,
      roles: stored.roles,
      issuedAt: stored.issuedAt,
    );
  }

  Future<void> setAuthenticated(TokenResponse token) async {
    final previousUserId = state.valueOrNull?.userId;
    final session = AuthSession.fromTokenResponse(token);
    await ref.read(authSessionStorageServiceProvider).save(session.toStored());
    if (previousUserId != null && previousUserId != session.userId) {
      ref.read(selectedShopIdProvider.notifier).state = null;
      ref.invalidate(myShopsProvider);
    }
    state = AsyncData(session);
  }

  Future<void> logout() async {
    state = const AsyncData(null);
    ref.read(selectedShopIdProvider.notifier).state = null;
    await ref.read(authSessionStorageServiceProvider).clear();
  }
}

final authSessionControllerProvider =
    AsyncNotifierProvider<AuthSessionController, AuthSession?>(
      AuthSessionController.new,
    );
