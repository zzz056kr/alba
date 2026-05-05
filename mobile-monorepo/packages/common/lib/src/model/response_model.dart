class ResponseModel<T> {
  const ResponseModel({
    this.code,
    this.message,
    this.data,
  });

  final String? code;
  final String? message;
  final T? data;

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? value)? fromJsonT,
  ) {
    return ResponseModel(
      code: json['code'] as String?,
      message: json['message'] as String?,
      data: json.containsKey('data') && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}
