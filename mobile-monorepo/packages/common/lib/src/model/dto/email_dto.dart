import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_dto.freezed.dart';
part 'email_dto.g.dart';

@freezed
class SendAuthCodeRequest with _$SendAuthCodeRequest {
  const factory SendAuthCodeRequest({
    required String email,
    required String type,
  }) = _SendAuthCodeRequest;

  factory SendAuthCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendAuthCodeRequestFromJson(json);
}

@freezed
class VerifyEmailRequest with _$VerifyEmailRequest {
  const factory VerifyEmailRequest({
    required String email,
    required String code,
    required String type,
  }) = _VerifyEmailRequest;

  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailRequestFromJson(json);
}