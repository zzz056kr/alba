import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/ui_message.dart';
import 'app_providers.dart';

class ShopMemberApproveState {
  const ShopMemberApproveState({
    this.message,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final UiMessage? message;
  final bool isSubmitting;
  final bool isSuccess;

  ShopMemberApproveState copyWith({
    UiMessage? message,
    bool? isSubmitting,
    bool? isSuccess,
    bool clearMessage = false,
  }) {
    return ShopMemberApproveState(
      message: clearMessage ? null : (message ?? this.message),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ShopMemberApproveController
    extends AutoDisposeNotifier<ShopMemberApproveState> {
  @override
  ShopMemberApproveState build() {
    return const ShopMemberApproveState();
  }

  Future<bool> approve({
    required int shopId,
    required int shopMemberId,
    required int baseWage,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      isSuccess: false,
      clearMessage: true,
    );

    try {
      await ref
          .read(shopServiceProvider)
          .approveShopMember(
            shopId,
            shopMemberId,
            ShopMemberApproveRequest(baseWage: baseWage),
          );
      ref.invalidate(pendingShopMembersProvider(shopId));
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        message: const UiMessage(
          kind: UiMessageKind.success,
          text: '직원 승인이 완료되었습니다.',
        ),
      );
      return true;
    } on DioException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        message: UiMessage(
          kind: UiMessageKind.error,
          text: _resolveErrorMessage(error),
        ),
      );
      return false;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        message: UiMessage(kind: UiMessageKind.error, text: '직원 승인 실패\n$error'),
      );
      return false;
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

    return '직원 승인에 실패했습니다. 다시 시도해주세요.';
  }
}

final shopMemberApproveControllerProvider =
    NotifierProvider.autoDispose<
      ShopMemberApproveController,
      ShopMemberApproveState
    >(ShopMemberApproveController.new);
