import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShopJoinView extends HookWidget {
  const ShopJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final inviteCodeController = useTextEditingController();

    void submit() {
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('매장 합류 API 연결 전입니다. 화면 흐름만 먼저 구성했습니다.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
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
                                '매장 코드를 입력하면 해당 매장 합류 요청으로 이어집니다. 승인 후 알바 화면을 사용할 수 있습니다.',
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
                        onPressed: submit,
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
