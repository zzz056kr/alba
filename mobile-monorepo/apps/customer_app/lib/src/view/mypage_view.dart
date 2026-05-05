import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(
                title: '마이페이지',
                subtitle: '로그인된 사용자 정보와 개인 설정 진입점을 여기에 배치할 수 있습니다.',
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
                          '내 정보',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const ReadOnlyField(label: '상태', value: '로그인됨'),
                        const SizedBox(height: 12),
                        ReadOnlyField(label: '사용자 아이디', value: userId),
                        const SizedBox(height: 24),
                        const Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            AppChip(label: '계정 설정'),
                            AppChip(label: '알림 설정'),
                            AppChip(label: '보안'),
                            AppChip(label: '고객지원'),
                          ],
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
