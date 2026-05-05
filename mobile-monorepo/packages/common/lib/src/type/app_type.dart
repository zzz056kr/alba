import 'package:json_annotation/json_annotation.dart';

enum OAuthProvider {
  google,
  kakao,
  naver,
}

enum SortType {
  @JsonValue('ASC')
  asc,
  @JsonValue('DESC')
  desc,
}

extension SortTypeValue on SortType {
  String get value => switch (this) {
        SortType.asc => 'ASC',
        SortType.desc => 'DESC',
      };
}
