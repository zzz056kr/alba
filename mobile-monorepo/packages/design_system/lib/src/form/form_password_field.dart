import 'package:flutter/material.dart';

import 'app_form_field.dart';

class FormPasswordField extends StatelessWidget {
  const FormPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return AppFormField(
      controller: controller,
      labelText: labelText,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: true,
    );
  }
}
