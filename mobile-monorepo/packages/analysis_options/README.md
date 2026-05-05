# analysis_options

Shared static-analysis presets for the `mobile_monorepo` workspace
(equivalent role to `@repo/eslint-config` in `frontend-monorepo`).

## Presets

| File | Use it from | Based on |
|------|-------------|----------|
| `lib/base.yaml`        | Pure Dart packages (no Flutter)             | `package:lints/recommended.yaml` |
| `lib/package.yaml`     | Flutter library packages (`design_system`, future shared UI libs, …) | `package:flutter_lints/flutter.yaml` |
| `lib/flutter_app.yaml` | Flutter applications (`customer_app`, …)    | `package:flutter_lints/flutter.yaml` + stricter rules |

## Usage

In the consumer package's `pubspec.yaml`:

```yaml
dev_dependencies:
  analysis_options:
    path: ../analysis_options    # adjust depth from packages/* or apps/*
```

In the consumer package's `analysis_options.yaml`:

```yaml
include: package:analysis_options/package.yaml
```
