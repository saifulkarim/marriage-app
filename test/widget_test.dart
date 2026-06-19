import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/main.dart';

void main() {
  testWidgets('App loads login screen when not authenticated', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionProvider.overrideWith((ref) async => false),
        ],
        child: const GetMarriedApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('GetMarried'), findsOneWidget);
    expect(find.text('লগইন'), findsOneWidget);
  });
}
