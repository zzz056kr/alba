# customer_app

Base Flutter application for the mobile workspace.

This app is intentionally kept as a reference implementation for:

- environment loading via `flutter_dotenv`
- Riverpod provider wiring
- `api_client` mock/server switching
- `design_system` usage
- multi-platform Flutter project layout

## Recreate

```bash
cd mobile-monorepo
flutter create --org com.example apps/customer_app
```

## Route Layering

`customer_app` keeps both `page/` and `view/` layers on purpose.

- `page/`: route path, route arguments, future route-level hooks
- `view/`: actual widget tree and interaction logic

In a one-off small app this split can be flattened, but in the base app it is
kept so downstream apps have a clear place to add route-level concerns without
rewriting every screen boundary.

## App Identity Checklist

When cloning this base app into a new product, update all of the following:

1. Package metadata
   - `pubspec.yaml`: app `name`, `description`

2. Android
   - `android/app/build.gradle.kts`: `namespace`, `applicationId`
   - `android/app/src/main/AndroidManifest.xml`: `android:label`

3. iOS
   - `ios/Runner.xcodeproj/project.pbxproj`: `PRODUCT_BUNDLE_IDENTIFIER`
   - `ios/Runner/Info.plist`: display name, URL type name

4. macOS
   - `macos/Runner/Configs/AppInfo.xcconfig`: `PRODUCT_BUNDLE_IDENTIFIER`, copyright
   - `macos/Runner.xcodeproj/project.pbxproj`: test bundle identifiers

5. Web
   - `web/manifest.json`: `name`, `short_name`, `description`
   - `web/index.html`: title, meta description, Apple web app title

6. Desktop metadata
   - `linux/CMakeLists.txt`: `APPLICATION_ID`
   - `windows/runner/Runner.rc`: company name, product name, copyright

7. OAuth / deep links
   - `.env`: `OAUTH_REDIRECT_BASE_URL`
   - platform callback metadata if the scheme changes

8. Release distribution
   - Android release signing config
   - iOS signing / provisioning
