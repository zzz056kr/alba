import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_value.freezed.dart';

@freezed
class LoginFormValue with _$LoginFormValue {
  const factory LoginFormValue({required String id, required String password}) =
      _LoginFormValue;
}
