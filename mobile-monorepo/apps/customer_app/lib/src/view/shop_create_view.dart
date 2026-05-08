import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../page/app_shell_page.dart';
import '../provider/shop_create_controller.dart';
import '../model/form/shop_create_form_value.dart';
import 'address_search_view.dart';

class ShopCreateView extends HookConsumerWidget {
  const ShopCreateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(shopCreateControllerProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameController = useTextEditingController();
    final zipCodeController = useTextEditingController();
    final address1Controller = useTextEditingController();
    final address2Controller = useTextEditingController();
    final extraAddress = useState('');
    final isAddressSearchOpen = useState(false);

    ref.listen<ShopCreateState>(shopCreateControllerProvider, (previous, next) {
      if (previous?.message?.text == next.message?.text ||
          next.message == null) {
        return;
      }

      if (next.isSuccess) {
        context.go(AppShellPage.routePath);
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

    Future<void> submit() async {
      FocusScope.of(context).unfocus();

      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) {
        ref.read(shopCreateControllerProvider.notifier).showValidationError();
        return;
      }

      await ref
          .read(shopCreateControllerProvider.notifier)
          .createShop(
            ShopCreateFormValue(
              name: nameController.text,
              zipCode: zipCodeController.text,
              baseAddress: address1Controller.text,
              detailAddress: address2Controller.text,
            ),
          );
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: AppSurfaceCard(
                    child: Form(
                      key: formKey,
                      autovalidateMode: state.showValidation
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const AppHeader(
                            title: '매장 등록',
                            subtitle: '사장님으로 시작하려면 먼저 운영할 매장 정보를 등록하세요.',
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F8F7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F6F78),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.storefront_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    '매장 등록이 끝나면 이후에는 이 매장을 기준으로 사장 화면으로 진입하게 됩니다.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF4E5B61),
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          FormTextField(
                            controller: nameController,
                            labelText: '매장명',
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '매장명을 입력해주세요.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: zipCodeController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: '우편번호',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return '우편번호를 찾아주세요.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 132,
                                child: AppSecondaryButton(
                                  onPressed: () {
                                    isAddressSearchOpen.value = true;
                                  },
                                  label: '우편번호 찾기',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: address1Controller,
                            readOnly: true,
                            decoration: const InputDecoration(labelText: '기본주소'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '기본주소를 찾아주세요.';
                              }
                              return null;
                            },
                          ),
                          if (extraAddress.value.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: extraAddress.value,
                              readOnly: true,
                              decoration: const InputDecoration(labelText: '참고항목'),
                            ),
                          ],
                          const SizedBox(height: 12),
                          FormTextField(
                            controller: address2Controller,
                            labelText: '상세주소',
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '상세주소를 입력해주세요.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => submit(),
                          ),
                          const SizedBox(height: 24),
                          AppPrimaryButton(
                            onPressed: state.isSubmitting ? null : submit,
                            isLoading: state.isSubmitting,
                            label: '매장 등록 시작',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isAddressSearchOpen.value)
            Positioned.fill(
              child: AddressSearchView(
                onCompleted: (result) {
                  zipCodeController.text = result.zipCode;
                  address1Controller.text = result.address1;
                  extraAddress.value = result.extraAddress;
                  isAddressSearchOpen.value = false;
                },
                onClosed: () {
                  isAddressSearchOpen.value = false;
                },
              ),
            ),
        ],
      ),
    );
  }
}
