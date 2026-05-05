import 'package:api_client/api_client.dart';
import 'package:customer_app/src/common/app_config.dart';
import 'package:customer_app/src/provider/app_providers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('builds AppConfig and ApiRuntime from environment', () async {
    await dotenv.load(
      fileName: 'assets/config/.env',
      mergeWith: {
        'API_BASE_URL': 'http://localhost:8080',
        'DATA_SOURCE': 'mock',
        'OAUTH_REDIRECT_BASE_URL': 'customerapp://auth',
      },
    );

    final appConfig = AppConfig.fromEnv();
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final runtime = container.read(apiRuntimeProvider);

    expect(appConfig.apiBaseUrl, 'http://localhost:8080');
    expect(appConfig.redirectBaseUrl, 'customerapp://auth');
    expect(appConfig.dataSource, DataSourceType.mock);
    expect(runtime.baseUrl, 'http://localhost:8080');
    expect(runtime.dataSource, DataSourceType.mock);
    expect(runtime.isMock, isTrue);
  });
}
