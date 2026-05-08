import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/ui_message.dart';
import '../model/form/shop_create_form_value.dart';
import 'app_providers.dart';

class ShopCreateState {
  const ShopCreateState({
    this.message,
    this.createdShop,
    this.isSubmitting = false,
    this.showValidation = false,
    this.isSuccess = false,
  });

  final UiMessage? message;
  final ShopResponse? createdShop;
  final bool isSubmitting;
  final bool showValidation;
  final bool isSuccess;

  ShopCreateState copyWith({
    UiMessage? message,
    ShopResponse? createdShop,
    bool? isSubmitting,
    bool? showValidation,
    bool? isSuccess,
    bool clearMessage = false,
    bool clearCreatedShop = false,
  }) {
    return ShopCreateState(
      message: clearMessage ? null : (message ?? this.message),
      createdShop: clearCreatedShop ? null : (createdShop ?? this.createdShop),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showValidation: showValidation ?? this.showValidation,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ShopCreateController extends AutoDisposeNotifier<ShopCreateState> {
  @override
  ShopCreateState build() {
    return const ShopCreateState();
  }

  void showValidationError() {
    state = state.copyWith(
      showValidation: true,
      isSuccess: false,
      clearMessage: true,
    );
  }

  Future<bool> createShop(ShopCreateFormValue form) async {
    state = state.copyWith(
      isSubmitting: true,
      showValidation: false,
      isSuccess: false,
      clearMessage: true,
      clearCreatedShop: true,
    );

    try {
      final shop = await ref
          .read(shopServiceProvider)
          .createShop(
            CreateShopRequest(
              name: form.name.trim(),
              zipCode: form.zipCode.trim(),
              baseAddress: form.baseAddress.trim(),
              detailAddress: form.detailAddress.trim().isEmpty
                  ? null
                  : form.detailAddress.trim(),
              latitude: form.latitude,
              longitude: form.longitude,
            ),
          );

      state = state.copyWith(
        createdShop: shop,
        isSuccess: true,
        message: UiMessage(
          kind: UiMessageKind.success,
          text: '${shop.name} 매장이 등록되었습니다.',
        ),
      );
      ref.read(selectedShopIdProvider.notifier).state = shop.no;
      ref.invalidate(myShopsProvider);
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
        message: UiMessage(kind: UiMessageKind.error, text: '매장 등록 실패\n$error'),
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

    return '매장 등록에 실패했습니다. 다시 시도해주세요.';
  }
}

final shopCreateControllerProvider =
    NotifierProvider.autoDispose<ShopCreateController, ShopCreateState>(
      ShopCreateController.new,
    );
