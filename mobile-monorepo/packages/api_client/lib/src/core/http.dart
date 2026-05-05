import 'package:dio/dio.dart';

import 'api_runtime.dart';

class ApiHttpClient {
  ApiHttpClient._(this.dio);

  final Dio dio;

  factory ApiHttpClient.create(ApiRuntime runtime) {
    final dio = Dio(
      BaseOptions(
        baseUrl: runtime.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return ApiHttpClient._(dio);
  }
}
