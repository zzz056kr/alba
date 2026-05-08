import 'package:flutter/widgets.dart';

import '../view/email_verification_view.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  static const routePath = '/verify-email';

  @override
  Widget build(BuildContext context) {
    return const EmailVerificationView();
  }
}
