import 'package:api_client/api_client.dart';
import 'package:design_system/design_system.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/app_providers.dart';
import '../provider/auth_session_controller.dart';

class EmailVerificationView extends HookConsumerWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSession = ref.watch(authSessionControllerProvider);
    final session = authSession.valueOrNull;
    final codeController = useTextEditingController();
    final isSending = useState(false);
    final isSubmitting = useState(false);

    void showMessage(String text) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
        );
    }

    String resolveError(
      DioException error, {
      String fallback = '요청 처리에 실패했습니다.',
    }) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }

        final errorMessage = data['error'];
        if (errorMessage is String && errorMessage.isNotEmpty) {
          return errorMessage;
        }
      }

      return error.message?.isNotEmpty == true ? error.message! : fallback;
    }

    Future<void> resendCode() async {
      if (session == null || session.email.isEmpty) {
        showMessage('이메일 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
        return;
      }

      isSending.value = true;
      try {
        await ref
            .read(emailServiceProvider)
            .sendAuthCode(
              SendAuthCodeRequest(email: session.email, type: 'JOIN'),
            );
        showMessage('인증 코드가 발송되었습니다. 이메일을 확인해주세요.');
      } on DioException catch (error) {
        showMessage(resolveError(error, fallback: '인증 코드 발송에 실패했습니다.'));
      } finally {
        isSending.value = false;
      }
    }

    Future<void> verifyCode() async {
      if (session == null || session.email.isEmpty) {
        showMessage('이메일 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
        return;
      }

      final code = codeController.text.trim();
      if (code.isEmpty) {
        showMessage('인증 코드를 입력해주세요.');
        return;
      }

      FocusScope.of(context).unfocus();
      isSubmitting.value = true;

      try {
        await ref
            .read(emailServiceProvider)
            .verify(
              VerifyEmailRequest(
                email: session.email,
                code: code,
                type: 'JOIN',
              ),
            );

        final refreshedToken = await ref
            .read(authServiceProvider)
            .refresh(session.refreshToken);

        await ref
            .read(authSessionControllerProvider.notifier)
            .setAuthenticated(refreshedToken);
      } on DioException catch (error) {
        showMessage(resolveError(error, fallback: '이메일 인증에 실패했습니다.'));
      } finally {
        isSubmitting.value = false;
      }
    }

    Future<void> logout() async {
      await ref.read(authSessionControllerProvider.notifier).logout();
    }

    final email = session?.email ?? '';

    return AuthScaffold(
      title: '이메일 인증',
      subtitle: email.isEmpty
          ? '이메일 인증 후 메인 페이지로 이동할 수 있습니다.'
          : '$email 로 발송된 인증 코드를 입력해주세요.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormTextField(
            controller: codeController,
            labelText: '인증 코드',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => isSubmitting.value ? null : verifyCode(),
          ),
          const SizedBox(height: 12),
          AppPrimaryButton(
            onPressed: isSubmitting.value ? null : verifyCode,
            isLoading: isSubmitting.value,
            label: '인증 완료',
          ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            onPressed: isSending.value ? null : resendCode,
            isLoading: isSending.value,
            label: '인증 코드 재발송',
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: logout, child: const Text('로그아웃')),
        ],
      ),
    );
  }
}
