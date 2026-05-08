import 'package:common/common.dart';

import '../api/shop_api.dart';
import '../core/api_request_options.dart';
import 'mock_utils.dart';

class MockShopApi implements ShopApi {
  static final List<ShopResponse> _shops = <ShopResponse>[];

  @override
  Future<ResponseModel<ShopMemberPageResponse>> getShopMembers(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  }) {
    final statuses = queryParameters?['statuses'];
    final wantsPending =
        statuses == 'PENDING' ||
        (statuses is List && statuses.contains('PENDING'));

    final list = wantsPending
        ? const <ShopMemberSummaryResponse>[
            ShopMemberSummaryResponse(
              no: 101,
              name: '대기중 알바',
              shopRole: 'STAFF',
              baseWage: null,
              isAppUser: true,
              employmentType: 'REGULAR',
              status: 'PENDING',
            ),
          ]
        : const <ShopMemberSummaryResponse>[];

    return mockResponse(
      ResponseModel<ShopMemberPageResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: PageListResponse<ShopMemberSummaryResponse>(
          total: list.length,
          pages: 1,
          page: 1,
          list: list,
        ),
      ),
    );
  }

  @override
  Future<ResponseModel<JoinShopResponse>> approveShopMember(
    int shopId,
    int shopMemberId,
    ShopMemberApproveRequest request, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      const ResponseModel<JoinShopResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: JoinShopResponse(
          no: 101,
          name: '대기중 알바',
          shopRole: 'STAFF',
          status: 'ACTIVE',
        ),
      ),
    );
  }

  @override
  Future<ResponseModel<JoinShopResponse>> joinShop(
    JoinShopRequest request, {
    ApiRequestOptions? options,
  }) {
    return mockResponse(
      const ResponseModel<JoinShopResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: JoinShopResponse(
          no: 999,
          name: 'mock-staff',
          shopRole: 'STAFF',
          status: 'PENDING',
        ),
      ),
    );
  }

  @override
  Future<ResponseModel<List<MyShopMembershipResponse>>> getMyShops({
    ApiRequestOptions? options,
  }) {
    final memberships = _shops
        .map(
          (shop) => MyShopMembershipResponse(
            no: shop.no,
            shop: ShopAbbrResponse(
              no: shop.no,
              name: shop.name,
              status: shop.status,
            ),
            name: shop.name,
            shopRole: 'OWNER',
            status: 'ACTIVE',
          ),
        )
        .toList();

    return mockResponse(
      ResponseModel<List<MyShopMembershipResponse>>(
        code: 'SUCCESS',
        message: 'ok',
        data: memberships,
      ),
    );
  }

  @override
  Future<ResponseModel<ShopResponse>> getShop(
    int shopId, {
    ApiRequestOptions? options,
  }) {
    final shop = _shops.firstWhere(
      (item) => item.no == shopId,
      orElse: () => const ShopResponse(
        no: 0,
        name: '',
        zipCode: '',
        baseAddress: '',
        inviteCode: '',
        qrCodeValue: '',
        status: '',
      ),
    );

    return mockResponse(
      ResponseModel<ShopResponse>(code: 'SUCCESS', message: 'ok', data: shop),
    );
  }

  @override
  Future<ResponseModel<ShopResponse>> createShop(
    CreateShopRequest request, {
    ApiRequestOptions? options,
  }) {
    final shop = ShopResponse(
      no: _shops.length + 1,
      name: request.name,
      zipCode: request.zipCode,
      baseAddress: request.baseAddress,
      detailAddress: request.detailAddress,
      inviteCode: 'X7A9KQ1B2C',
      qrCodeValue: '550e8400-e29b-41d4-a716-446655440000',
      latitude: request.latitude,
      longitude: request.longitude,
      status: 'ACTIVE',
    );
    _shops
      ..removeWhere((item) => item.no == shop.no)
      ..add(shop);

    return mockResponse(
      ResponseModel<ShopResponse>(code: 'SUCCESS', message: 'ok', data: shop),
    );
  }
}
