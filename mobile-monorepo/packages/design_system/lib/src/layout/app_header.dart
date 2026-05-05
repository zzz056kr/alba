import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BASE',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF1F6F78),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 10),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF5E6A6E),
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onActionPressed != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: OutlinedButton(
              onPressed: onActionPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(actionLabel!),
            ),
          ),
      ],
    );
  }
}
