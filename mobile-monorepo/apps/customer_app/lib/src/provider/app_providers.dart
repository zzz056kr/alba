import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../common/app_config.dart';
import '../service/app_feedback_service.dart';
import '../service/auth_flow_service.dart';
import '../service/auth_session_storage_service.dart';
import '../service/auth_token_provider_impl.dart';
import '../service/login_lifecycle_service.dart';
import '../service/login_storage_service.dart';
import 'auth_session_controller.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnv();
});

final loginStorageServiceProvider = Provider<LoginStorageService>((ref) {
  return LoginStorageService();
});

final appFeedbackServiceProvider = Provider<AppFeedbackService>((ref) {
  return AppFeedbackService(rootScaffoldMessengerKey);
});

final authSessionStorageServiceProvider = Provider<AuthSessionStorageService>((
  ref,
) {
  return AuthSessionStorageService();
});

final apiRuntimeProvider = Provider<ApiRuntime>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  final feedbackService = ref.watch(appFeedbackServiceProvider);
  return ApiRuntime(
    dataSource: appConfig.dataSource,
    baseUrl: appConfig.apiBaseUrl,
    showError: feedbackService.showError,
  );
});

/// Standalone AuthService used **only** by the refresh interceptor flow.
///
/// Built on a raw `ApiHttpClient` (no interceptor) to avoid a dependency
/// cycle with [authTokenProviderProvider]. `/auth/refresh` is a public path
/// so token attachment / refresh logic is unnecessary here.
final _refreshAuthServiceProvider = Provider<AuthService>((ref) {
  final runtime = ref.watch(apiRuntimeProvider);
  return AuthService(runtime: runtime);
});

final authTokenProviderProvider = Provider<AuthTokenProvider>((ref) {
  Future<TokenResponse> refreshCaller(String refreshToken) {
    return ref.read(_refreshAuthServiceProvider).refresh(refreshToken);
  }

  Future<void> writeToken(TokenResponse token) {
    return ref
        .read(authSessionControllerProvider.notifier)
        .setAuthenticated(token);
  }

  Future<void> clearSession() {
    return ref.read(authSessionControllerProvider.notifier).logout();
  }

  Future<void> ensureSession() async {
    await ref.read(authSessionControllerProvider.future);
  }

  AuthSession? readSession() {
    return ref.read(authSessionControllerProvider).valueOrNull;
  }

  return AuthTokenProviderImpl(
    readSession: readSession,
    ensureSession: ensureSession,
    refreshCaller: refreshCaller,
    writeToken: writeToken,
    clearSession: clearSession,
  );
});

final apiHttpClientProvider = Provider<ApiHttpClient>((ref) {
  final runtime = ref.watch(apiRuntimeProvider);
  final feedbackService = ref.watch(appFeedbackServiceProvider);
  final httpClient = ApiHttpClient.create(runtime);

  AuthTokenProvider getTokenProvider() => ref.read(authTokenProviderProvider);

  setupAuthInterceptor(
    httpClient.dio,
    tokenProvider: getTokenProvider,
    showError: feedbackService.showError,
  );
  return httpClient;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    runtime: ref.watch(apiRuntimeProvider),
    httpClient: ref.watch(apiHttpClientProvider),
  );
});

final emailServiceProvider = Provider<EmailService>((ref) {
  return EmailService(
    runtime: ref.watch(apiRuntimeProvider),
    httpClient: ref.watch(apiHttpClientProvider),
  );
});

final authFlowServiceProvider = Provider<AuthFlowService>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  final authService = ref.watch(authServiceProvider);
  return AuthFlowService(
    authService: authService,
    redirectBaseUrl: appConfig.redirectBaseUrl,
  );
});

final loginLifecycleServiceProvider = Provider<LoginLifecycleService>((ref) {
  return LoginLifecycleService(
    loginStorageService: ref.watch(loginStorageServiceProvider),
    authFlowService: ref.watch(authFlowServiceProvider),
  );
});
