import '../page_list_dto.dart';
import 'schedule_dto.dart';

DateTime? _parseLocalDate(Object? value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}

DateTime? _parseLocalDateTime(Object? value) {
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}

class AttendanceQrRequest {
  const AttendanceQrRequest({
    required this.qrCodeValue,
    required this.latitude,
    required this.longitude,
  });

  final String qrCodeValue;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() {
    return {
      'qrCodeValue': qrCodeValue,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class AttendanceSummaryResponse {
  const AttendanceSummaryResponse({
    required this.no,
    required this.schedule,
    required this.workDate,
    required this.clockInAt,
    required this.clockOutAt,
    required this.baseWage,
    required this.workedMinutes,
    required this.estimatedPay,
  });

  final int no;
  final ScheduleSummaryResponse? schedule;
  final DateTime? workDate;
  final DateTime? clockInAt;
  final DateTime? clockOutAt;
  final int? baseWage;
  final int? workedMinutes;
  final int? estimatedPay;

  bool get isWorking => clockInAt != null && clockOutAt == null;

  factory AttendanceSummaryResponse.fromJson(Object? value) {
    final json = value is Map<String, dynamic>
        ? value
        : const <String, dynamic>{};
    final scheduleJson = json['schedule'];
    return AttendanceSummaryResponse(
      no: (json['no'] as num?)?.toInt() ?? 0,
      schedule: scheduleJson is Map<String, dynamic>
          ? ScheduleSummaryResponse.fromJson(scheduleJson)
          : null,
      workDate: _parseLocalDate(json['workDate']),
      clockInAt: _parseLocalDateTime(json['clockInAt']),
      clockOutAt: _parseLocalDateTime(json['clockOutAt']),
      baseWage: (json['baseWage'] as num?)?.toInt(),
      workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
      estimatedPay: (json['estimatedPay'] as num?)?.toInt(),
    );
  }
}

typedef AttendancePageResponse = PageListResponse<AttendanceSummaryResponse>;
