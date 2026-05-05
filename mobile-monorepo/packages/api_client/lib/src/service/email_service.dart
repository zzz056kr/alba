import 'package:common/common.dart';

import '../api/email_api.dart';
import '../api/email_server_api.dart';
import '../core/api_request_options.dart';
import '../core/api_runtime.dart';
import '../core/http.dart';
import '../mock/email_mock.dart';

class EmailService {
  EmailService({
    required ApiRuntime runtime,
    ApiHttpClient? httpClient,
    EmailApi? mockApi,
  }) : _runtime = runtime,
       _serverApi = EmailServerApi(
         (httpClient ?? ApiHttpClient.create(runtime)).dio,
       ),
       _mockApi = mockApi ?? MockEmailApi();

  final ApiRuntime _runtime;
  final EmailApi _serverApi;
  final EmailApi _mockApi;

  EmailApi get _api => _runtime.isMock ? _mockApi : _serverApi;

  Future<void> sendAuthCode(
    SendAuthCodeRequest request, {
    ApiRequestOptions? options,
  }) async {
    await _api.sendAuthCode(request, options: options);
  }

  Future<void> verify(
    VerifyEmailRequest request, {
    ApiRequestOptions? options,
  }) async {
    await _api.verify(request, options: options);
  }
}
