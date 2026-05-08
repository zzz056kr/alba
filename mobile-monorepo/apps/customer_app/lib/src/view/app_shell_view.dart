import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

import '../page/mypage_page.dart';
import '../page/shop_create_page.dart';
import '../page/shop_join_page.dart';
import '../provider/auth_session_controller.dart';

class AppShellView extends ConsumerWidget {
  const AppShellView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authSession = ref.watch(authSessionControllerProvider);
    final session = authSession.valueOrNull;
    if (session == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: '안녕하세요, ${session.userId}',
                subtitle: '처음 시작이라면 현재 하려는 일에 맞춰 사장 또는 알바 흐름을 먼저 선택하세요.',
                actionLabel: '로그아웃',
                onActionPressed: () {
                  ref.read(authSessionControllerProvider.notifier).logout();
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: AppSurfaceCard(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 720;
                      final ownerCard = _EntryOptionCard(
                        title: '사장으로 시작',
                        description:
                            '매장을 등록하고 직원, 스케줄, 출결을 관리하는 흐름으로 진입합니다.',
                        accentColor: const Color(0xFF1F6F78),
                        icon: Icons.storefront_rounded,
                        primaryLabel: '매장 등록',
                        onPrimaryPressed: () {
                          context.push(ShopCreatePage.routePath);
                        },
                      );
                      final staffCard = _EntryOptionCard(
                        title: '알바로 시작',
                        description:
                            '사장님에게 받은 매장 코드를 입력하고 합류 요청을 보내는 흐름입니다.',
                        accentColor: const Color(0xFF364FC7),
                        icon: Icons.badge_rounded,
                        primaryLabel: '매장 코드 입력',
                        onPrimaryPressed: () {
                          context.push(ShopJoinPage.routePath);
                        },
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '어떻게 시작할까요?',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '소속 매장이 아직 없다면 먼저 현재 목적을 선택하세요. 이후에는 매장 소속과 역할에 따라 화면을 분기하면 됩니다.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF6E7A7E),
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: ownerCard),
                                const SizedBox(width: 16),
                                Expanded(child: staffCard),
                              ],
                            )
                          else
                            Column(
                              children: [
                                ownerCard,
                                const SizedBox(height: 16),
                                staffCard,
                              ],
                            ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                AppPrimaryButton(
                                  onPressed: () {
                                    context.push(MyPagePage.routePath);
                                  },
                                  label: '마이페이지',
                                ),
                                const SizedBox(height: 12),
                                AppSecondaryButton(
                                  onPressed: () {
                                    ref.read(
                                      authSessionControllerProvider.notifier,
                                    ).logout();
                                  },
                                  label: '로그아웃',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryOptionCard extends StatelessWidget {
  const _EntryOptionCard({
    required this.title,
    required this.description,
    required this.accentColor,
    required this.icon,
    required this.primaryLabel,
    required this.onPrimaryPressed,
  });

  final String title;
  final String description;
  final Color accentColor;
  final IconData icon;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF607076),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              onPressed: onPrimaryPressed,
              label: primaryLabel,
            ),
          ],
        ),
      ),
    );
  }
}
