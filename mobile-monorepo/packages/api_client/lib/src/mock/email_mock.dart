import 'package:common/common.dart';

import '../api/email_api.dart';
import '../core/api_request_options.dart';
import 'mock_utils.dart';

class MockEmailApi implements EmailApi {
  @override
  Future<ResponseModel<void>> sendAuthCode(
    SendAuthCodeRequest request, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      const ResponseModel<void>(code: 'SUCCESS', message: 'ok'),
    );
  }

  @override
  Future<ResponseModel<void>> verify(
    VerifyEmailRequest request, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      const ResponseModel<void>(code: 'SUCCESS', message: 'ok'),
    );
  }
}
