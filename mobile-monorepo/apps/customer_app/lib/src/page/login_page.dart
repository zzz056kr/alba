import 'package:flutter/material.dart';

import '../view/login_view.dart';

class LoginPage extends StatelessWidget {
  static const routePath = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}
