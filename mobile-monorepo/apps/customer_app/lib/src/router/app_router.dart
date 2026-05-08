import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../page/app_shell_page.dart';
import '../page/forgot_password_page.dart';
import '../page/login_page.dart';
import '../page/mypage_page.dart';
import '../page/register_page.dart';
import '../page/shop_create_page.dart';
import '../page/shop_join_page.dart';
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
    ],
    redirect: (context, state) {
      final authSession = ref.read(authSessionControllerProvider);
      final isLoading = authSession.isLoading;
      final isLoggedIn = authSession.valueOrNull != null;

      if (isLoading) {
        return null;
      }

      final location = state.matchedLocation;
      final isAuthRoute =
          location == LoginPage.routePath ||
          location == RegisterPage.routePath ||
          location == ForgotPasswordPage.routePath;
      final isProtectedRoute =
          location == AppShellPage.routePath ||
          location == MyPagePage.routePath ||
          location == ShopCreatePage.routePath ||
          location == ShopJoinPage.routePath;

      if (!isLoggedIn && isProtectedRoute) {
        return LoginPage.routePath;
      }

      if (isLoggedIn && isAuthRoute) {
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
            router.go(LoginPage.routePath);
            break;
        }
      });

  ref.onDispose(subscription.cancel);

  return router;
});
