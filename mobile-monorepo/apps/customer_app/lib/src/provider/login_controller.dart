import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/ui_message.dart';
import '../model/form/login_form_value.dart';
import 'app_providers.dart';
import 'auth_session_controller.dart';

part 'login_controller.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    UiMessage? message,
    @Default(false) bool isLoggingIn,
    @Default(false) bool rememberId,
    @Default(false) bool showValidation,
  }) = _LoginState;
}

class LoginController extends AutoDisposeNotifier<LoginState> {
  String? _lastHandledOAuthCallbackKey;

  @override
  LoginState build() {
    return const LoginState();
  }

  Future<String?> restoreSavedId() async {
    final savedId = await ref
        .read(loginLifecycleServiceProvider)
        .restoreSavedId();
    if (savedId == null) {
      return null;
    }

    state = state.copyWith(rememberId: true);
    return savedId;
  }

  void setRememberId(bool value) {
    state = state.copyWith(rememberId: value);
  }

  void showValidationError() {
    state = state.copyWith(showValidation: true, message: null);
  }

  Future<bool> handleOAuthCallback(OAuthCallbackResult callback) async {
    final callbackKey = _buildOAuthCallbackKey(callback);
    if (_lastHandledOAuthCallbackKey == callbackKey) {
      return false;
    }
    _lastHandledOAuthCallbackKey = callbackKey;

    final token = callback.tokenResponse;
    if (!callback.isSuccess) {
      state = state.copyWith(
        message: const UiMessage(
          kind: UiMessageKind.error,
          text: '소셜 로그인에 실패했습니다. 다시 시도해주세요.',
        ),
      );
      return false;
    }

    if (token != null) {
      await ref
          .read(authSessionControllerProvider.notifier)
          .setAuthenticated(token);
      state = state.copyWith(message: null);
      return true;
    }

    state = state.copyWith(
      message: UiMessage(
        kind: UiMessageKind.error,
        text: '${callback.provider?.name ?? 'oauth'} 로그인 정보가 올바르지 않습니다.',
      ),
    );
    return false;
  }

  Future<bool> login(LoginFormValue form) async {
    state = state.copyWith(
      isLoggingIn: true,
      showValidation: false,
      message: null,
    );

    try {
      final token = await ref
          .read(authServiceProvider)
          .login(LoginRequest(id: form.id.trim(), password: form.password));

      await ref
          .read(loginStorageServiceProvider)
          .persistLoginId(rememberId: state.rememberId, loginId: form.id);

      await ref
          .read(authSessionControllerProvider.notifier)
          .setAuthenticated(token);

      return true;
    } on DioException catch (error) {
      state = state.copyWith(
        message: UiMessage(
          kind: UiMessageKind.error,
          text: _resolveLoginErrorMessage(error),
        ),
      );
      return false;
    } catch (error) {
      state = state.copyWith(
        message: UiMessage(kind: UiMessageKind.error, text: '로그인 실패\n$error'),
      );
      return false;
    } finally {
      state = state.copyWith(isLoggingIn: false);
    }
  }

  Future<bool> startSocialLogin(OAuthProvider provider) async {
    try {
      final callback = await ref
          .read(authFlowServiceProvider)
          .startSocialLogin(provider);
      return await handleOAuthCallback(callback);
    } on PlatformException catch (error) {
      if (_isUserCancelled(error)) {
        state = state.copyWith(message: null);
        return false;
      }

      state = state.copyWith(
        message: const UiMessage(
          kind: UiMessageKind.error,
          text: '로그인 페이지를 열지 못했습니다.',
        ),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        message: const UiMessage(
          kind: UiMessageKind.error,
          text: '소셜 로그인에 실패했습니다. 다시 시도해주세요.',
        ),
      );
      return false;
    }
  }

  bool _isUserCancelled(PlatformException error) {
    return error.code.toLowerCase().contains('cancel') ||
        (error.message?.toLowerCase().contains('cancel') ?? false);
  }

  String _buildOAuthCallbackKey(OAuthCallbackResult callback) {
    return [
      callback.provider?.name ?? '',
      callback.error ?? '',
      callback.accessToken ?? '',
      callback.refreshToken ?? '',
      callback.userId ?? '',
      callback.accessTokenExpiresIn?.toString() ?? '',
      callback.refreshTokenExpiresIn?.toString() ?? '',
      callback.isMock.toString(),
    ].join('|');
  }

  String _resolveLoginErrorMessage(DioException error) {
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

    return '로그인에 실패했습니다. 다시 시도해주세요.';
  }
}

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, LoginState>(
      LoginController.new,
    );
