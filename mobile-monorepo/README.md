# mobile-monorepo

open -a Simulator
flutter run -d "iPhone 17"

Flutter 기반 모바일 앱과 공유 Dart/Flutter 패키지를 한 워크스페이스에서 관리하는 모노레포입니다.
같은 저장소의 `frontend-monorepo` (Next.js) 와 동일한 구조 철학을 따라 도메인 컨벤션이 웹/모바일 사이에서 일치하도록 설계되어 있습니다.

---

## 목차

1. [디렉토리 구조](#디렉토리-구조)
2. [의존성 방향](#의존성-방향)
3. [사전 준비](#사전-준비)
4. [최초 실행 (또는 풀 받은 직후)](#최초-실행-또는-풀-받은-직후)
5. [개발 중 자주 쓰는 명령어](#개발-중-자주-쓰는-명령어)
6. [Melos 스크립트 전체 레퍼런스](#melos-스크립트-전체-레퍼런스)
7. [코드 생성 (Freezed / json_serializable)](#코드-생성-freezed--json_serializable)
8. [앱 실행 / 빌드](#앱-실행--빌드)
9. [환경변수](#환경변수)
10. [도메인 추가 컨벤션](#도메인-추가-컨벤션)
11. [베이스 구조 원칙](#베이스-구조-원칙)
12. [주요 안티패턴](#주요-안티패턴)
13. [트러블슈팅](#트러블슈팅)

---

## 디렉토리 구조

```text
mobile-monorepo/
├── apps/
│   └── customer_app/              # Flutter 앱 (Riverpod + go_router + dio)
└── packages/
    ├── analysis_options/          # 공유 lint 프리셋 (base / package / flutter_app)
    ├── api_client/                # HTTP 레이어 (dio, 인터셉터, auth/email 도메인)
    │                              # 자세한 도메인 추가 가이드는
    │                              # packages/api_client/CONVENTIONS.md 참고
    ├── common/                    # DTO, 유틸, 상수 (Flutter 의존 없음)
    └── design_system/             # 공유 Flutter 위젯 / 테마 / 폼 컴포넌트
```

## 의존성 방향

단방향 DAG — 순환 의존 금지.

```text
customer_app
  ├── api_client ──► common
  ├── common
  └── design_system
```

### 앱 내부 레이어

`customer_app` 는 베이스 앱이므로 앱 내부 구조도 명시적으로 분리합니다.

```text
router -> page -> view -> provider/service
```

- `page/`: route path, route argument, route-level 확장 포인트
- `view/`: 실제 위젯 트리와 상호작용
- `provider/`: 상태, side effect, service wiring

현재 일부 `page/*` 는 thin wrapper 처럼 보일 수 있지만, base source 에서는
새 앱이 route-level analytics, transition, guard, loader 같은 책임을 추가할 수 있도록
이 레이어를 유지합니다.

---

## 사전 준비

1. **Flutter 설치** — Dart SDK `^3.11.5` 이상.
   ```bash
   flutter --version
   ```
2. **Melos 글로벌 설치** (워크스페이스 오케스트레이터, npm workspaces 와 같은 역할):
   ```bash
   dart pub global activate melos
   ```
3. PATH 설정 (필요 시): `~/.pub-cache/bin` 을 `PATH` 에 추가해야 `melos` 명령어 인식됨.
   ```bash
   export PATH="$PATH:$HOME/.pub-cache/bin"
   ```

---

## 최초 실행 (또는 풀 받은 직후)

⚠️ **반드시 다음 세 명령어를 순서대로 실행하세요.**
저장소를 새로 클론했거나, 다른 사람이 `pubspec.yaml` / `@freezed` 클래스 / DTO 를 변경한 커밋을 풀 받은 직후엔 항상 이 흐름을 거쳐야 합니다.

```bash
cd mobile-monorepo
melos bootstrap          # 1) 워크스페이스 의존성 동기화 (= npm install)
melos run gen            # 2) freezed/json 코드 자동 생성 (build_runner)
melos analyze            # 3) 정적 분석 (lint + 타입 체크)
```

> 💡 `melos run gen` 을 빠뜨리면 `*.freezed.dart` / `*.g.dart` 파일이 없어서
> "missing part file" 또는 "undefined identifier" 에러가 납니다.

---

## 개발 중 자주 쓰는 명령어

| 상황 | 명령어 |
|---|---|
| 의존성 추가/변경 후 | `melos bootstrap` |
| `@freezed` 클래스 추가/수정 후 | `melos run gen` |
| 코딩 중 freezed 자동 갱신 | `melos run gen:watch` (백그라운드 실행) |
| 린트/타입 검사 | `melos run analyze` |
| 코드 포맷 적용 | `melos run format:fix` |
| 테스트 실행 | `melos run test` |
| 앱 실행 (개발 모드) | `melos run run:dev` |

---

## Melos 스크립트 전체 레퍼런스

`melos.yaml` 에 정의된 모든 스크립트입니다.

| 명령어 | 설명 |
|---|---|
| `melos bootstrap`           | 워크스페이스 의존성 동기화 (각 패키지 `pub get` + path 오버라이드 자동 작성) |
| `melos run pub:get`         | 모든 패키지에 `flutter pub get` 실행 |
| `melos run clean`           | 모든 패키지에 `flutter clean` 실행 |
| `melos run analyze`         | 모든 패키지에 `flutter analyze` 실행 (직렬, lint = turbo lint) |
| `melos run format`          | 포맷팅 검사 (CI 용, 차이 있으면 exit 1) |
| `melos run format:fix`      | 포맷터를 in-place 로 적용 |
| `melos run test`            | `test/` 디렉토리가 있는 패키지에만 `flutter test` 실행 |
| `melos run test:packages`   | 공유 패키지 중 `test/` 디렉토리가 있는 패키지만 테스트 |
| `melos run gen`             | `build_runner build --delete-conflicting-outputs` (freezed/json 1회 생성) |
| `melos run gen:watch`       | 변경 감지 자동 재생성 (개발 중 백그라운드로 띄워두기 유용) |
| `melos run run:dev`         | `customer_app` 디버그 실행 |
| `melos run build:apk`       | `customer_app` 릴리즈 APK 빌드 (Android) |
| `melos run build:ipa`       | `customer_app` 릴리즈 IPA 빌드 (iOS) |

> 모든 `melos run XXX` 는 `melos exec` 로 각 패키지를 순회하며 실행합니다.
> 단일 패키지만 대상으로 하려면 `--scope="패키지명"` 추가:
> 예) `melos exec --scope="api_client" -- "flutter test"`
>
> 새 shared package 또는 base flow 를 추가할 때는 최소 smoke test 1개 이상을 함께 추가하는 것을 기본 정책으로 권장합니다.

---

## 코드 생성 (Freezed / json_serializable)

이 모노레포는 DTO·상태 클래스 보일러플레이트를 줄이기 위해 [Freezed](https://pub.dev/packages/freezed) 와 [json_serializable](https://pub.dev/packages/json_serializable) 을 사용합니다. `==` / `hashCode` / `copyWith` / `toString` / `fromJson` / `toJson` 이 자동 생성됩니다.

### 언제 다시 생성해야 하나?

다음 중 하나라도 해당되면 `melos run gen` 을 다시 실행하세요.

- `@freezed` 클래스 추가/수정 (DTO, state, form value 등)
- `@JsonSerializable` 클래스의 필드 변경
- 위 변경사항이 포함된 커밋을 `git pull` 받은 직후

### 개발 중 자동 갱신

저장할 때마다 자동으로 재생성하려면 watch 모드를 켜놓으세요.

```bash
melos run gen:watch
```

### 산출물 파일 정책

- `*.freezed.dart`, `*.g.dart` 는 **저장소에 커밋합니다** (CI 에서 매번 생성하지 않도록).
- 커밋되어 있어서 CI 는 `melos run gen` 을 호출하지 않지만, **로컬 작업 중 freezed 클래스 변경 후 `gen` 안 돌리면 컴파일 에러**가 납니다.

---

## 앱 실행 / 빌드

### 개발 모드 실행

```bash
# 1) 환경 파일 준비 (최초 1회)
cp apps/customer_app/assets/config/.env.example apps/customer_app/assets/config/.env

# 2) 디버그 실행 (현재 연결된 디바이스/에뮬레이터)
melos run run:dev

# 또는 직접
cd apps/customer_app
flutter run
```

### 디바이스 지정 실행

```bash
flutter devices                               # 연결된 디바이스 목록
cd apps/customer_app
flutter run -d <device-id>                    # 예: flutter run -d "iPhone 15"
```

### 릴리즈 빌드

```bash
melos run build:apk      # Android APK
melos run build:ipa      # iOS IPA (Xcode 서명 필요)

# 산출물 위치:
# apps/customer_app/build/app/outputs/flutter-apk/app-release.apk
# apps/customer_app/build/ios/ipa/customer_app.ipa
```

### iOS 추가 셋업 (최초 1회)

```bash
cd apps/customer_app/ios
pod install
```

---

## 환경변수

### 위치

`apps/customer_app/assets/config/.env`
(`flutter_dotenv` 가 런타임에 로드 — 빌드 시점이 아니라 앱 실행 시점에 읽힘)

### 예시 (`.env.example` 동일)

```bash
API_BASE_URL=http://localhost:8080
DATA_SOURCE=server                      # 'server' | 'mock' — 전체 도메인 토글
OAUTH_REDIRECT_BASE_URL=customerapp://auth
```

| 변수 | 의미 | frontend 대응 |
|---|---|---|
| `API_BASE_URL` | 백엔드 베이스 URL (모든 `*_server_api.dart` 가 사용) | `NEXT_PUBLIC_API_BASE_URL` |
| `DATA_SOURCE` | `server` 면 실제 백엔드, `mock` 이면 in-memory 가짜 응답 | `NEXT_PUBLIC_DATA_SOURCE` |
| `OAUTH_REDIRECT_BASE_URL` | OAuth 콜백을 받을 deep-link 스킴 (예: `customerapp://auth`) | `NEXT_PUBLIC_CLIENT_BASE_URL` 와 의미적 대응 |

> `DATA_SOURCE=mock` 으로 두면 백엔드 없이도 모든 화면이 동작합니다 — 디자인 검토나 화면 흐름 작업할 때 유용.

### 환경변수 읽기 규칙

`dotenv.env[...]` 는 **반드시 `apps/customer_app/lib/src/common/app_config.dart` 안에서만** 읽어야 합니다. 다른 코드는 `AppConfig` 객체 또는 `ApiRuntime` 을 통해 간접적으로 사용.

---

## 도메인 추가 컨벤션

새 API 도메인 (예: `account`, `dashboard`, `chat`) 을 추가할 땐 **4파일 세트**를 모두 만드세요.

```text
packages/api_client/lib/src/
  api/<domain>_api.dart            # 추상 클래스 (계약 정의)
  api/<domain>_server_api.dart     # 실제 dio 호출 구현
  mock/<domain>_mock.dart          # 목 응답
  service/<domain>_service.dart    # 퍼사드 — 런타임에 mock/server 선택
```

`<domain>_service.dart` 의 표준 패턴:

```dart
class XxxService {
  XxxApi get _api => _runtime.isMock ? _mockApi : _serverApi;

  Future<...> someMethod(...) => _api.someMethod(...);
}
```

자세한 템플릿은 **[`packages/api_client/CONVENTIONS.md`](packages/api_client/CONVENTIONS.md)** 참고.

DTO 위치 규칙:
- 계정 폼 (Login/Join/ResetPassword) → `packages/common/lib/src/model/dto/account_dto.dart`
- 이메일 인증 → `packages/common/lib/src/model/dto/email_dto.dart`
- 토큰 응답 → `packages/common/lib/src/model/dto/token_dto.dart`
- 신규 도메인 → `packages/common/lib/src/model/dto/<domain>_dto.dart`

---

## 베이스 구조 원칙

이 워크스페이스는 단일 앱 저장소가 아니라, 새 모바일 앱을 파생시키기 위한
**base source** 를 겸합니다. 그래서 현재 즉시 사용하지 않는 구조라도
기준점으로 유지하는 경우가 있습니다.

- `android/ios/web/linux/windows/macos` 플랫폼 디렉토리는 기본 포함 상태로 유지
- 샘플 앱 `customer_app` 는 인증, 환경변수, mock/server 전환, 디자인 시스템 연결 예시를 모두 포함
- 공유 로직은 최대한 `packages/` 로 끌어올리고, 앱 고유 로직은 `apps/<app>/` 에 남김
- 구조 단순화보다 “새 앱이 출발할 때 기준이 되는가”를 우선

즉, 이 저장소에서는 “지워도 지금 안 깨진다”보다
“새 앱이 복제될 때 어디를 확장하고 어디를 바꿔야 하는지 드러나는가”가 더 중요합니다.

---

## 주요 안티패턴

다음은 **금지** 입니다.

| 안티패턴 | 대신 |
|---|---|
| 앱 코드에서 `Dio` 직접 사용 | 항상 `*Service` 거치기 |
| `_runtime.isMock` 분기를 service 밖에서 사용 | service 의 `_api` getter 한 곳에만 |
| 도메인별 환경변수 (`AUTH_DATA_SOURCE`) | 전역 `DATA_SOURCE` 한 개만 |
| `*_server_api.dart` 또는 `*_mock.dart` 를 배럴에서 export | 항상 service 만 노출 |
| 토큰을 SharedPreferences 에서 직접 읽기 | `AuthSessionController` 또는 `AuthTokenProvider` 통해서 |
| `dotenv.env[...]` 를 `app_config.dart` 밖에서 호출 | 모두 `AppConfig.fromEnv()` 통해 한 번 읽고 주입 |
| `'Authorization'` / `'Bearer '` 하드코딩 | `package:common/common.dart` 의 `authHeader`, `authType` 상수 사용 |

---

## 트러블슈팅

### `Target of URI doesn't exist: 'xxx.freezed.dart'`
→ `melos run gen` 을 실행하지 않은 상태. `melos run gen` 후 IDE 재시작.

### `Could not find package "freezed_annotation"`
→ `melos bootstrap` 누락. `melos bootstrap` 후 다시 시도.

### `melos: command not found`
→ 글로벌 설치 누락 또는 PATH 미설정.
```bash
dart pub global activate melos
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### `pubspec_overrides.yaml` 가 더러워졌을 때
→ `melos clean` 후 `melos bootstrap` 다시.

### Generated 파일이 너무 많이 변경되어 git diff 가 지저분할 때
→ 정상입니다. `*.freezed.dart` / `*.g.dart` 는 커밋합니다.
   더 깔끔한 diff 가 필요하면 `git add -p` 로 부분 스테이징.

### 안드로이드 빌드 실패: minSdkVersion
→ `apps/customer_app/android/app/build.gradle` 의 `minSdkVersion` 확인 (보통 21+ 필요).

### iOS 빌드 실패: pod install 안 됨
```bash
cd apps/customer_app/ios
pod repo update
pod install
```

---

## 참고 문서

- [`packages/api_client/CONVENTIONS.md`](packages/api_client/CONVENTIONS.md) — API 도메인 추가 컨벤션 상세
- [`melos.yaml`](melos.yaml) — 전체 워크스페이스 스크립트 정의
- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [Riverpod 공식 문서](https://riverpod.dev/)
- [go_router 공식 문서](https://pub.dev/packages/go_router)
