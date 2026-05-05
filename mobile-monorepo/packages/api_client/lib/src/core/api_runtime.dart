enum DataSourceType { server, mock }

class ApiRuntime {
  const ApiRuntime({
    required this.dataSource,
    required this.baseUrl,
    this.showError,
  });

  final DataSourceType dataSource;
  final String baseUrl;
  final void Function(String message)? showError;

  bool get isMock => dataSource == DataSourceType.mock;
}
