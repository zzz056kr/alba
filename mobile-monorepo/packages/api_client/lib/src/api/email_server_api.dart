import 'package:common/common.dart';
import 'package:dio/dio.dart';

import '../core/api_request_options.dart';
import 'email_api.dart';

class EmailServerApi implements EmailApi {
  const EmailServerApi(this._dio);

  final Dio _dio;

  @override
  Future<ResponseModel<void>> sendAuthCode(
    SendAuthCodeRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/email/send-auth-code',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<void>.fromJson(
      response.data ?? const <String, dynamic>{},
      null,
    );
  }

  @override
  Future<ResponseModel<void>> verify(
    VerifyEmailRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/email/verify',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<void>.fromJson(
      response.data ?? const <String, dynamic>{},
      null,
    );
  }
}
