import 'package:api_client/api_client.dart';

import '../provider/auth_session_controller.dart';

typedef SessionReader = AuthSession? Function();
typedef SessionEnsurer = Future<void> Function();
typedef RefreshCaller = Future<TokenResponse> Function(String refreshToken);
typedef SessionWriter = Future<void> Function(TokenResponse token);
typedef SessionClearer = Future<void> Function();

class AuthTokenProviderImpl implements AuthTokenProvider {
  AuthTokenProviderImpl({
    required SessionReader readSession,
    required SessionEnsurer ensureSession,
    required RefreshCaller refreshCaller,
    required SessionWriter writeToken,
    required SessionClearer clearSession,
  }) : _readSession = readSession,
       _ensureSession = ensureSession,
       _refreshCaller = refreshCaller,
       _writeToken = writeToken,
       _clearSession = clearSession;

  final SessionReader _readSession;
  final SessionEnsurer _ensureSession;
  final RefreshCaller _refreshCaller;
  final SessionWriter _writeToken;
  final SessionClearer _clearSession;

  bool _initialized = false;

  @override
  bool get isInitialized => _initialized;

  @override
  TokenResponse? get tokenResponse => _readSession()?.toTokenResponse();

  @override
  DateTime? get tokenIssuedAt => _readSession()?.issuedAt;

  @override
  Future<void> initializeAuth() async {
    if (_initialized) return;
    await _ensureSession();
    _initialized = true;
  }

  @override
  Future<bool> refreshToken() async {
    final current = _readSession();
    if (current == null || current.refreshToken.isEmpty) return false;

    try {
      final token = await _refreshCaller(current.refreshToken);
      await _writeToken(token);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void clearTokenResponse() {
    _clearSession();
  }
}
