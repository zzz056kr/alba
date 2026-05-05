import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/main.dart';

void main() {
  testWidgets('renders app shell page', (WidgetTester tester) async {
    await dotenv.load(
      fileName: 'assets/config/.env',
      mergeWith: {
        'API_BASE_URL': 'http://localhost:8080',
        'DATA_SOURCE': 'mock',
        'OAUTH_REDIRECT_BASE_URL': 'customerapp://auth',
      },
    );

    await tester.pumpWidget(const ProviderScope(child: CustomerApp()));
    await tester.pumpAndSettle();

    expect(find.text('BASE'), findsOneWidget);
    expect(find.text('사장님 로그인'), findsOneWidget);
    expect(find.text('사장'), findsOneWidget);
    expect(find.text('직원'), findsOneWidget);
  });
}
