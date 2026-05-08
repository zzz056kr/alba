class ShopCreateFormValue {
  const ShopCreateFormValue({
    required this.name,
    required this.zipCode,
    required this.baseAddress,
    required this.detailAddress,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String zipCode;
  final String baseAddress;
  final String detailAddress;
  final double? latitude;
  final double? longitude;
}
