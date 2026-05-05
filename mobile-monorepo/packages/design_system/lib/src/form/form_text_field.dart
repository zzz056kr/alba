import 'package:flutter/material.dart';

import 'app_form_field.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return AppFormField(
      controller: controller,
      labelText: labelText,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
    );
  }
}
