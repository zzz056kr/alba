import '../model/dto/token_dto.dart';

bool isTokenExpired(
  TokenResponse? token,
  DateTime? issuedAt,
) {
  if (token == null || issuedAt == null || token.accessTokenExpiresIn <= 0) {
    return true;
  }

  final expirationTime = issuedAt.add(
    Duration(seconds: token.accessTokenExpiresIn),
  );
  return !DateTime.now().isBefore(expirationTime);
}

bool isTokenExpiringSoon(
  TokenResponse? token,
  DateTime? issuedAt, {
  int minutesBuffer = 5,
}) {
  if (token == null || issuedAt == null || token.accessTokenExpiresIn <= 0) {
    return true;
  }

  final expirationTime = issuedAt.add(
    Duration(seconds: token.accessTokenExpiresIn),
  );
  final bufferTime = Duration(minutes: minutesBuffer);
  return !DateTime.now().isBefore(expirationTime.subtract(bufferTime));
}
