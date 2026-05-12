DateTime? _parseLocalDate(Object? value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}

class CreateScheduleRequest {
  const CreateScheduleRequest({
    required this.shopMemberId,
    required this.workDate,
    required this.startTime,
    required this.endTime,
    this.repeatUntil,
    this.repeatDaysOfWeek,
  });

  final int shopMemberId;
  final DateTime workDate;
  final String startTime;
  final String endTime;
  final DateTime? repeatUntil;
  final List<String>? repeatDaysOfWeek;

  Map<String, dynamic> toJson() {
    String formatDate(DateTime date) {
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '${date.year}-$month-$day';
    }

    return {
      'shopMemberId': shopMemberId,
      'workDate': formatDate(workDate),
      'startTime': startTime,
      'endTime': endTime,
      'repeatUntil': repeatUntil == null ? null : formatDate(repeatUntil!),
      'repeatDaysOfWeek': repeatDaysOfWeek,
    };
  }
}

class EditScheduleRequest {
  const EditScheduleRequest({
    required this.workDate,
    required this.startTime,
    required this.endTime,
    required this.scope,
  });

  final DateTime workDate;
  final String startTime;
  final String endTime;
  final String scope;

  Map<String, dynamic> toJson() {
    String formatDate(DateTime date) {
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '${date.year}-$month-$day';
    }

    return {
      'workDate': formatDate(workDate),
      'startTime': startTime,
      'endTime': endTime,
      'scope': scope,
    };
  }
}

class ScheduleShopMemberResponse {
  const ScheduleShopMemberResponse({
    required this.no,
    required this.name,
    required this.shopRole,
    required this.status,
  });

  final int no;
  final String name;
  final String shopRole;
  final String status;

  factory ScheduleShopMemberResponse.fromJson(Object? value) {
    final json = value is Map<String, dynamic>
        ? value
        : const <String, dynamic>{};
    return ScheduleShopMemberResponse(
      no: (json['no'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      shopRole: json['shopRole'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class ScheduleSummaryResponse {
  const ScheduleSummaryResponse({
    required this.no,
    required this.shopMember,
    required this.workDate,
    required this.startTime,
    required this.endTime,
    required this.repeatGroupKey,
    required this.status,
  });

  final int no;
  final ScheduleShopMemberResponse? shopMember;
  final DateTime? workDate;
  final String startTime;
  final String endTime;
  final String? repeatGroupKey;
  final String status;

  factory ScheduleSummaryResponse.fromJson(Object? value) {
    final json = value is Map<String, dynamic>
        ? value
        : const <String, dynamic>{};
    return ScheduleSummaryResponse(
      no: (json['no'] as num?)?.toInt() ?? 0,
      shopMember: json['shopMember'] == null
          ? null
          : ScheduleShopMemberResponse.fromJson(json['shopMember']),
      workDate: _parseLocalDate(json['workDate']),
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      repeatGroupKey: json['repeatGroupKey'] as String?,
      status: json['status'] as String? ?? '',
    );
  }
}

class ScheduleSearchResponse {
  const ScheduleSearchResponse({
    required this.viewType,
    required this.baseDate,
    required this.startDate,
    required this.endDate,
    required this.schedules,
  });

  final String viewType;
  final DateTime? baseDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ScheduleSummaryResponse> schedules;

  factory ScheduleSearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final schedules = data['schedules'] is List
        ? data['schedules'] as List
        : const <dynamic>[];
    return ScheduleSearchResponse(
      viewType: data['viewType'] as String? ?? '',
      baseDate: _parseLocalDate(data['baseDate']),
      startDate: _parseLocalDate(data['startDate']),
      endDate: _parseLocalDate(data['endDate']),
      schedules: schedules.map(ScheduleSummaryResponse.fromJson).toList(),
    );
  }
}

class CreateScheduleResponse {
  const CreateScheduleResponse({required this.schedules});

  final List<ScheduleSummaryResponse> schedules;

  factory CreateScheduleResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final schedules = data['schedules'] is List
        ? data['schedules'] as List
        : const <dynamic>[];
    return CreateScheduleResponse(
      schedules: schedules.map(ScheduleSummaryResponse.fromJson).toList(),
    );
  }
}
