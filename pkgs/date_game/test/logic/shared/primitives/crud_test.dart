import 'package:date_game/logic/shared/primitives/crud.dart';
import 'package:date_game/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await initializeApp();
  });

  test('create', () async {
    await createDoc('test', {'a': 1});
  });
}
