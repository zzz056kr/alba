import 'package:flutter/material.dart';

import '../view/shop_schedule_create_view.dart';

class ShopScheduleCreatePage extends StatelessWidget {
  static const routePath = '/shop/schedule/create';

  const ShopScheduleCreatePage({
    super.key,
    required this.shopId,
    this.initialScheduleId,
    this.initialShopMemberId,
    this.initialWorkDate,
    this.initialStartTime,
    this.initialEndTime,
    this.initialRepeatGroupKey,
  });

  final int shopId;
  final int? initialScheduleId;
  final int? initialShopMemberId;
  final DateTime? initialWorkDate;
  final String? initialStartTime;
  final String? initialEndTime;
  final String? initialRepeatGroupKey;

  @override
  Widget build(BuildContext context) {
    return ShopScheduleCreateView(
      shopId: shopId,
      initialScheduleId: initialScheduleId,
      initialShopMemberId: initialShopMemberId,
      initialWorkDate: initialWorkDate,
      initialStartTime: initialStartTime,
      initialEndTime: initialEndTime,
      initialRepeatGroupKey: initialRepeatGroupKey,
    );
  }
}
