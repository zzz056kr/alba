import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_form_value.freezed.dart';

@freezed
class RegisterFormValue with _$RegisterFormValue {
  const factory RegisterFormValue({
    required String id,
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) = _RegisterFormValue;
}
