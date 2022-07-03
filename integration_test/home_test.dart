import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:desafio_mobile/main.dart' as app;

Future<void> addDelay(int seconds) async {
  await Future<void>.delayed(Duration(seconds: seconds));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Home', () {
    testWidgets('logout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key("loginEmailField")), 'teste@gmail.com');
      await tester.enterText(
          find.byKey(const Key("loginPasswordField")), "123456");
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("loginUserButton")));
      await tester.pumpAndSettle();
      await addDelay(2);
      await tester.tap(find.byKey(const Key("buttonLogout")));
      await tester.pumpAndSettle();

      expect(find.text('Bem vindo de volta'), findsOneWidget);
    });
  });
}
