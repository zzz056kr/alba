import 'package:common/common.dart';

import '../core/api_request_options.dart';

abstract class AuthApi {
  Future<ResponseModel<void>> join(
    JoinRequest request, {
    ApiRequestOptions? options,
  });
  Future<ResponseModel<void>> resetPassword(
    ResetPasswordRequest request, {
    ApiRequestOptions? options,
  });
  Future<ResponseModel<TokenResponse>> login(
    LoginRequest request, {
    ApiRequestOptions? options,
  });
  Future<ResponseModel<TokenResponse>> refresh(
    String refreshToken, {
    ApiRequestOptions? options,
  });
  Uri socialLoginUri(OAuthProvider provider, {required String redirectUrl});
}
