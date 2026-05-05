import 'package:flutter/material.dart';

import '../view/forgot_password_view.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const routePath = '/forgot-password';

  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ForgotPasswordView();
  }
}
