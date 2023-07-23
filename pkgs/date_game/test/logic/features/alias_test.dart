import 'package:date_game/logic/features/alias.dart';
import 'package:flutter_test/flutter_test.dart';

final _goodAliases = ['hello', '12345', 'H123', 'still-good', 'good_alias'];
final _badAliases = [
  'he llo',
  '@@@@',
  '()))',
  'loooooooooooooooooooooooooooooooooooooooooooong',
];

void main() {
  for (var alias in _goodAliases) {
    test('good alias, $alias', () {
      expect(AliasLogic.isAliasValid(alias), isTrue);
    });
  }

  for (var alias in _badAliases) {
    test('bad alias, $alias', () {
      expect(AliasLogic.isAliasValid(alias), isFalse);
    });
  }
}
