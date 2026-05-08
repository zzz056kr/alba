import 'dart:convert';

class AddressSearchResult {
  const AddressSearchResult({
    required this.zipCode,
    required this.address1,
    required this.roadAddress,
    required this.jibunAddress,
    required this.extraAddress,
  });

  final String zipCode;
  final String address1;
  final String roadAddress;
  final String jibunAddress;
  final String extraAddress;

  factory AddressSearchResult.fromJsonString(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return AddressSearchResult(
      zipCode: json['zipCode'] as String? ?? '',
      address1: json['address1'] as String? ?? '',
      roadAddress: json['roadAddress'] as String? ?? '',
      jibunAddress: json['jibunAddress'] as String? ?? '',
      extraAddress: json['extraAddress'] as String? ?? '',
    );
  }
}
