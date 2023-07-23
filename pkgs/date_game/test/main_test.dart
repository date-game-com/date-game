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
