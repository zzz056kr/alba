import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/ui_message.dart';
import '../model/form/register_form_value.dart';
import 'app_providers.dart';

part 'register_controller.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    UiMessage? message,
    @Default(false) bool isSubmitting,
    @Default(false) bool showValidation,
    @Default(false) bool isSuccess,
  }) = _RegisterState;
}

class RegisterController extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  void showValidationError() {
    state = state.copyWith(
      showValidation: true,
      message: null,
      isSuccess: false,
    );
  }

  Future<bool> register(RegisterFormValue form) async {
    state = state.copyWith(
      isSubmitting: true,
      showValidation: false,
      message: null,
      isSuccess: false,
    );

    try {
      await ref
          .read(authServiceProvider)
          .join(
            JoinRequest(
              id: form.id.trim(),
              name: form.name.trim(),
              email: form.email.trim(),
              password: form.password,
            ),
          );

      state = state.copyWith(
        message: const UiMessage(
          kind: UiMessageKind.success,
          text: '회원가입이 완료되었습니다. 이제 로그인해주세요.',
        ),
        isSuccess: true,
      );
      return true;
    } on DioException catch (error) {
      final data = error.response?.data;
      String message = '회원가입 실패';

      if (data is Map) {
        final responseMessage = data['message'];
        final errorMessage = data['error'];
        if (responseMessage is String && responseMessage.isNotEmpty) {
          message = responseMessage;
        } else if (errorMessage is String && errorMessage.isNotEmpty) {
          message = errorMessage;
        }
      } else if (error.message != null && error.message!.isNotEmpty) {
        message = error.message!;
      }

      state = state.copyWith(
        message: UiMessage(kind: UiMessageKind.error, text: message),
        isSuccess: false,
      );
      return false;
    } catch (error) {
      state = state.copyWith(
        message: UiMessage(kind: UiMessageKind.error, text: '회원가입 실패\n$error'),
        isSuccess: false,
      );
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

final registerControllerProvider =
    NotifierProvider.autoDispose<RegisterController, RegisterState>(
      RegisterController.new,
    );
