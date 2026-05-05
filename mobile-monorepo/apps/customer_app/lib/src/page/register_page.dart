import 'package:flutter/material.dart';

import '../view/register_view.dart';

class RegisterPage extends StatelessWidget {
  static const routePath = '/register';

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterView();
  }
}
