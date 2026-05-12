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

final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(
    runtime: ref.watch(apiRuntimeProvider),
    httpClient: ref.watch(apiHttpClientProvider),
  );
});

final myShopsProvider = FutureProvider<List<MyShopMembershipResponse>>((ref) {
  final session = ref.watch(authSessionControllerProvider).valueOrNull;
  if (session == null) {
    return <MyShopMembershipResponse>[];
  }

  return ref.watch(shopServiceProvider).getMyShops();
});

final selectedShopIdProvider = StateProvider<int?>((ref) => null);

final shopDetailProvider = FutureProvider.family<ShopResponse, int>((
  ref,
  shopId,
) {
  return ref.watch(shopServiceProvider).getShop(shopId);
});

String _formatDateForApi(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

final shopAttendancesProvider =
    FutureProvider.family<
      List<AttendanceSummaryResponse>,
      ({int shopId, int? shopMemberId, DateTime startDate, DateTime endDate})
    >((ref, params) async {
      final response = await ref
          .watch(shopServiceProvider)
          .getAttendances(
            params.shopId,
            queryParameters: {
              'shopMemberId': params.shopMemberId,
              'startDate': _formatDateForApi(params.startDate),
              'endDate': _formatDateForApi(params.endDate),
              'page': 1,
              'size': 100,
            },
          );
      return response.list ?? const <AttendanceSummaryResponse>[];
    });

final shopSchedulesProvider =
    FutureProvider.family<
      List<ScheduleSummaryResponse>,
      ({int shopId, int? shopMemberId, DateTime baseDate, String viewType})
    >((ref, params) async {
      final response = await ref
          .watch(shopServiceProvider)
          .getSchedules(
            params.shopId,
            queryParameters: {
              'shopMemberId': params.shopMemberId,
              'baseDate': _formatDateForApi(params.baseDate),
              'viewType': params.viewType,
            },
          );
      return response.schedules;
    });

final shopScheduleRangeProvider =
    FutureProvider.family<
      List<ScheduleSummaryResponse>,
      ({int shopId, int? shopMemberId, DateTime startDate, DateTime endDate})
    >((ref, params) async {
      DateTime dateOnly(DateTime date) =>
          DateTime(date.year, date.month, date.day);

      final service = ref.watch(shopServiceProvider);
      final months = <DateTime>[];
      final normalizedStartDate = dateOnly(params.startDate);
      final normalizedEndDate = dateOnly(params.endDate);
      var cursor = DateTime(
        normalizedStartDate.year,
        normalizedStartDate.month,
        1,
      );
      final endMonth = DateTime(
        normalizedEndDate.year,
        normalizedEndDate.month,
        1,
      );
      while (!cursor.isAfter(endMonth)) {
        months.add(cursor);
        cursor = DateTime(cursor.year, cursor.month + 1, 1);
      }

      final responses = await Future.wait(
        months.map(
          (month) => service.getSchedules(
            params.shopId,
            queryParameters: {
              'shopMemberId': params.shopMemberId,
              'baseDate': _formatDateForApi(month),
              'viewType': 'MONTH',
            },
          ),
        ),
      );

      final merged = <int, ScheduleSummaryResponse>{};
      for (final response in responses) {
        for (final schedule in response.schedules) {
          final workDate = schedule.workDate;
          if (workDate == null) {
            continue;
          }
          final normalizedWorkDate = dateOnly(workDate);
          final inRange =
              !normalizedWorkDate.isBefore(normalizedStartDate) &&
              !normalizedWorkDate.isAfter(normalizedEndDate);
          if (inRange) {
            merged[schedule.no] = schedule;
          }
        }
      }
      return merged.values.toList()..sort((left, right) {
        final leftDate = left.workDate ?? params.startDate;
        final rightDate = right.workDate ?? params.startDate;
        final dateCompare = leftDate.compareTo(rightDate);
        if (dateCompare != 0) {
          return dateCompare;
        }
        return left.startTime.compareTo(right.startTime);
      });
    });

final pendingShopMembersProvider =
    FutureProvider.family<List<ShopMemberSummaryResponse>, int>((
      ref,
      shopId,
    ) async {
      final response = await ref
          .watch(shopServiceProvider)
          .getShopMembers(
            shopId,
            queryParameters: const {
              'statuses': 'PENDING',
              'page': 1,
              'size': 50,
            },
          );
      return response.list ?? const <ShopMemberSummaryResponse>[];
    });

final activeShopMembersProvider =
    FutureProvider.family<List<ShopMemberSummaryResponse>, int>((
      ref,
      shopId,
    ) async {
      final response = await ref
          .watch(shopServiceProvider)
          .getShopMembers(
            shopId,
            queryParameters: const {
              'statuses': 'ACTIVE',
              'page': 1,
              'size': 100,
            },
          );
      return response.list ?? const <ShopMemberSummaryResponse>[];
    });

final shopNoticesProvider =
    FutureProvider.family<List<ShopNoticeResponse>, int>((ref, shopId) {
      return ref.watch(shopServiceProvider).getShopNotices(shopId);
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
