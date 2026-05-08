import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/ui_message.dart';
import 'app_providers.dart';

class ShopJoinState {
  const ShopJoinState({
    this.message,
    this.result,
    this.isSubmitting = false,
    this.showValidation = false,
    this.isSuccess = false,
  });

  final UiMessage? message;
  final JoinShopResponse? result;
  final bool isSubmitting;
  final bool showValidation;
  final bool isSuccess;

  ShopJoinState copyWith({
    UiMessage? message,
    JoinShopResponse? result,
    bool? isSubmitting,
    bool? showValidation,
    bool? isSuccess,
    bool clearMessage = false,
    bool clearResult = false,
  }) {
    return ShopJoinState(
      message: clearMessage ? null : (message ?? this.message),
      result: clearResult ? null : (result ?? this.result),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showValidation: showValidation ?? this.showValidation,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ShopJoinController extends AutoDisposeNotifier<ShopJoinState> {
  @override
  ShopJoinState build() {
    return const ShopJoinState();
  }

  void showValidationError() {
    state = state.copyWith(
      showValidation: true,
      isSuccess: false,
      clearMessage: true,
    );
  }

  Future<bool> joinShop(String inviteCode) async {
    state = state.copyWith(
      isSubmitting: true,
      showValidation: false,
      isSuccess: false,
      clearMessage: true,
      clearResult: true,
    );

    try {
      final result = await ref
          .read(shopServiceProvider)
          .joinShop(JoinShopRequest(inviteCode: inviteCode.trim()));

      state = state.copyWith(
        result: result,
        isSuccess: true,
        message: const UiMessage(
          kind: UiMessageKind.success,
          text: '매장 합류 요청이 완료되었습니다. 사장님의 승인 후 이용할 수 있습니다.',
        ),
      );
      return true;
    } on DioException catch (error) {
      state = state.copyWith(
        isSuccess: false,
        message: UiMessage(
          kind: UiMessageKind.error,
          text: _resolveErrorMessage(error),
        ),
      );
      return false;
    } catch (error) {
      state = state.copyWith(
        isSuccess: false,
        message: UiMessage(
          kind: UiMessageKind.error,
          text: '매장 합류 요청 실패\n$error',
        ),
      );
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  String _resolveErrorMessage(DioException error) {
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

    return '매장 합류 요청에 실패했습니다. 다시 시도해주세요.';
  }
}

final shopJoinControllerProvider =
    NotifierProvider.autoDispose<ShopJoinController, ShopJoinState>(
      ShopJoinController.new,
    );
