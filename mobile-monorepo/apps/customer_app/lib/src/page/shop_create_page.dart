import 'package:flutter/material.dart';

import '../view/shop_create_view.dart';

class ShopCreatePage extends StatelessWidget {
  static const routePath = '/shop/create';

  const ShopCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShopCreateView();
  }
}
