import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/ui_message.dart';
import '../model/form/forgot_password_form_value.dart';
import 'app_providers.dart';

part 'forgot_password_controller.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    UiMessage? message,
    @Default(false) bool isSendingCode,
    @Default(false) bool isSubmitting,
    @Default(false) bool showValidation,
    @Default(false) bool isSuccess,
  }) = _ForgotPasswordState;
}

class ForgotPasswordController
    extends AutoDisposeNotifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() {
    return const ForgotPasswordState();
  }

  void showValidationError() {
    state = state.copyWith(showValidation: true, message: null);
  }

  Future<void> sendCode(String email) async {
    state = state.copyWith(
      isSendingCode: true,
      message: null,
      isSuccess: false,
    );

    try {
      await ref
          .read(emailServiceProvider)
          .sendAuthCode(
            SendAuthCodeRequest(email: email.trim(), type: 'PASSWORD_RESET'),
          );

      state = state.copyWith(
        message: const UiMessage(
          kind: UiMessageKind.success,
          text: '인증 코드가 발송되었습니다. 이메일을 확인해주세요.',
        ),
      );
    } on DioException {
      return;
    } catch (error) {
      state = state.copyWith(
        message: UiMessage(
          kind: UiMessageKind.error,
          text: '인증 코드 발송 실패\n$error',
        ),
      );
    } finally {
      state = state.copyWith(isSendingCode: false);
    }
  }

  Future<bool> resetPassword(ForgotPasswordFormValue form) async {
    state = state.copyWith(
      isSubmitting: true,
      showValidation: false,
      message: null,
      isSuccess: false,
    );

    try {
      await ref
          .read(authServiceProvider)
          .resetPassword(
            ResetPasswordRequest(
              email: form.email.trim(),
              code: form.code.trim(),
              newPassword: form.newPassword,
            ),
          );

      state = state.copyWith(
        message: const UiMessage(
          kind: UiMessageKind.success,
          text: '비밀번호가 재설정되었습니다. 다시 로그인해주세요.',
        ),
        isSuccess: true,
      );
      return true;
    } on DioException {
      return false;
    } catch (error) {
      state = state.copyWith(
        message: UiMessage(
          kind: UiMessageKind.error,
          text: '비밀번호 재설정 실패\n$error',
        ),
      );
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

final forgotPasswordControllerProvider =
    NotifierProvider.autoDispose<ForgotPasswordController, ForgotPasswordState>(
      ForgotPasswordController.new,
    );
