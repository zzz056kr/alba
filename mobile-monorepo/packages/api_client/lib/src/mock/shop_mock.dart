import 'package:common/common.dart';

import '../api/shop_api.dart';
import '../core/api_request_options.dart';
import 'mock_utils.dart';

class MockShopApi implements ShopApi {
  static final List<ShopResponse> _shops = <ShopResponse>[];
  static final Map<int, List<ShopNoticeResponse>> _shopNotices =
      <int, List<ShopNoticeResponse>>{};

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
  Future<ResponseModel<List<ShopNoticeResponse>>> getShopNotices(
    int shopId, {
    ApiRequestOptions? options,
  }) {
    final notices = _shopNotices[shopId] ?? const <ShopNoticeResponse>[];
    return mockResponse(
      ResponseModel<List<ShopNoticeResponse>>(
        code: 'SUCCESS',
        message: 'ok',
        data: notices,
      ),
    );
  }

  @override
  Future<ResponseModel<ShopNoticeResponse>> createShopNotice(
    int shopId,
    CreateShopNoticeRequest request, {
    ApiRequestOptions? options,
  }) {
    final notice = ShopNoticeResponse(
      no: DateTime.now().millisecondsSinceEpoch,
      shopNo: shopId,
      title: request.title,
      content: request.content,
      pinnedYn: request.pinnedYn,
      status: 'ACTIVE',
      createdAt: DateTime.now().toIso8601String(),
    );
    final notices = _shopNotices.putIfAbsent(shopId, () => <ShopNoticeResponse>[]);
    if (request.pinnedYn == 'Y') {
      notices.insert(0, notice);
    } else {
      notices.add(notice);
    }
    return mockResponse(
      ResponseModel<ShopNoticeResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: notice,
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
    _shopNotices.putIfAbsent(
      shop.no,
      () => <ShopNoticeResponse>[
        const ShopNoticeResponse(
          no: 1,
          shopNo: 1,
          title: '첫 공지',
          content: '출근 전 공지사항을 꼭 확인해주세요.',
          pinnedYn: 'Y',
          status: 'ACTIVE',
        ),
      ],
    );

    return mockResponse(
      ResponseModel<ShopResponse>(code: 'SUCCESS', message: 'ok', data: shop),
    );
  }
}
