import '../page_list_dto.dart';

class ShopMemberSummaryResponse {
  const ShopMemberSummaryResponse({
    required this.no,
    required this.name,
    required this.shopRole,
    required this.baseWage,
    required this.isAppUser,
    required this.employmentType,
    required this.status,
  });

  final int no;
  final String name;
  final String shopRole;
  final int? baseWage;
  final bool isAppUser;
  final String employmentType;
  final String status;

  factory ShopMemberSummaryResponse.fromJson(Object? value) {
    final json = value is Map<String, dynamic>
        ? value
        : const <String, dynamic>{};
    return ShopMemberSummaryResponse(
      no: (json['no'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      shopRole: json['shopRole'] as String? ?? '',
      baseWage: (json['baseWage'] as num?)?.toInt(),
      isAppUser: json['isAppUser'] as bool? ?? false,
      employmentType: json['employmentType'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class ShopMemberApproveRequest {
  const ShopMemberApproveRequest({required this.baseWage});

  final int baseWage;

  Map<String, dynamic> toJson() {
    return {'baseWage': baseWage};
  }
}

typedef ShopMemberPageResponse = PageListResponse<ShopMemberSummaryResponse>;
