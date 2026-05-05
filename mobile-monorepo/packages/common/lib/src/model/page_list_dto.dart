import 'package:freezed_annotation/freezed_annotation.dart';

import '../type/app_type.dart';

part 'page_list_dto.freezed.dart';
part 'page_list_dto.g.dart';

@freezed
class PageListRequest with _$PageListRequest {
  @JsonSerializable(includeIfNull: false)
  const factory PageListRequest({
    int? page,
    int? size,
    String? order,
    SortType? direction,
    bool? formUseYn,
  }) = _PageListRequest;

  factory PageListRequest.fromJson(Map<String, dynamic> json) =>
      _$PageListRequestFromJson(json);
}

class PageListResponse<T> {
  const PageListResponse({
    this.total,
    this.pages,
    this.page,
    this.list,
  });

  final int? total;
  final int? pages;
  final int? page;
  final List<T>? list;

  factory PageListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? value) fromJsonT,
  ) {
    final rawList = json['list'] is List ? json['list'] as List : const [];
    return PageListResponse(
      total: json['total'] as int?,
      pages: json['pages'] as int?,
      page: json['page'] as int?,
      list: rawList.map(fromJsonT).toList(),
    );
  }
}