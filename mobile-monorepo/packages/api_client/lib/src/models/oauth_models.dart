import 'package:common/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'oauth_models.freezed.dart';

@freezed
class OAuthCallbackResult with _$OAuthCallbackResult {
  const OAuthCallbackResult._();

  const factory OAuthCallbackResult({
    OAuthProvider? provider,
    String? error,
    @Default(false) bool isMock,
    String? accessToken,
    int? accessTokenExpiresIn,
    String? refreshToken,
    int? refreshTokenExpiresIn,
    String? userId,
  }) = _OAuthCallbackResult;

  bool get isSuccess => error == null;

  bool get hasSession =>
      (accessToken?.isNotEmpty ?? false) &&
      (refreshToken?.isNotEmpty ?? false) &&
      (userId?.isNotEmpty ?? false) &&
      accessTokenExpiresIn != null &&
      refreshTokenExpiresIn != null;

  TokenResponse? get tokenResponse {
    if (!hasSession) {
      return null;
    }

    return TokenResponse(
      accessToken: accessToken!,
      accessTokenExpiresIn: accessTokenExpiresIn!,
      refreshToken: refreshToken!,
      refreshTokenExpiresIn: refreshTokenExpiresIn!,
      userId: userId!,
      email: '',
      roles: const ['USER'],
    );
  }

  factory OAuthCallbackResult.fromUri(Uri uri) {
    final providerName = uri.queryParameters['provider'];
    final provider = OAuthProvider.values.cast<OAuthProvider?>().firstWhere(
      (value) => value?.name == providerName,
      orElse: () => null,
    );

    return OAuthCallbackResult(
      provider: provider,
      error: uri.queryParameters['error'],
      isMock: uri.queryParameters['mock'] == 'true',
      accessToken: uri.queryParameters['accessToken'],
      accessTokenExpiresIn: int.tryParse(
        uri.queryParameters['accessTokenExpiresIn'] ?? '',
      ),
      refreshToken: uri.queryParameters['refreshToken'],
      refreshTokenExpiresIn: int.tryParse(
        uri.queryParameters['refreshTokenExpiresIn'] ?? '',
      ),
      userId: uri.queryParameters['userId'],
    );
  }
}
