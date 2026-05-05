import 'package:flutter/material.dart';

class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size = 20, this.strokeWidth = 2.2});

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    );
  }
}
