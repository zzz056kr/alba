class CreateShopRequest {
  const CreateShopRequest({
    required this.name,
    required this.zipCode,
    required this.baseAddress,
    this.detailAddress,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String zipCode;
  final String baseAddress;
  final String? detailAddress;
  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'zipCode': zipCode,
      'baseAddress': baseAddress,
      'detailAddress': detailAddress,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class ShopResponse {
  const ShopResponse({
    required this.no,
    required this.name,
    required this.zipCode,
    required this.baseAddress,
    this.detailAddress,
    required this.inviteCode,
    required this.qrCodeValue,
    this.latitude,
    this.longitude,
    required this.status,
  });

  final int no;
  final String name;
  final String zipCode;
  final String baseAddress;
  final String? detailAddress;
  final String inviteCode;
  final String qrCodeValue;
  final double? latitude;
  final double? longitude;
  final String status;

  factory ShopResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ShopResponse(
      no: (data['no'] as num?)?.toInt() ?? 0,
      name: data['name'] as String? ?? '',
      zipCode: data['zipCode'] as String? ?? '',
      baseAddress: data['baseAddress'] as String? ?? '',
      detailAddress: data['detailAddress'] as String?,
      inviteCode: data['inviteCode'] as String? ?? '',
      qrCodeValue: data['qrCodeValue'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      status: data['status'] as String? ?? '',
    );
  }
}

class ShopAbbrResponse {
  const ShopAbbrResponse({
    required this.no,
    required this.name,
    required this.status,
  });

  final int no;
  final String name;
  final String status;

  factory ShopAbbrResponse.fromJson(Map<String, dynamic> json) {
    return ShopAbbrResponse(
      no: (json['no'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class MyShopMembershipResponse {
  const MyShopMembershipResponse({
    required this.no,
    required this.shop,
    required this.name,
    required this.shopRole,
    required this.status,
  });

  final int no;
  final ShopAbbrResponse shop;
  final String name;
  final String shopRole;
  final String status;

  factory MyShopMembershipResponse.fromJson(Map<String, dynamic> json) {
    return MyShopMembershipResponse(
      no: (json['no'] as num?)?.toInt() ?? 0,
      shop: ShopAbbrResponse.fromJson(
        json['shop'] is Map<String, dynamic>
            ? json['shop'] as Map<String, dynamic>
            : const <String, dynamic>{},
      ),
      name: json['name'] as String? ?? '',
      shopRole: json['shopRole'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}
