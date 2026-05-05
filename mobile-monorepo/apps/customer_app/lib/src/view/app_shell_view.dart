import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

import '../page/mypage_page.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: '안녕하세요, ${session.userId}',
                subtitle: '지금 로그인된 상태입니다. 메인 화면에서 서비스를 이어갈 수 있습니다.',
                actionLabel: '로그아웃',
                onActionPressed: () {
                  ref.read(authSessionControllerProvider.notifier).logout();
                },
              ),
              const SizedBox(height: 28),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Home',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '로그인 상태를 전역으로 유지하고 있으며, 여기서 로그아웃도 바로 처리할 수 있습니다.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6E7A7E),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            AppChip(label: '내 정보'),
                            AppChip(label: '알림'),
                            AppChip(label: '최근 활동'),
                            AppChip(label: '설정'),
                          ],
                        ),
                        const Spacer(),
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
                                  ref
                                      .read(
                                        authSessionControllerProvider.notifier,
                                      )
                                      .logout();
                                },
                                label: '로그아웃',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
