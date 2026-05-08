import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_dto.freezed.dart';

@freezed
class TokenResponse with _$TokenResponse {
  const factory TokenResponse({
    required String accessToken,
    required int accessTokenExpiresIn,
    required String refreshToken,
    required int refreshTokenExpiresIn,
    required String userId,
    required String email,
    required List<String> roles,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final account = data['account'] is Map<String, dynamic>
        ? data['account'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return TokenResponse(
      accessToken: data['accessToken'] as String? ?? '',
      accessTokenExpiresIn: data['accessTokenExpiresIn'] as int? ?? 0,
      refreshToken: data['refreshToken'] as String? ?? '',
      refreshTokenExpiresIn: data['refreshTokenExpiresIn'] as int? ?? 0,
      userId: account['id'] as String? ?? '',
      email: account['email'] as String? ?? '',
      roles: (data['roles'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>()
          .toList(),
    );
  }
}
