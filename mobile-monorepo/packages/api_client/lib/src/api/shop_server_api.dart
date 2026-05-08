import 'package:common/common.dart';
import 'package:dio/dio.dart';

import '../core/api_request_options.dart';
import 'shop_api.dart';

class ShopServerApi implements ShopApi {
  const ShopServerApi(this._dio);

  final Dio _dio;

  @override
  Future<ResponseModel<ShopMemberPageResponse>> getShopMembers(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/shop/$shopId/members',
      queryParameters: queryParameters,
      options: options?.toDioOptions(),
    );

    return ResponseModel<ShopMemberPageResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => PageListResponse<ShopMemberSummaryResponse>.fromJson(
        value is Map<String, dynamic> ? value : const <String, dynamic>{},
        ShopMemberSummaryResponse.fromJson,
      ),
    );
  }

  @override
  Future<ResponseModel<JoinShopResponse>> approveShopMember(
    int shopId,
    int shopMemberId,
    ShopMemberApproveRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/shop/$shopId/members/$shopMemberId/approve',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<JoinShopResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => JoinShopResponse.fromJson(
        value is Map<String, dynamic>
            ? <String, dynamic>{'data': value}
            : const <String, dynamic>{},
      ),
    );
  }

  @override
  Future<ResponseModel<JoinShopResponse>> joinShop(
    JoinShopRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/shop-member',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<JoinShopResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => JoinShopResponse.fromJson(
        value is Map<String, dynamic>
            ? <String, dynamic>{'data': value}
            : const <String, dynamic>{},
      ),
    );
  }

  @override
  Future<ResponseModel<List<ShopNoticeResponse>>> getShopNotices(
    int shopId, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/shop/$shopId/notices',
      options: options?.toDioOptions(),
    );

    return ResponseModel<List<ShopNoticeResponse>>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) {
        final list = value is List ? value : const <dynamic>[];
        return list.map(ShopNoticeResponse.fromJson).toList();
      },
    );
  }

  @override
  Future<ResponseModel<ShopNoticeResponse>> createShopNotice(
    int shopId,
    CreateShopNoticeRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/shop/$shopId/notices',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<ShopNoticeResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => ShopNoticeResponse.fromJson(value),
    );
  }

  @override
  Future<ResponseModel<List<MyShopMembershipResponse>>> getMyShops({
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/shop/my',
      options: options?.toDioOptions(),
    );

    return ResponseModel<List<MyShopMembershipResponse>>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) {
        final list = value is List ? value : const <dynamic>[];
        return list
            .whereType<Map<String, dynamic>>()
            .map(MyShopMembershipResponse.fromJson)
            .toList();
      },
    );
  }

  @override
  Future<ResponseModel<ShopResponse>> getShop(
    int shopId, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/shop/$shopId',
      options: options?.toDioOptions(),
    );

    return ResponseModel<ShopResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => ShopResponse.fromJson(
        value is Map<String, dynamic>
            ? <String, dynamic>{'data': value}
            : const <String, dynamic>{},
      ),
    );
  }

  @override
  Future<ResponseModel<ShopResponse>> createShop(
    CreateShopRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/shop',
      data: request.toJson(),
      options: options?.toDioOptions(),
    );

    return ResponseModel<ShopResponse>.fromJson(
      response.data ?? const <String, dynamic>{},
      (value) => ShopResponse.fromJson(
        value is Map<String, dynamic>
            ? <String, dynamic>{'data': value}
            : const <String, dynamic>{},
      ),
    );
  }
}
