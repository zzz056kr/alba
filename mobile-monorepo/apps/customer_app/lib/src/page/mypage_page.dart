import 'package:flutter/material.dart';

import '../view/mypage_view.dart';

class MyPagePage extends StatelessWidget {
  static const routePath = '/mypage';

  const MyPagePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return MyPageView(userId: userId);
  }
}
