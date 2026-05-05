import 'package:common/common.dart';

import '../api/auth_api.dart';
import '../api/auth_server_api.dart';
import '../core/api_request_options.dart';
import '../core/api_runtime.dart';
import '../core/http.dart';
import '../mock/auth_mock.dart';

class AuthService {
  AuthService({
    required ApiRuntime runtime,
    ApiHttpClient? httpClient,
    AuthApi? mockApi,
  }) : _runtime = runtime,
       _serverApi = AuthServerApi(
         (httpClient ?? ApiHttpClient.create(runtime)).dio,
       ),
       _mockApi = mockApi ?? MockAuthApi();

  final ApiRuntime _runtime;
  final AuthApi _serverApi;
  final AuthApi _mockApi;

  AuthApi get _api => _runtime.isMock ? _mockApi : _serverApi;

  T _requireData<T>(ResponseModel<T> response) {
    final data = response.data;
    if (data == null) {
      throw StateError(response.message ?? 'Response data is missing.');
    }
    return data;
  }

  Future<void> join(JoinRequest request, {ApiRequestOptions? options}) async {
    await _api.join(request, options: options);
  }

  Future<void> resetPassword(
    ResetPasswordRequest request, {
    ApiRequestOptions? options,
  }) async {
    await _api.resetPassword(request, options: options);
  }

  Future<TokenResponse> login(
    LoginRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.login(request, options: options);
    return _requireData(response);
  }

  Future<TokenResponse> refresh(
    String refreshToken, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.refresh(refreshToken, options: options);
    return _requireData(response);
  }

  Uri socialLoginUri(OAuthProvider provider, {required String redirectUrl}) {
    return _api.socialLoginUri(provider, redirectUrl: redirectUrl);
  }
}
