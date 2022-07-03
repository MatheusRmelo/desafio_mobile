import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:desafio_mobile/main.dart' as app;

Future<void> addDelay(int seconds) async {
  await Future<void>.delayed(Duration(seconds: seconds));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Register', () {
    testWidgets('Create a new account', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("buttonPushToSignUP")));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key("registerEmailField")),
          'integrationtest${DateTime.now().millisecondsSinceEpoch}@gmail.com');
      await tester.enterText(
          find.byKey(const Key("registerPasswordField")), "12345678");
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("registerUserButton")));
      await tester.pumpAndSettle();
      await addDelay(2);
      expect(find.text('Sair'), findsOneWidget);
    });
  });
}
