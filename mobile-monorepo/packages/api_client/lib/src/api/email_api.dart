import 'package:common/common.dart';

import '../core/api_request_options.dart';

abstract class EmailApi {
  Future<ResponseModel<void>> sendAuthCode(
    SendAuthCodeRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<void>> verify(
    VerifyEmailRequest request, {
    ApiRequestOptions? options,
  });
}
