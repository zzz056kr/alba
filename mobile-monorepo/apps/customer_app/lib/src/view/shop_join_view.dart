import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../page/app_shell_page.dart';
import '../provider/shop_join_controller.dart';

class ShopJoinView extends HookConsumerWidget {
  const ShopJoinView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(shopJoinControllerProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final inviteCodeController = useTextEditingController();

    ref.listen<ShopJoinState>(shopJoinControllerProvider, (previous, next) {
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
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) {
        ref.read(shopJoinControllerProvider.notifier).showValidationError();
        return;
      }

      await ref
          .read(shopJoinControllerProvider.notifier)
          .joinShop(inviteCodeController.text);
    }

    return Scaffold(
      body: SafeArea(
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
                        title: '매장 코드 입력',
                        subtitle: '알바로 시작하려면 사장님에게 받은 초대 코드를 입력하세요.',
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF364FC7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.qr_code_2_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                '매장 코드를 입력하면 해당 매장에 합류 요청을 보냅니다. 승인 후 알바 화면을 사용할 수 있습니다.',
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
                        controller: inviteCodeController,
                        labelText: '매장 코드',
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '매장 코드를 입력해주세요.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => submit(),
                      ),
                      const SizedBox(height: 24),
                      AppPrimaryButton(
                        onPressed: state.isSubmitting ? null : submit,
                        isLoading: state.isSubmitting,
                        label: '매장 합류 요청',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
