import 'dart:async';

import 'package:common/common.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/form/login_form_value.dart';
import '../page/app_shell_page.dart';
import '../page/forgot_password_page.dart';
import '../page/register_page.dart';
import '../provider/app_providers.dart';
import '../provider/auth_session_controller.dart';
import '../provider/login_controller.dart';
import '../widget/social_login_button.dart';
import '../widget/social_marks.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  static const _loginRoles = <({String label, String title})>[
    (label: '사장', title: '사장님 로그인'),
    (label: '직원', title: '직원 로그인'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final idController = useTextEditingController();
    final passwordController = useTextEditingController();
    final shouldNavigateOnOAuth = useRef(false);
    final tabController = useTabController(initialLength: _loginRoles.length);
    useListenable(tabController);
    final selectedRoleIndex = tabController.index;
    final selectedRole = _loginRoles[selectedRoleIndex];

    useEffect(() {
      Future<void> restoreSavedId() async {
        final savedId = await ref
            .read(loginControllerProvider.notifier)
            .restoreSavedId();
        if (savedId != null) {
          idController.text = savedId;
        }
      }

      restoreSavedId();

      final authFlowService = ref.read(authFlowServiceProvider);
      final controller = ref.read(loginControllerProvider.notifier);
      final subscription = authFlowService.listenDeepLinks((callback) {
        unawaited(controller.handleOAuthCallback(callback));
      });
      unawaited(
        authFlowService.handleInitialLink((callback) {
          unawaited(controller.handleOAuthCallback(callback));
        }),
      );

      return () {
        unawaited(subscription.cancel());
      };
    }, const []);

    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (previous?.message?.text == next.message?.text ||
          next.message == null) {
        return;
      }

      shouldNavigateOnOAuth.value = false;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(next.message!.text),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });

    ref.listen<AsyncValue<AuthSession?>>(authSessionControllerProvider, (
      previous,
      next,
    ) {
      final wasLoggedIn = previous?.valueOrNull != null;
      final isLoggedIn = next.valueOrNull != null;
      if (shouldNavigateOnOAuth.value &&
          !wasLoggedIn &&
          isLoggedIn &&
          context.mounted) {
        shouldNavigateOnOAuth.value = false;
        context.go(AppShellPage.routePath);
      }
    });

    Future<void> login() async {
      FocusScope.of(context).unfocus();

      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) {
        shouldNavigateOnOAuth.value = false;
        ref.read(loginControllerProvider.notifier).showValidationError();
        return;
      }

      final success = await ref
          .read(loginControllerProvider.notifier)
          .login(
            LoginFormValue(
              id: idController.text,
              password: passwordController.text,
            ),
          );

      if (!context.mounted || !success) {
        return;
      }

      context.go(AppShellPage.routePath);
    }

    Future<void> startSocialLogin(OAuthProvider provider) async {
      shouldNavigateOnOAuth.value = true;
      final success = await ref
          .read(loginControllerProvider.notifier)
          .startSocialLogin(provider);
      if (success && context.mounted) {
        shouldNavigateOnOAuth.value = false;
        context.go(AppShellPage.routePath);
        return;
      }

      shouldNavigateOnOAuth.value = false;
    }

    return AuthScaffold(
      title: selectedRole.title,
      child: Form(
        key: formKey,
        autovalidateMode: state.showValidation
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: const Color(0xFF111827),
                unselectedLabelColor: const Color(0xFF6B7280),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: [
                  for (final role in _loginRoles) Tab(text: role.label),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FormTextField(
              controller: idController,
              labelText: '${selectedRole.label} 아이디',
              textInputAction: TextInputAction.next,
              validator: AccountSchema.loginId,
            ),
            const SizedBox(height: 12),
            FormPasswordField(
              controller: passwordController,
              labelText: '${selectedRole.label} 비밀번호',
              textInputAction: TextInputAction.done,
              validator: AccountSchema.loginPassword,
              onFieldSubmitted: (_) => state.isLoggingIn ? null : login(),
            ),
            Row(
              children: [
                FormCheckboxField(
                  value: state.rememberId,
                  label: '아이디 저장',
                  onChanged: (value) {
                    ref
                        .read(loginControllerProvider.notifier)
                        .setRememberId(value);
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.push(RegisterPage.routePath);
                  },
                  child: const Text('회원가입'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.push(ForgotPasswordPage.routePath);
                },
                child: const Text('비밀번호를 잊으셨나요?'),
              ),
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              onPressed: state.isLoggingIn ? null : login,
              isLoading: state.isLoggingIn,
              label: '${selectedRole.label} 로그인',
            ),
            const SizedBox(height: 22),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('또는'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 22),
            SocialLoginButton(
              label: 'Google로 ${selectedRole.label} 로그인',
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF202124),
              borderColor: const Color(0xFFDADCE0),
              icon: const GoogleMark(),
              onPressed: () => startSocialLogin(OAuthProvider.google),
            ),
            const SizedBox(height: 12),
            SocialLoginButton(
              label: '카카오로 ${selectedRole.label} 로그인',
              backgroundColor: const Color(0xFFFEE500),
              foregroundColor: const Color(0xFF191600),
              icon: const KakaoMark(),
              onPressed: () => startSocialLogin(OAuthProvider.kakao),
            ),
            const SizedBox(height: 12),
            SocialLoginButton(
              label: '네이버로 ${selectedRole.label} 로그인',
              backgroundColor: const Color(0xFF03C75A),
              foregroundColor: Colors.white,
              icon: const NaverMark(),
              onPressed: () => startSocialLogin(OAuthProvider.naver),
            ),
          ],
        ),
      ),
    );
  }
}
