class JoinShopRequest {
  const JoinShopRequest({required this.inviteCode});

  final String inviteCode;

  Map<String, dynamic> toJson() {
    return {'inviteCode': inviteCode};
  }
}

class JoinShopResponse {
  const JoinShopResponse({
    required this.no,
    required this.name,
    required this.shopRole,
    required this.status,
  });

  final int no;
  final String name;
  final String shopRole;
  final String status;

  factory JoinShopResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return JoinShopResponse(
      no: (data['no'] as num?)?.toInt() ?? 0,
      name: data['name'] as String? ?? '',
      shopRole: data['shopRole'] as String? ?? '',
      status: data['status'] as String? ?? '',
    );
  }
}
