# api_client

Shared API access package for Flutter apps in `mobile-monorepo`.

## Purpose

This package is the app-facing boundary for backend communication.

It provides:

- API contracts in `api/`
- runtime-aware service facades in `service/`
- mock implementations in `mock/`
- Dio setup and auth interception in `core/`
- OAuth-related models and auth token abstractions

The main rule is simple: app code should talk to services, not directly to Dio.

## Public Surface

Import only through:

```dart
import 'package:api_client/api_client.dart';
```

The barrel intentionally exports:

- contracts such as `AuthApi`, `EmailApi`
- services such as `AuthService`, `EmailService`
- runtime/config types such as `ApiRuntime`, `ApiRequestOptions`
- token/auth integration helpers needed by the app layer

It intentionally does **not** export:

- `*_server_api.dart`
- `*_mock.dart`

Those remain internal implementation details.

## App Usage Rule

Application code should:

- read environment once in app config
- build `ApiRuntime` once in providers
- inject services through Riverpod
- call service methods from providers/controllers

Application code should not:

- instantiate raw Dio clients inside screens
- branch on mock/server outside the service layer
- read `dotenv.env[...]` inside API code

## Adding a New Domain

Follow the four-file domain pattern documented in:

- [`CONVENTIONS.md`](./CONVENTIONS.md)

At minimum, a new domain should add:

- `api/<domain>_api.dart`
- `api/<domain>_server_api.dart`
- `mock/<domain>_mock.dart`
- `service/<domain>_service.dart`

## Split Rule

Do not create a separate `auth_client`, `email_client`, or `network` package
unless there is a strong boundary reason.

Keep domains inside `api_client` until one of these becomes true:

- a domain must be reused outside mobile in a separately versioned package
- ownership or release cadence is materially different
- a lower-level transport package is needed independently of app-facing services
