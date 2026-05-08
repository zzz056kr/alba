import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../page/mypage_page.dart';
import '../page/shop_create_page.dart';
import '../page/shop_join_page.dart';
import '../provider/app_providers.dart';
import '../provider/auth_session_controller.dart';

class AppShellView extends ConsumerWidget {
  const AppShellView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSession = ref.watch(authSessionControllerProvider);
    final myShops = ref.watch(myShopsProvider);
    final session = authSession.valueOrNull;

    if (session == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    Future<void> logout() async {
      await ref.read(authSessionControllerProvider.notifier).logout();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F0EA),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WORKSPACE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.8,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1F6F78),
              ),
            ),
            Text(
              '안녕하세요, ${session.userId}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout_rounded),
              tooltip: '로그아웃',
            ),
          ),
        ],
      ),
      body: myShops.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ShellList(
          children: [
            _ErrorCard(message: '$error'),
            const SizedBox(height: 16),
            _BottomActions(
              onMyPage: () => context.push(MyPagePage.routePath),
              onLogout: logout,
            ),
          ],
        ),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyShopView(
              onCreateShop: () => context.push(ShopCreatePage.routePath),
              onJoinShop: () => context.push(ShopJoinPage.routePath),
              onMyPage: () => context.push(MyPagePage.routePath),
              onLogout: logout,
            );
          }

          final selectedShopId = ref.watch(selectedShopIdProvider);
          final effectiveShopId =
              selectedShopId ?? (items.length == 1 ? items.first.shop.no : null);

          if (effectiveShopId == null) {
            return _ShopSelectionView(
              items: items,
              onSelect: (shopId) {
                ref.read(selectedShopIdProvider.notifier).state = shopId;
              },
              onMyPage: () => context.push(MyPagePage.routePath),
              onLogout: logout,
            );
          }

          final detail = ref.watch(shopDetailProvider(effectiveShopId));
          final membership = items.firstWhere(
            (item) => item.shop.no == effectiveShopId,
            orElse: () => items.first,
          );

          return _ShopDetailView(
            membership: membership,
            detail: detail,
            showBackToList: items.length > 1,
            onBackToList: () {
              ref.read(selectedShopIdProvider.notifier).state = null;
            },
            onMyPage: () => context.push(MyPagePage.routePath),
            onLogout: logout,
          );
        },
      ),
    );
  }
}

class _ShellList extends StatelessWidget {
  const _ShellList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: children,
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor = Colors.white,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE4E0D8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.title,
    required this.description,
    this.accent = const Color(0xFF1F6F78),
  });

  final String title;
  final String description;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, Color.lerp(accent, Colors.white, .55)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'ALBA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: .92),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      backgroundColor: const Color(0xFFFFF4F4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '매장 정보를 불러오지 못했습니다.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF8A2F2F)),
          ),
        ],
      ),
    );
  }
}

class _EmptyShopView extends StatelessWidget {
  const _EmptyShopView({
    required this.onCreateShop,
    required this.onJoinShop,
    required this.onMyPage,
    required this.onLogout,
  });

  final VoidCallback onCreateShop;
  final VoidCallback onJoinShop;
  final VoidCallback onMyPage;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _ShellList(
      children: [
        const _HeroBanner(
          title: '소속된 매장이 없습니다.',
          description: '사장으로 시작하거나 매장 코드를 입력해 합류를 요청하세요.',
          accent: Color(0xFF1F6F78),
        ),
        const SizedBox(height: 16),
        _ActionCard(
          title: '사장으로 시작',
          description: '매장을 등록하고 운영을 시작합니다.',
          buttonLabel: '매장 등록',
          icon: Icons.storefront_rounded,
          accent: const Color(0xFF1F6F78),
          onPressed: onCreateShop,
        ),
        const SizedBox(height: 12),
        _ActionCard(
          title: '알바로 시작',
          description: '사장님에게 받은 매장 코드로 합류 요청을 보냅니다.',
          buttonLabel: '매장 코드 입력',
          icon: Icons.badge_rounded,
          accent: const Color(0xFF364FC7),
          onPressed: onJoinShop,
        ),
        const SizedBox(height: 18),
        _BottomActions(onMyPage: onMyPage, onLogout: onLogout),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.icon,
    required this.accent,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final IconData icon;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF5D676B)),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopSelectionView extends StatelessWidget {
  const _ShopSelectionView({
    required this.items,
    required this.onSelect,
    required this.onMyPage,
    required this.onLogout,
  });

  final List<MyShopMembershipResponse> items;
  final ValueChanged<int> onSelect;
  final VoidCallback onMyPage;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _ShellList(
      children: [
        const _HeroBanner(
          title: '매장을 선택하세요',
          description: '여러 매장에 소속되어 있으면 먼저 현재 작업할 매장을 선택합니다.',
          accent: Color(0xFF364FC7),
        ),
        const SizedBox(height: 16),
        for (final item in items) ...[
          _Panel(
            padding: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              onTap: () => onSelect(item.shop.no),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.store_mall_directory_rounded,
                  color: Color(0xFF1F6F78),
                ),
              ),
              title: Text(item.shop.name),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('권한: ${item.shopRole} · 상태: ${item.status}'),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        _BottomActions(onMyPage: onMyPage, onLogout: onLogout),
      ],
    );
  }
}

class _ShopDetailView extends ConsumerWidget {
  const _ShopDetailView({
    required this.membership,
    required this.detail,
    required this.showBackToList,
    required this.onBackToList,
    required this.onMyPage,
    required this.onLogout,
  });

  final MyShopMembershipResponse membership;
  final AsyncValue<ShopResponse> detail;
  final bool showBackToList;
  final VoidCallback onBackToList;
  final VoidCallback onMyPage;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingMembers = membership.shopRole == 'OWNER'
        ? ref.watch(pendingShopMembersProvider(membership.shop.no))
        : null;
    final notices = ref.watch(shopNoticesProvider(membership.shop.no));

    return _ShellList(
      children: [
        if (showBackToList)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onBackToList,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('매장 목록으로'),
            ),
          ),
        _Panel(
          backgroundColor: const Color(0xFF1F6F78),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                membership.shop.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              _RoleBadge(
                label: membership.shopRole,
                backgroundColor: Colors.white.withValues(alpha: .16),
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                '소속 상태: ${membership.status}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: .9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        detail.when(
          loading: () => const _Panel(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, _) => _ErrorCard(message: '$error'),
          data: (shop) {
            final address = [
              shop.baseAddress,
              if ((shop.detailAddress ?? '').isNotEmpty) shop.detailAddress!,
            ].join(' ');

            return Column(
              children: [
                _Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '매장 정보',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _InfoRow(label: '매장명', value: shop.name),
                      const SizedBox(height: 10),
                      _InfoRow(label: '우편번호', value: shop.zipCode),
                      const SizedBox(height: 10),
                      _InfoRow(label: '주소', value: address),
                      const SizedBox(height: 10),
                      _InfoRow(label: '상태', value: shop.status),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _OperationCard(
                  inviteCode: shop.inviteCode,
                  qrCodeValue: shop.qrCodeValue,
                ),
                const SizedBox(height: 12),
                _NoticesCard(
                  shopId: membership.shop.no,
                  isOwner: membership.shopRole == 'OWNER',
                  notices: notices,
                ),
                if (pendingMembers != null) ...[
                  const SizedBox(height: 12),
                  _PendingMembersCard(
                    membership: membership,
                    pendingMembers: pendingMembers,
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        _BottomActions(onMyPage: onMyPage, onLogout: onLogout),
      ],
    );
  }
}

class _NoticesCard extends ConsumerStatefulWidget {
  const _NoticesCard({
    required this.shopId,
    required this.isOwner,
    required this.notices,
  });

  final int shopId;
  final bool isOwner;
  final AsyncValue<List<ShopNoticeResponse>> notices;

  @override
  ConsumerState<_NoticesCard> createState() => _NoticesCardState();
}

class _NoticesCardState extends ConsumerState<_NoticesCard> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _pinned = false;
  bool _isSubmitting = false;
  bool _showComposer = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createNotice() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('공지 제목과 내용을 입력해주세요.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(shopServiceProvider)
          .createShopNotice(
            widget.shopId,
            CreateShopNoticeRequest(
              title: title,
              content: content,
              pinnedYn: _pinned ? 'Y' : 'N',
            ),
          );
      ref.invalidate(shopNoticesProvider(widget.shopId));
      if (!mounted) {
        return;
      }
      setState(() {
        _titleController.clear();
        _contentController.clear();
        _pinned = false;
        _showComposer = false;
      });
    } on DioException catch (error) {
      String message = '공지사항 등록에 실패했습니다.';
      final data = error.response?.data;
      if (data is Map) {
        final responseMessage = data['message'];
        final errorMessage = data['error'];
        if (responseMessage is String && responseMessage.isNotEmpty) {
          message = responseMessage;
        } else if (errorMessage is String && errorMessage.isNotEmpty) {
          message = errorMessage;
        }
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '공지사항',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (widget.isOwner)
                OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          setState(() {
                            _showComposer = !_showComposer;
                          });
                        },
                  child: Text(_showComposer ? '닫기' : '공지 작성'),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (_showComposer && widget.isOwner) ...[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '공지 제목'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '공지 내용',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _pinned,
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          setState(() {
                            _pinned = value ?? false;
                          });
                        },
                ),
                const Text('상단 고정'),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F6F78),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isSubmitting ? null : _createNotice,
                child: Text(_isSubmitting ? '등록 중...' : '공지 등록'),
              ),
            ),
            const SizedBox(height: 16),
          ],
          widget.notices.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('$error'),
            data: (items) {
              if (items.isEmpty) {
                return Text(
                  '등록된 공지사항이 없습니다.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B787D)),
                );
              }

              return Column(
                children: [
                  for (final item in items) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: item.isPinned
                            ? const Color(0xFFF8FBFF)
                            : const Color(0xFFFCFBF8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: item.isPinned
                              ? const Color(0xFFDCE7F6)
                              : const Color(0xFFE7E1D7),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (item.isPinned) ...[
                                const _RoleBadge(
                                  label: '고정',
                                  backgroundColor: Color(0xFFE6F0FF),
                                  foregroundColor: Color(0xFF2F5BBA),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.content,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(height: 1.5),
                          ),
                          if ((item.createdAt ?? '').isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              item.createdAt!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: const Color(0xFF7A878C)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (item != items.last) const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OperationCard extends StatelessWidget {
  const _OperationCard({
    required this.inviteCode,
    required this.qrCodeValue,
  });

  final String inviteCode;
  final String qrCodeValue;

  @override
  Widget build(BuildContext context) {
    Future<void> copyInviteCode() async {
      await Clipboard.setData(ClipboardData(text: inviteCode));
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('초대 코드를 복사했습니다.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }

    return _Panel(
      backgroundColor: const Color(0xFFF4F7FB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '운영 정보',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '초대 코드',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF637076),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inviteCode,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: copyInviteCode,
                child: const Text('복사'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE3E7EC)),
              ),
              child: QrImageView(
                data: qrCodeValue,
                version: QrVersions.auto,
                size: 180,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingMembersCard extends ConsumerStatefulWidget {
  const _PendingMembersCard({
    required this.membership,
    required this.pendingMembers,
  });

  final MyShopMembershipResponse membership;
  final AsyncValue<List<ShopMemberSummaryResponse>> pendingMembers;

  @override
  ConsumerState<_PendingMembersCard> createState() => _PendingMembersCardState();
}

class _PendingMembersCardState extends ConsumerState<_PendingMembersCard> {
  int? _editingMemberId;
  int? _submittingMemberId;
  late final TextEditingController _wageController;

  @override
  void initState() {
    super.initState();
    _wageController = TextEditingController();
  }

  @override
  void dispose() {
    _wageController.dispose();
    super.dispose();
  }

  Future<void> _approve(ShopMemberSummaryResponse member) async {
    final wage = int.tryParse(_wageController.text.trim());
    if (wage == null || wage < 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('유효한 시급을 입력해주세요.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    setState(() {
      _submittingMemberId = member.no;
    });

    try {
      await ref
          .read(shopServiceProvider)
          .approveShopMember(
            widget.membership.shop.no,
            member.no,
            ShopMemberApproveRequest(baseWage: wage),
          );
      ref.invalidate(pendingShopMembersProvider(widget.membership.shop.no));
      if (!mounted) {
        return;
      }
      setState(() {
        _editingMemberId = null;
        _submittingMemberId = null;
        _wageController.clear();
      });
    } on DioException catch (error) {
      String message = '직원 승인에 실패했습니다.';
      final data = error.response?.data;
      if (data is Map) {
        final responseMessage = data['message'];
        final errorMessage = data['error'];
        if (responseMessage is String && responseMessage.isNotEmpty) {
          message = responseMessage;
        } else if (errorMessage is String && errorMessage.isNotEmpty) {
          message = errorMessage;
        }
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      setState(() {
        _submittingMemberId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Panel(
      backgroundColor: const Color(0xFFFFFBF2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '승인 대기 직원',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          widget.pendingMembers.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('$error'),
            data: (items) {
              if (items.isEmpty) {
                return const Text('승인 대기 중인 직원이 없습니다.');
              }

              return Column(
                children: [
                  for (final item in items) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF0E4BF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _RoleBadge(
                                label: item.employmentType,
                                backgroundColor: const Color(0xFFF8F1DA),
                                foregroundColor: const Color(0xFF7B5D16),
                              ),
                              const SizedBox(width: 8),
                              Text(item.status),
                            ],
                          ),
                          if (_editingMemberId == item.no) ...[
                            const SizedBox(height: 12),
                            TextField(
                              controller: _wageController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: '기본 시급',
                                hintText: '예: 10030',
                              ),
                              onSubmitted: (_) => _approve(item),
                            ),
                          ],
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1F6F78),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _submittingMemberId == null
                                  ? () {
                                      if (_editingMemberId == item.no) {
                                        _approve(item);
                                      } else {
                                        setState(() {
                                          _editingMemberId = item.no;
                                          _wageController.clear();
                                        });
                                      }
                                    }
                                  : null,
                              child: Text(
                                _submittingMemberId == item.no
                                    ? '승인 중...'
                                    : _editingMemberId == item.no
                                    ? '승인 확정'
                                    : '승인',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item != items.last) const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onMyPage,
    required this.onLogout,
  });

  final VoidCallback onMyPage;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F6F78),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onMyPage,
            child: const Text('마이페이지'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onLogout,
            child: const Text('로그아웃'),
          ),
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B787D)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
