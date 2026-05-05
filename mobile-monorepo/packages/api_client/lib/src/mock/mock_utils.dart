Future<T> mockResponse<T>(
  T data, {
  Duration delay = const Duration(milliseconds: 300),
}) async {
  await Future<void>.delayed(delay);
  return data;
}
