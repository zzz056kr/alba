import 'package:common/common.dart';

import '../api/shop_api.dart';
import '../api/shop_server_api.dart';
import '../core/api_request_options.dart';
import '../core/api_runtime.dart';
import '../core/http.dart';
import '../mock/shop_mock.dart';

class ShopService {
  ShopService({
    required ApiRuntime runtime,
    ApiHttpClient? httpClient,
    ShopApi? mockApi,
  }) : _runtime = runtime,
       _serverApi = ShopServerApi(
         (httpClient ?? ApiHttpClient.create(runtime)).dio,
       ),
       _mockApi = mockApi ?? MockShopApi();

  final ApiRuntime _runtime;
  final ShopApi _serverApi;
  final ShopApi _mockApi;

  ShopApi get _api => _runtime.isMock ? _mockApi : _serverApi;

  T _requireData<T>(ResponseModel<T> response) {
    final data = response.data;
    if (data == null) {
      throw StateError(response.message ?? 'Response data is missing.');
    }
    return data;
  }

  Future<JoinShopResponse> joinShop(
    JoinShopRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.joinShop(request, options: options);
    return _requireData(response);
  }

  Future<CreateScheduleResponse> createSchedules(
    int shopId,
    CreateScheduleRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.createSchedules(
      shopId,
      request,
      options: options,
    );
    return _requireData(response);
  }

  Future<AttendanceSummaryResponse> clockInByQr(
    int shopId,
    AttendanceQrRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.clockInByQr(shopId, request, options: options);
    return _requireData(response);
  }

  Future<AttendanceSummaryResponse> clockOutByQr(
    int shopId,
    AttendanceQrRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.clockOutByQr(shopId, request, options: options);
    return _requireData(response);
  }

  Future<AttendancePageResponse> getAttendances(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _api.getAttendances(
      shopId,
      options: options,
      queryParameters: queryParameters,
    );
    return _requireData(response);
  }

  Future<List<ShopNoticeResponse>> getShopNotices(
    int shopId, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.getShopNotices(shopId, options: options);
    return _requireData(response);
  }

  Future<ShopNoticeResponse> createShopNotice(
    int shopId,
    CreateShopNoticeRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.createShopNotice(
      shopId,
      request,
      options: options,
    );
    return _requireData(response);
  }

  Future<ShopMemberPageResponse> getShopMembers(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _api.getShopMembers(
      shopId,
      options: options,
      queryParameters: queryParameters,
    );
    return _requireData(response);
  }

  Future<JoinShopResponse> approveShopMember(
    int shopId,
    int shopMemberId,
    ShopMemberApproveRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.approveShopMember(
      shopId,
      shopMemberId,
      request,
      options: options,
    );
    return _requireData(response);
  }

  Future<List<MyShopMembershipResponse>> getMyShops({
    ApiRequestOptions? options,
  }) async {
    final response = await _api.getMyShops(options: options);
    return _requireData(response);
  }

  Future<ShopResponse> getShop(int shopId, {ApiRequestOptions? options}) async {
    final response = await _api.getShop(shopId, options: options);
    return _requireData(response);
  }

  Future<ScheduleSearchResponse> getSchedules(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _api.getSchedules(
      shopId,
      options: options,
      queryParameters: queryParameters,
    );
    return _requireData(response);
  }

  Future<void> cancelSchedule(
    int shopId,
    int scheduleId, {
    ApiRequestOptions? options,
  }) async {
    await _api.cancelSchedule(shopId, scheduleId, options: options);
  }

  Future<ScheduleSummaryResponse> editSchedule(
    int shopId,
    int scheduleId,
    EditScheduleRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.editSchedule(
      shopId,
      scheduleId,
      request,
      options: options,
    );
    return _requireData(response);
  }

  Future<ShopResponse> createShop(
    CreateShopRequest request, {
    ApiRequestOptions? options,
  }) async {
    final response = await _api.createShop(request, options: options);
    return _requireData(response);
  }
}
