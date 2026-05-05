import 'dart:async';

import 'package:api_client/api_client.dart';

import 'auth_flow_service.dart';
import 'login_storage_service.dart';

class LoginLifecycleService {
  const LoginLifecycleService({
    required this.loginStorageService,
    required this.authFlowService,
  });

  final LoginStorageService loginStorageService;
  final AuthFlowService authFlowService;

  Future<String?> restoreSavedId() {
    return loginStorageService.getSavedLoginId();
  }

  StreamSubscription<Uri> bindDeepLinks(
    void Function(OAuthCallbackResult result) onCallback,
  ) {
    return authFlowService.listenDeepLinks(onCallback);
  }

  Future<void> handleInitialLink(
    void Function(OAuthCallbackResult result) onCallback,
  ) {
    return authFlowService.handleInitialLink(onCallback);
  }
}
