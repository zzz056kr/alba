class CreateShopNoticeRequest {
  const CreateShopNoticeRequest({
    required this.title,
    required this.content,
    this.pinnedYn = 'N',
  });

  final String title;
  final String content;
  final String pinnedYn;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'pinnedYn': pinnedYn,
    };
  }
}

class ShopNoticeResponse {
  const ShopNoticeResponse({
    required this.no,
    required this.shopNo,
    required this.title,
    required this.content,
    required this.pinnedYn,
    required this.status,
    this.createdAt,
  });

  final int no;
  final int shopNo;
  final String title;
  final String content;
  final String pinnedYn;
  final String status;
  final String? createdAt;

  bool get isPinned => pinnedYn == 'Y';

  factory ShopNoticeResponse.fromJson(Object? value) {
    final json = value is Map<String, dynamic>
        ? value
        : const <String, dynamic>{};
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ShopNoticeResponse(
      no: (data['no'] as num?)?.toInt() ?? 0,
      shopNo: (data['shopNo'] as num?)?.toInt() ?? 0,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      pinnedYn: data['pinnedYn'] as String? ?? 'N',
      status: data['status'] as String? ?? '',
      createdAt: data['createdAt'] as String?,
    );
  }
}
