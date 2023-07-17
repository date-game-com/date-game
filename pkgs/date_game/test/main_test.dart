// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:date_game/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_infra/simple_items.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App(fakeFirebase: true));
    await tester.pump();

    await expectLater(
      find.byType(App),
      checkGolden('landing_fake_firebase.png'),
    );

    expect(find.textContaining('Date Game'), findsAtLeastNWidgets(1));
    expect(find.text('Log in'), findsOneWidget);
  });
}
