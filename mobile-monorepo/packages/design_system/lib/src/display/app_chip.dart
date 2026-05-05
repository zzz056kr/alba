import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3F2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF1F6F78),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
