import 'package:common/common.dart';

import '../core/api_request_options.dart';

abstract class ShopApi {
  Future<ResponseModel<ShopMemberPageResponse>> getShopMembers(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  });

  Future<ResponseModel<JoinShopResponse>> approveShopMember(
    int shopId,
    int shopMemberId,
    ShopMemberApproveRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<JoinShopResponse>> joinShop(
    JoinShopRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<CreateScheduleResponse>> createSchedules(
    int shopId,
    CreateScheduleRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<AttendanceSummaryResponse>> clockInByQr(
    int shopId,
    AttendanceQrRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<AttendanceSummaryResponse>> clockOutByQr(
    int shopId,
    AttendanceQrRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<PageListResponse<AttendanceSummaryResponse>>>
  getAttendances(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  });

  Future<ResponseModel<List<ShopNoticeResponse>>> getShopNotices(
    int shopId, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<ShopNoticeResponse>> createShopNotice(
    int shopId,
    CreateShopNoticeRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<List<MyShopMembershipResponse>>> getMyShops({
    ApiRequestOptions? options,
  });

  Future<ResponseModel<ShopResponse>> getShop(
    int shopId, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<ScheduleSearchResponse>> getSchedules(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  });

  Future<ResponseModel<void>> cancelSchedule(
    int shopId,
    int scheduleId, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<ScheduleSummaryResponse>> editSchedule(
    int shopId,
    int scheduleId,
    EditScheduleRequest request, {
    ApiRequestOptions? options,
  });

  Future<ResponseModel<ShopResponse>> createShop(
    CreateShopRequest request, {
    ApiRequestOptions? options,
  });
}
