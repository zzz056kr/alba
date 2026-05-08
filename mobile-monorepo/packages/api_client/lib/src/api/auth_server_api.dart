import 'package:dio/dio.dart';
import 'package:common/common.dart';

import '../core/api_request_options.dart';
import 'auth_api.dart';

class AuthServerApi implements AuthApi {
  const AuthServerApi(this._dio);

  final Dio _dio;

  @override
  Future<ResponseModel<void>> join(
    JoinRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/join',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<void>.fromJson(
      response.data ?? const <String, dynamic>{},
      null,
    );
  }

  @override
  Future<ResponseModel<void>> resetPassword(
    ResetPasswordRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/reset-password',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<void>.fromJson(
      response.data ?? const <String, dynamic>{},
      null,
    );
  }

  @override
  Future<ResponseModel<TokenResponse>> login(
    LoginRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/app/auth/login',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<TokenResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => TokenResponse.fromJson(
        value is Map<String, dynamic>
            ? <String, dynamic>{'data': value}
            : const <String, dynamic>{},
      ),
    );
  }

  @override
  Future<ResponseModel<TokenResponse>> refresh(
    String refreshToken, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/app/auth/refresh',
      data: {'refreshToken': refreshToken},
      options: options?.toDioOptions(),
    );

    return ResponseModel<TokenResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => TokenResponse.fromJson(
        value is Map<String, dynamic>
            ? <String, dynamic>{'data': value}
            : const <String, dynamic>{},
      ),
    );
  }

  @override
  Uri socialLoginUri(OAuthProvider provider, {required String redirectUrl}) {
    final baseUri = Uri.parse(_dio.options.baseUrl);
    return baseUri.replace(
      path: '/oauth2/login/${provider.name}',
      queryParameters: {'redirect_url': redirectUrl},
    );
  }
}
