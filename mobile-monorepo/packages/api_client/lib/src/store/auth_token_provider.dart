import 'package:common/common.dart';

abstract class AuthTokenProvider {
  TokenResponse? get tokenResponse;
  DateTime? get tokenIssuedAt;
  bool get isInitialized;

  Future<void> initializeAuth();
  Future<bool> refreshToken();
  void clearTokenResponse();
}
