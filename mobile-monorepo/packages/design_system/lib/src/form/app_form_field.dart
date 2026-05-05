import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: labelText),
    );
  }
}
