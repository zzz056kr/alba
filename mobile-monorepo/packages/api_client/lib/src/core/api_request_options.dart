import 'package:dio/dio.dart';

class ApiRequestOptions {
  const ApiRequestOptions({this.showErrorPopup = true});

  final bool showErrorPopup;

  Options toDioOptions() {
    return Options(extra: {'showErrorPopup': showErrorPopup});
  }
}
