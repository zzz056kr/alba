# api_client conventions

This package mirrors the structure of `frontend-monorepo/packages/api-client`.
Every domain (`auth`, `account`, `dashboard`, `chat`, …) MUST follow the four-file
layout below so the `DATA_SOURCE` environment variable can flip the entire app
between real backend and mocks at runtime.

## Layered structure

```
packages/api_client/lib/src/
├── core/
│   ├── api_runtime.dart           # ApiRuntime { dataSource, baseUrl, showError }
│   ├── api_request_options.dart   # ApiRequestOptions { showErrorPopup, ... }
│   └── http.dart                  # ApiHttpClient.create(runtime) — Dio instance + interceptors
├── api/                           # Abstract contracts + REAL server implementations
│   ├── <domain>_api.dart          # abstract class <Domain>Api
│   └── <domain>_server_api.dart   # class <Domain>ServerApi implements <Domain>Api
├── mock/                          # MOCK implementations of the same contracts
│   └── <domain>_mock.dart         # class Mock<Domain>Api implements <Domain>Api
└── service/                       # Public façade — picks server vs. mock at runtime
    └── <domain>_service.dart      # class <Domain>Service { _api getter switches via _runtime.isMock }
```

## Adding a new domain — checklist

Suppose you need an `account` domain.

### 1. Define the contract — `api/account_api.dart`

```dart
import 'package:common/common.dart';
import '../core/api_request_options.dart';

abstract class AccountApi {
  Future<ResponseModel<AccountDetail>> me({ApiRequestOptions? options});
  Future<ResponseModel<void>> updateProfile(
    UpdateProfileRequest request, {
    ApiRequestOptions? options,
  });
}
```

### 2. Implement the server side — `api/account_server_api.dart`

```dart
class AccountServerApi implements AccountApi {
  const AccountServerApi(this._dio);
  final Dio _dio;

  @override
  Future<ResponseModel<AccountDetail>> me({ApiRequestOptions? options}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/account/me',
      options: options?.toDioOptions(),
    );
    return ResponseModel.fromJson(
      response.data ?? const {},
      (v) => AccountDetail.fromJson(v as Map<String, dynamic>),
    );
  }
  // ...
}
```

### 3. Implement the mock — `mock/account_mock.dart`

```dart
class MockAccountApi implements AccountApi {
  @override
  Future<ResponseModel<AccountDetail>> me({ApiRequestOptions? options}) {
    return mockResponse(
      ResponseModel<AccountDetail>(
        code: 'SUCCESS',
        message: 'ok',
        data: AccountDetail(/* fixtures */),
      ),
    );
  }
  // ...
}
```

### 4. Build the façade service — `service/account_service.dart`

Use a `_api` getter so each method stays one line. **Do not** repeat
`_runtime.isMock ? mock : server` inside every method.

```dart
class AccountService {
  AccountService({
    required ApiRuntime runtime,
    ApiHttpClient? httpClient,
    AccountApi? mockApi,
  })  : _runtime = runtime,
        _serverApi = AccountServerApi(
          (httpClient ?? ApiHttpClient.create(runtime)).dio,
        ),
        _mockApi = mockApi ?? MockAccountApi();

  final ApiRuntime _runtime;
  final AccountApi _serverApi;
  final AccountApi _mockApi;

  AccountApi get _api => _runtime.isMock ? _mockApi : _serverApi;

  Future<AccountDetail> me({ApiRequestOptions? options}) async {
    final response = await _api.me(options: options);
    final data = response.data;
    if (data == null) {
      throw StateError(response.message ?? 'Response data is missing.');
    }
    return data;
  }
}
```

### 5. Export from the barrel — `lib/api_client.dart`

```dart
export 'src/api/account_api.dart';
export 'src/service/account_service.dart';
```

DO NOT export `*_server_api.dart` or `*_mock.dart` — those are internal.

### 6. Wire a Riverpod provider — `apps/customer_app/lib/src/provider/app_providers.dart`

```dart
final accountServiceProvider = Provider<AccountService>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  final feedbackService = ref.watch(appFeedbackServiceProvider);
  return AccountService(
    runtime: ApiRuntime(
      dataSource: appConfig.dataSource,
      baseUrl: appConfig.apiBaseUrl,
      showError: feedbackService.showError,
    ),
  );
});
```

If multiple services start sharing the same `ApiRuntime`, extract a
`apiRuntimeProvider` and have each `*ServiceFactory` consume it.

## Environment variables

`apps/customer_app/assets/config/.env.example`:

```
API_BASE_URL=http://localhost:8080
DATA_SOURCE=server                      # 'server' | 'mock' — global switch
OAUTH_REDIRECT_BASE_URL=customerapp://auth
```

| Variable | Purpose | Mirror on web |
|----------|---------|---------------|
| `API_BASE_URL`             | Backend root for all `*_server_api.dart` | `NEXT_PUBLIC_API_BASE_URL` |
| `DATA_SOURCE`              | Selects mock vs. server for ALL domains  | `NEXT_PUBLIC_DATA_SOURCE`  |
| `OAUTH_REDIRECT_BASE_URL`  | Deep-link callback for social login      | `NEXT_PUBLIC_CLIENT_BASE_URL` (web equivalent) |

`AppConfig.fromEnv()` reads `DATA_SOURCE` once at app start and stores it on
`ApiRuntime`. Every service inherits it. There is **no per-domain override** —
that was the old `AUTH_DATA_SOURCE` shape and it is gone.

## Anti-patterns

- ❌ Calling `Dio` directly from app code — always go through a `*Service`.
- ❌ Branching on `_runtime.isMock` outside `service/*_service.dart`.
- ❌ Reading `dotenv.env[...]` outside `app_config.dart`.
- ❌ Per-domain env vars (e.g. `AUTH_DATA_SOURCE`, `ACCOUNT_DATA_SOURCE`).
- ❌ Exporting `*_server_api.dart` or `*_mock.dart` from the barrel.
