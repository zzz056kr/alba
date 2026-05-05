import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/form/register_form_value.dart';
import '../page/login_page.dart';
import '../provider/register_controller.dart';

class RegisterView extends HookConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerControllerProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final idController = useTextEditingController();
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (previous?.message?.text == next.message?.text ||
          next.message == null) {
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

      if (next.isSuccess) {
        context.go(LoginPage.routePath);
      }
    });

    Future<void> register() async {
      FocusScope.of(context).unfocus();

      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) {
        ref.read(registerControllerProvider.notifier).showValidationError();
        return;
      }

      await ref
          .read(registerControllerProvider.notifier)
          .register(
            RegisterFormValue(
              id: idController.text,
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
            ),
          );
    }

    return AuthScaffold(
      title: '회원가입',
      subtitle: '새 계정을 만들고 바로 로그인할 수 있습니다.',
      child: Form(
        key: formKey,
        autovalidateMode: state.showValidation
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormTextField(
              controller: idController,
              labelText: '아이디',
              textInputAction: TextInputAction.next,
              validator: AccountSchema.registerId,
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: nameController,
              labelText: '이름',
              textInputAction: TextInputAction.next,
              validator: AccountSchema.registerName,
            ),
            const SizedBox(height: 12),
            FormEmailField(
              controller: emailController,
              labelText: '이메일',
              textInputAction: TextInputAction.next,
              validator: AccountSchema.registerEmail,
            ),
            const SizedBox(height: 12),
            FormPasswordField(
              controller: passwordController,
              labelText: '비밀번호',
              textInputAction: TextInputAction.next,
              validator: AccountSchema.registerPassword,
            ),
            const SizedBox(height: 12),
            FormPasswordField(
              controller: confirmPasswordController,
              labelText: '비밀번호 확인',
              textInputAction: TextInputAction.done,
              validator: AccountSchema.confirmPassword(passwordController.text),
              onFieldSubmitted: (_) => state.isSubmitting ? null : register(),
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              onPressed: state.isSubmitting ? null : register,
              isLoading: state.isSubmitting,
              label: '회원가입',
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.go(LoginPage.routePath);
              },
              child: const Text('이미 계정이 있으신가요? 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
