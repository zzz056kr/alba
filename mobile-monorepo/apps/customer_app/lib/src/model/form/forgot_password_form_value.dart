import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_form_value.freezed.dart';

@freezed
class ForgotPasswordFormValue with _$ForgotPasswordFormValue {
  const factory ForgotPasswordFormValue({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) = _ForgotPasswordFormValue;
}
