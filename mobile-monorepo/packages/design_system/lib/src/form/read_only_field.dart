import 'package:flutter/material.dart';

class ReadOnlyField extends StatelessWidget {
  const ReadOnlyField({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        InputDecorator(decoration: const InputDecoration(), child: Text(value)),
      ],
    );
  }
}
