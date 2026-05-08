import 'package:common/common.dart';

import '../api/auth_api.dart';
import '../core/api_request_options.dart';
import 'mock_utils.dart';

class MockAuthApi implements AuthApi {
  @override
  Future<ResponseModel<void>> join(
    JoinRequest request, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      const ResponseModel<void>(code: 'SUCCESS', message: 'ok'),
    );
  }

  @override
  Future<ResponseModel<void>> resetPassword(
    ResetPasswordRequest request, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      const ResponseModel<void>(code: 'SUCCESS', message: 'ok'),
    );
  }

  @override
  Future<ResponseModel<TokenResponse>> login(
    LoginRequest request, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      ResponseModel<TokenResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: TokenResponse(
          accessToken: 'mock-access-token',
          accessTokenExpiresIn: 3600,
          refreshToken: 'mock-refresh-token',
          refreshTokenExpiresIn: 604800,
          userId: request.id,
          email: '${request.id}@example.com',
          roles: const ['USER'],
        ),
      ),
    );
  }

  @override
  Future<ResponseModel<TokenResponse>> refresh(
    String refreshToken, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      const ResponseModel<TokenResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: TokenResponse(
          accessToken: 'mock-refreshed-access-token',
          accessTokenExpiresIn: 3600,
          refreshToken: 'mock-refreshed-refresh-token',
          refreshTokenExpiresIn: 604800,
          userId: 'mock-user',
          email: 'mock-user@example.com',
          roles: const ['USER'],
        ),
      ),
    );
  }

  @override
  Uri socialLoginUri(OAuthProvider provider, {required String redirectUrl}) {
    return Uri.parse(
      '$redirectUrl/login/callback?provider=${provider.name}&mock=true',
    );
  }
}
