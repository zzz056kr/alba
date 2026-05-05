import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_dto.freezed.dart';
part 'account_dto.g.dart';

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String id,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class JoinRequest with _$JoinRequest {
  const factory JoinRequest({
    required String id,
    required String name,
    required String password,
    required String email,
  }) = _JoinRequest;

  factory JoinRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinRequestFromJson(json);
}

@freezed
class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String email,
    required String code,
    required String newPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}