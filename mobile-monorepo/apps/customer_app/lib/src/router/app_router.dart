import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../page/app_shell_page.dart';
import '../page/email_verification_page.dart';
import '../page/forgot_password_page.dart';
import '../page/login_page.dart';
import '../page/mypage_page.dart';
import '../page/register_page.dart';
import '../page/shop_create_page.dart';
import '../page/shop_join_page.dart';
import '../page/shop_schedule_create_page.dart';
import '../provider/auth_session_controller.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);
  ref.listen<AsyncValue<AuthSession?>>(
    authSessionControllerProvider,
    (previous, next) => refreshListenable.value++,
  );
  ref.onDispose(refreshListenable.dispose);

  final router = GoRouter(
    initialLocation: LoginPage.routePath,
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: AppShellPage.routePath,
        builder: (context, state) => const AppShellPage(),
      ),
      GoRoute(
        path: LoginPage.routePath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: EmailVerificationPage.routePath,
        builder: (context, state) => const EmailVerificationPage(),
      ),
      GoRoute(
        path: RegisterPage.routePath,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: ForgotPasswordPage.routePath,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: MyPagePage.routePath,
        builder: (context, state) {
          final authSession = ref.read(authSessionControllerProvider);
          final session = authSession.valueOrNull;
          return MyPagePage(userId: session?.userId ?? '');
        },
      ),
      GoRoute(
        path: ShopCreatePage.routePath,
        builder: (context, state) => const ShopCreatePage(),
      ),
      GoRoute(
        path: ShopJoinPage.routePath,
        builder: (context, state) => const ShopJoinPage(),
      ),
      GoRoute(
        path: ShopScheduleCreatePage.routePath,
        builder: (context, state) {
          final shopId = int.tryParse(
            state.uri.queryParameters['shopId'] ?? '',
          );
          if (shopId == null) {
            return const Scaffold(body: Center(child: Text('잘못된 매장 정보입니다.')));
          }
          return ShopScheduleCreatePage(
            shopId: shopId,
            initialScheduleId: int.tryParse(
              state.uri.queryParameters['scheduleId'] ?? '',
            ),
            initialShopMemberId: int.tryParse(
              state.uri.queryParameters['shopMemberId'] ?? '',
            ),
            initialWorkDate: DateTime.tryParse(
              state.uri.queryParameters['workDate'] ?? '',
            ),
            initialStartTime: state.uri.queryParameters['startTime'],
            initialEndTime: state.uri.queryParameters['endTime'],
            initialRepeatGroupKey: state.uri.queryParameters['repeatGroupKey'],
          );
        },
      ),
    ],
    redirect: (context, state) {
      final authSession = ref.read(authSessionControllerProvider);
      final isLoading = authSession.isLoading;
      final session = authSession.valueOrNull;
      final isLoggedIn = session != null;
      final requiresEmailVerification =
          session?.requiresEmailVerification ?? false;
      final isVerifiedUser = session?.isVerifiedUser ?? false;

      if (isLoading) {
        return null;
      }

      final location = state.matchedLocation;
      final isAuthRoute =
          location == LoginPage.routePath ||
          location == RegisterPage.routePath ||
          location == ForgotPasswordPage.routePath;
      final isVerificationRoute = location == EmailVerificationPage.routePath;
      final isProtectedRoute =
          location == AppShellPage.routePath ||
          location == MyPagePage.routePath ||
          location == ShopCreatePage.routePath ||
          location == ShopJoinPage.routePath ||
          location == ShopScheduleCreatePage.routePath;

      if (!isLoggedIn && (isProtectedRoute || isVerificationRoute)) {
        return LoginPage.routePath;
      }

      if (requiresEmailVerification &&
          !isVerificationRoute &&
          (isProtectedRoute || isAuthRoute)) {
        return EmailVerificationPage.routePath;
      }

      if (isLoggedIn &&
          isVerifiedUser &&
          (isAuthRoute || isVerificationRoute)) {
        return AppShellPage.routePath;
      }

      return null;
    },
  );

  final StreamSubscription<AuthEvent> subscription = AuthEventBus
      .instance
      .stream
      .listen((event) {
        switch (event) {
          case AuthEvent.redirectToLogin:
            ref.read(authSessionControllerProvider.notifier).logout();
            break;
        }
      });

  ref.onDispose(subscription.cancel);

  return router;
});
