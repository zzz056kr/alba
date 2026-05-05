import 'package:api_client/api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.redirectBaseUrl,
    required this.dataSource,
  });

  final String apiBaseUrl;
  final String redirectBaseUrl;
  final DataSourceType dataSource;

  factory AppConfig.fromEnv() {
    String requireEnv(String key) {
      final value = dotenv.env[key]?.trim();
      if (value == null || value.isEmpty) {
        if (key == 'DATA_SOURCE' &&
            (dotenv.env['AUTH_DATA_SOURCE']?.trim().isNotEmpty ?? false)) {
          throw StateError(
            'DATA_SOURCE is required. Rename legacy AUTH_DATA_SOURCE to DATA_SOURCE.',
          );
        }
        throw StateError('$key is required.');
      }
      return value;
    }

    final rawDataSource = requireEnv('DATA_SOURCE').toLowerCase();
    final dataSource = switch (rawDataSource) {
      'server' => DataSourceType.server,
      'mock' => DataSourceType.mock,
      _ => throw StateError('DATA_SOURCE must be one of: server, mock.'),
    };

    return AppConfig(
      apiBaseUrl: requireEnv('API_BASE_URL'),
      redirectBaseUrl: requireEnv('OAUTH_REDIRECT_BASE_URL'),
      dataSource: dataSource,
    );
  }
}
