import 'package:flutter/material.dart';

class FormCheckboxField extends StatelessWidget {
  const FormCheckboxField({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (next) => onChanged(next ?? false),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
