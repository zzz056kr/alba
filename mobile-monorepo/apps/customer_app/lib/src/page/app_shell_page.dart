import 'package:flutter/material.dart';

import '../view/app_shell_view.dart';

class AppShellPage extends StatelessWidget {
  static const routePath = '/';

  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShellView();
  }
}
