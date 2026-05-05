# design_system

Shared Flutter UI package for apps in `mobile-monorepo`.

## Purpose

This package is the default home for reusable presentation-layer code:

- buttons, chips, cards, headers, loading widgets
- form primitives and form-specific widgets
- UI-only composition helpers

If a widget is not tied to one app's business flow and can be reused across
multiple mobile apps, it should usually live here.

## Public Surface

Import from the package barrel only:

```dart
import 'package:design_system/design_system.dart';
```

Current exports include:

- layout primitives such as `AppHeader`, `AppSurfaceCard`, `AuthScaffold`
- action widgets such as `AppPrimaryButton`, `AppSecondaryButton`
- form primitives such as `AppFormField`, `FormTextField`, `FormPasswordField`
- form helpers such as `AccountSchema`, `ReadOnlyField`

App code should not reach into `lib/src/...` directly.

## What Belongs Here

Put code here when all of the following are true:

- it is primarily presentation/UI code
- it does not depend on app-specific business state
- another app could reuse it with the same meaning

Examples:

- shared auth form layout
- standardized input widgets
- common button and feedback components

## What Does Not Belong Here

Do not put these here:

- API calls or networking
- app-specific screen orchestration
- Riverpod providers tied to one app flow
- DTOs and domain response models

Those belong in `api_client`, `common`, or the app itself depending on scope.

## Split Rule

Do not create a new UI package too early.

Use `design_system` until at least one of these becomes true:

- the package needs an independent release/version policy
- a subset of UI code has a distinct ownership boundary
- the package starts depending on a different platform/runtime concern

Until then, keeping reusable UI in one place is usually easier to maintain in a
base source.
