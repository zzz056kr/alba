import 'package:common/common.dart';

import '../api/shop_api.dart';
import '../core/api_request_options.dart';
import 'mock_utils.dart';

class MockShopApi implements ShopApi {
  static final List<ShopResponse> _shops = <ShopResponse>[];
  static final Map<int, List<ShopNoticeResponse>> _shopNotices =
      <int, List<ShopNoticeResponse>>{};
  static final Map<int, List<AttendanceSummaryResponse>> _attendances =
      <int, List<AttendanceSummaryResponse>>{};
  static final Map<int, List<_MockScheduleRecord>> _schedules =
      <int, List<_MockScheduleRecord>>{};

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
  Future<ResponseModel<CreateScheduleResponse>> createSchedules(
    int shopId,
    CreateScheduleRequest request, {
    ApiRequestOptions? options,
  }) {
    final baseDate = request.workDate;
    final repeatDays = request.repeatDaysOfWeek ?? const <String>[];
    final createdSchedules = <ScheduleSummaryResponse>[];
    final scheduleStore = _schedules.putIfAbsent(
      shopId,
      () => <_MockScheduleRecord>[],
    );
    void addSchedule(DateTime workDate) {
      final schedule = ScheduleSummaryResponse(
        no: DateTime.now().microsecondsSinceEpoch + createdSchedules.length,
        shopMember: ScheduleShopMemberResponse(
          no: request.shopMemberId,
          name: '직원 ${request.shopMemberId}',
          shopRole: 'STAFF',
          status: 'ACTIVE',
        ),
        workDate: workDate,
        startTime: request.startTime,
        endTime: request.endTime,
        repeatGroupKey:
            request.repeatUntil != null &&
                (request.repeatDaysOfWeek?.isNotEmpty ?? false)
            ? 'repeat-${baseDate.microsecondsSinceEpoch}-${request.shopMemberId}'
            : null,
        status: 'SCHEDULED',
      );
      createdSchedules.add(schedule);
      scheduleStore.add(
        _MockScheduleRecord(
          shopMemberId: request.shopMemberId,
          schedule: schedule,
        ),
      );
    }

    addSchedule(baseDate);
    if (request.repeatUntil != null && repeatDays.isNotEmpty) {
      var cursor = baseDate.add(const Duration(days: 1));
      while (!cursor.isAfter(request.repeatUntil!)) {
        final weekdayName = [
          'MONDAY',
          'TUESDAY',
          'WEDNESDAY',
          'THURSDAY',
          'FRIDAY',
          'SATURDAY',
          'SUNDAY',
        ][cursor.weekday - 1];
        if (repeatDays.contains(weekdayName)) {
          addSchedule(cursor);
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }
    return mockResponse(
      ResponseModel<CreateScheduleResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: CreateScheduleResponse(schedules: createdSchedules),
      ),
    );
  }

  @override
  Future<ResponseModel<AttendanceSummaryResponse>> clockInByQr(
    int shopId,
    AttendanceQrRequest request, {
    ApiRequestOptions? options,
  }) {
    final now = DateTime.now();
    final attendance = AttendanceSummaryResponse(
      no: now.millisecondsSinceEpoch,
      schedule: ScheduleSummaryResponse(
        no: 1,
        shopMember: const ScheduleShopMemberResponse(
          no: 1,
          name: 'mock-staff',
          shopRole: 'STAFF',
          status: 'ACTIVE',
        ),
        workDate: DateTime(now.year, now.month, now.day),
        startTime: '09:00:00',
        endTime: '18:00:00',
        repeatGroupKey: null,
        status: 'SCHEDULED',
      ),
      workDate: DateTime(now.year, now.month, now.day),
      clockInAt: now,
      clockOutAt: null,
      baseWage: 11000,
      workedMinutes: null,
      estimatedPay: null,
    );
    final attendances = _attendances.putIfAbsent(
      shopId,
      () => <AttendanceSummaryResponse>[],
    );
    attendances.insert(0, attendance);
    return mockResponse(
      ResponseModel<AttendanceSummaryResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: attendance,
      ),
    );
  }

  @override
  Future<ResponseModel<AttendanceSummaryResponse>> clockOutByQr(
    int shopId,
    AttendanceQrRequest request, {
    ApiRequestOptions? options,
  }) {
    final attendances = _attendances.putIfAbsent(
      shopId,
      () => <AttendanceSummaryResponse>[],
    );
    final openAttendance = attendances
        .cast<AttendanceSummaryResponse?>()
        .firstWhere((item) => item?.isWorking ?? false, orElse: () => null);
    final clockOutAt = DateTime.now();
    final clockInAt =
        openAttendance?.clockInAt ??
        clockOutAt.subtract(const Duration(hours: 4));
    final baseWage = openAttendance?.baseWage ?? 11000;
    final workedMinutes = clockOutAt.difference(clockInAt).inMinutes;
    final closedAttendance = AttendanceSummaryResponse(
      no: openAttendance?.no ?? clockOutAt.millisecondsSinceEpoch,
      schedule: openAttendance?.schedule,
      workDate: openAttendance?.workDate ?? DateTime.now(),
      clockInAt: clockInAt,
      clockOutAt: clockOutAt,
      baseWage: baseWage,
      workedMinutes: workedMinutes,
      estimatedPay: (baseWage * workedMinutes / 60).round(),
    );
    if (openAttendance != null) {
      attendances.removeWhere((item) => item.no == openAttendance.no);
    }
    attendances.insert(0, closedAttendance);
    return mockResponse(
      ResponseModel<AttendanceSummaryResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: closedAttendance,
      ),
    );
  }

  @override
  Future<ResponseModel<AttendancePageResponse>> getAttendances(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  }) {
    final list = _attendances[shopId] ?? const <AttendanceSummaryResponse>[];
    return mockResponse(
      ResponseModel<AttendancePageResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: AttendancePageResponse(
          total: list.length,
          pages: 1,
          page: 1,
          list: list,
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
    final notices = _shopNotices.putIfAbsent(
      shopId,
      () => <ShopNoticeResponse>[],
    );
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
  Future<ResponseModel<ScheduleSearchResponse>> getSchedules(
    int shopId, {
    ApiRequestOptions? options,
    Map<String, dynamic>? queryParameters,
  }) {
    final rawShopMemberId = queryParameters?['shopMemberId'];
    final shopMemberId = rawShopMemberId is num
        ? rawShopMemberId.toInt()
        : int.tryParse('$rawShopMemberId');
    final rawBaseDate = queryParameters?['baseDate']?.toString();
    final baseDate = rawBaseDate == null || rawBaseDate.isEmpty
        ? DateTime.now()
        : DateTime.tryParse(rawBaseDate) ?? DateTime.now();
    final monthStart = DateTime(baseDate.year, baseDate.month, 1);
    final monthEnd = DateTime(baseDate.year, baseDate.month + 1, 0);
    final schedules =
        (_schedules[shopId] ?? const <_MockScheduleRecord>[])
            .where(
              (record) =>
                  (shopMemberId == null ||
                      record.shopMemberId == shopMemberId) &&
                  !(record.schedule.workDate?.isBefore(monthStart) ?? true) &&
                  !(record.schedule.workDate?.isAfter(monthEnd) ?? true),
            )
            .map((record) => record.schedule)
            .toList()
          ..sort((left, right) {
            final leftDate = left.workDate ?? monthStart;
            final rightDate = right.workDate ?? monthStart;
            final dateCompare = leftDate.compareTo(rightDate);
            if (dateCompare != 0) {
              return dateCompare;
            }
            return left.startTime.compareTo(right.startTime);
          });
    return mockResponse(
      ResponseModel<ScheduleSearchResponse>(
        code: 'SUCCESS',
        message: 'ok',
        data: ScheduleSearchResponse(
          viewType: 'MONTH',
          baseDate: baseDate,
          startDate: monthStart,
          endDate: monthEnd,
          schedules: schedules,
        ),
      ),
    );
  }

  @override
  Future<ResponseModel<void>> cancelSchedule(
    int shopId,
    int scheduleId, {
    ApiRequestOptions? options,
  }) {
    final schedules = _schedules[shopId];
    schedules?.removeWhere((item) => item.schedule.no == scheduleId);
    return mockResponse(
      const ResponseModel<void>(code: 'SUCCESS', message: 'ok'),
    );
  }

  @override
  Future<ResponseModel<ScheduleSummaryResponse>> editSchedule(
    int shopId,
    int scheduleId,
    EditScheduleRequest request, {
    ApiRequestOptions? options,
  }) {
    final schedules = _schedules[shopId] ?? <_MockScheduleRecord>[];
    final index = schedules.indexWhere(
      (item) => item.schedule.no == scheduleId,
    );
    if (index < 0) {
      return mockResponse(
        const ResponseModel<ScheduleSummaryResponse>(
          code: 'NOT_FOUND',
          message: '찾을 수 없음',
          data: null,
        ),
      );
    }

    final target = schedules[index];
    final hasOverlap = schedules.any(
      (item) =>
          item.schedule.no != scheduleId &&
          item.shopMemberId == target.shopMemberId &&
          item.schedule.status == 'SCHEDULED' &&
          item.schedule.workDate?.year == request.workDate.year &&
          item.schedule.workDate?.month == request.workDate.month &&
          item.schedule.workDate?.day == request.workDate.day &&
          _isTimeOverlapping(
            startTime: request.startTime,
            endTime: request.endTime,
            otherStartTime: item.schedule.startTime,
            otherEndTime: item.schedule.endTime,
          ),
    );
    if (hasOverlap) {
      return mockResponse(
        const ResponseModel<ScheduleSummaryResponse>(
          code: 'CONFLICT',
          message: '해당 직원은 같은 날짜에 겹치는 근무 일정이 이미 있습니다',
          data: null,
        ),
      );
    }

    final scope = request.scope;
    if (scope == 'THIS_ONLY' ||
        (target.schedule.repeatGroupKey ?? '').isEmpty) {
      schedules[index] = _MockScheduleRecord(
        shopMemberId: target.shopMemberId,
        schedule: ScheduleSummaryResponse(
          no: target.schedule.no,
          shopMember: target.schedule.shopMember,
          workDate: target.schedule.workDate,
          startTime: target.schedule.startTime,
          endTime: target.schedule.endTime,
          repeatGroupKey: target.schedule.repeatGroupKey,
          status: 'CANCELED',
        ),
      );
      final replacement = ScheduleSummaryResponse(
        no: DateTime.now().microsecondsSinceEpoch,
        shopMember: target.schedule.shopMember,
        workDate: request.workDate,
        startTime: request.startTime,
        endTime: request.endTime,
        repeatGroupKey: null,
        status: 'SCHEDULED',
      );
      schedules.add(
        _MockScheduleRecord(
          shopMemberId: target.shopMemberId,
          schedule: replacement,
        ),
      );
      return mockResponse(
        ResponseModel<ScheduleSummaryResponse>(
          code: 'SUCCESS',
          message: 'ok',
          data: replacement,
        ),
      );
    } else {
      final replacementRepeatGroupKey = scope == 'ALL'
          ? target.schedule.repeatGroupKey
          : 'repeat-${DateTime.now().microsecondsSinceEpoch}-${target.shopMemberId}';
      ScheduleSummaryResponse? replacement;
      for (var i = 0; i < schedules.length; i++) {
        final item = schedules[i];
        final sameGroup =
            item.schedule.repeatGroupKey == target.schedule.repeatGroupKey;
        final inScope =
            scope == 'ALL' ||
            !(item.schedule.workDate?.isBefore(target.schedule.workDate!) ??
                true);
        if (!sameGroup || !inScope) {
          continue;
        }
        schedules[i] = _MockScheduleRecord(
          shopMemberId: item.shopMemberId,
          schedule: ScheduleSummaryResponse(
            no: item.schedule.no,
            shopMember: item.schedule.shopMember,
            workDate: item.schedule.workDate,
            startTime: item.schedule.startTime,
            endTime: item.schedule.endTime,
            repeatGroupKey: item.schedule.repeatGroupKey,
            status: 'CANCELED',
          ),
        );
        final created = ScheduleSummaryResponse(
          no: DateTime.now().microsecondsSinceEpoch + i,
          shopMember: item.schedule.shopMember,
          workDate: item.schedule.workDate,
          startTime: request.startTime,
          endTime: request.endTime,
          repeatGroupKey: replacementRepeatGroupKey,
          status: 'SCHEDULED',
        );
        replacement ??= created;
        schedules.add(
          _MockScheduleRecord(
            shopMemberId: item.shopMemberId,
            schedule: created,
          ),
        );
      }
      return mockResponse(
        ResponseModel<ScheduleSummaryResponse>(
          code: 'SUCCESS',
          message: 'ok',
          data: replacement,
        ),
      );
    }
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

bool _isTimeOverlapping({
  required String startTime,
  required String endTime,
  required String otherStartTime,
  required String otherEndTime,
}) {
  int parseMinutes(String value) {
    final parts = value.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  final currentStartMinutes = parseMinutes(startTime);
  final currentEndMinutes = parseMinutes(endTime);
  final otherStartMinutes = parseMinutes(otherStartTime);
  final otherEndMinutes = parseMinutes(otherEndTime);
  return currentStartMinutes < otherEndMinutes &&
      currentEndMinutes > otherStartMinutes;
}

class _MockScheduleRecord {
  const _MockScheduleRecord({
    required this.shopMemberId,
    required this.schedule,
  });

  final int shopMemberId;
  final ScheduleSummaryResponse schedule;
}
