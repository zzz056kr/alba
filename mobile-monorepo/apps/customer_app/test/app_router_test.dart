import 'package:customer_app/main.dart';
import 'package:customer_app/src/page/mypage_page.dart';
import 'package:customer_app/src/router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _pumpApp(
  WidgetTester tester, {
  required Map<String, Object> sharedPreferences,
}) async {
  SharedPreferences.setMockInitialValues(sharedPreferences);
  await dotenv.load(
    fileName: 'assets/config/.env',
    mergeWith: {
      'API_BASE_URL': 'http://localhost:8080',
      'DATA_SOURCE': 'mock',
      'OAUTH_REDIRECT_BASE_URL': 'customerapp://auth',
    },
  );

  final container = ProviderContainer();
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const CustomerApp()),
  );
  await tester.pumpAndSettle();

  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('redirects unauthenticated users away from protected routes', (
    WidgetTester tester,
  ) async {
    final container = await _pumpApp(tester, sharedPreferences: const {});
    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);

    expect(find.text('사장님 로그인'), findsOneWidget);
    expect(find.text('사장 로그인'), findsAtLeastNWidgets(1));

    router.go('/');
    await tester.pumpAndSettle();

    expect(find.text('사장님 로그인'), findsOneWidget);

    router.go(MyPagePage.routePath);
    await tester.pumpAndSettle();

    expect(find.text('사장님 로그인'), findsOneWidget);
  });

  testWidgets('restores authenticated session and opens mypage', (
    WidgetTester tester,
  ) async {
    final container = await _pumpApp(
      tester,
      sharedPreferences: {
        'auth_access_token': 'access-token',
        'auth_access_token_expires_in': 3600,
        'auth_refresh_token': 'refresh-token',
        'auth_refresh_token_expires_in': 7200,
        'auth_user_id': 'base-user',
        'auth_token_issued_at': DateTime(2026, 1, 1).millisecondsSinceEpoch,
      },
    );
    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);

    expect(find.textContaining('안녕하세요, base-user'), findsOneWidget);
    expect(find.text('마이페이지'), findsOneWidget);

    router.go(MyPagePage.routePath);
    await tester.pumpAndSettle();

    expect(find.text('마이페이지'), findsAtLeastNWidgets(1));
    expect(find.text('base-user'), findsOneWidget);
  });
}
