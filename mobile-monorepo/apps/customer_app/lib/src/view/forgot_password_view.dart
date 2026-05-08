import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/form/forgot_password_form_value.dart';
import '../page/login_page.dart';
import '../provider/forgot_password_controller.dart';

class ForgotPasswordView extends HookConsumerWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController();
    final codeController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    ref.listen<ForgotPasswordState>(forgotPasswordControllerProvider, (
      previous,
      next,
    ) {
      if (previous?.message?.text == next.message?.text ||
          next.message == null) {
        return;
      }

      if (next.isSuccess) {
        context.go(LoginPage.routePath);
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(next.message!.text),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });

    Future<void> sendCode() async {
      final emailError = AccountSchema.registerEmail(emailController.text);
      if (emailError != null) {
        ref
            .read(forgotPasswordControllerProvider.notifier)
            .showValidationError();
        return;
      }

      await ref
          .read(forgotPasswordControllerProvider.notifier)
          .sendCode(emailController.text);
    }

    Future<void> submit() async {
      FocusScope.of(context).unfocus();

      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) {
        ref
            .read(forgotPasswordControllerProvider.notifier)
            .showValidationError();
        return;
      }

      await ref
          .read(forgotPasswordControllerProvider.notifier)
          .resetPassword(
            ForgotPasswordFormValue(
              email: emailController.text,
              code: codeController.text,
              newPassword: passwordController.text,
              confirmPassword: confirmPasswordController.text,
            ),
          );
    }

    return AuthScaffold(
      title: '비밀번호 재설정',
      subtitle: '이메일 인증 코드를 받아 새 비밀번호를 설정하세요.',
      child: Form(
        key: formKey,
        autovalidateMode: state.showValidation
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormEmailField(
              controller: emailController,
              labelText: '이메일',
              textInputAction: TextInputAction.next,
              validator: AccountSchema.registerEmail,
            ),
            const SizedBox(height: 12),
            AppSecondaryButton(
              onPressed: state.isSendingCode ? null : sendCode,
              isLoading: state.isSendingCode,
              label: '인증 코드 발송',
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: codeController,
              labelText: '인증 코드',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: AccountSchema.authCode,
            ),
            const SizedBox(height: 12),
            FormPasswordField(
              controller: passwordController,
              labelText: '새 비밀번호',
              textInputAction: TextInputAction.next,
              validator: AccountSchema.registerPassword,
            ),
            const SizedBox(height: 12),
            FormPasswordField(
              controller: confirmPasswordController,
              labelText: '새 비밀번호 확인',
              textInputAction: TextInputAction.done,
              validator: AccountSchema.confirmPassword(passwordController.text),
              onFieldSubmitted: (_) => state.isSubmitting ? null : submit(),
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              onPressed: state.isSubmitting ? null : submit,
              isLoading: state.isSubmitting,
              label: '비밀번호 재설정',
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.go(LoginPage.routePath);
              },
              child: const Text('로그인으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
