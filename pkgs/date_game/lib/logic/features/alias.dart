import '../shared/auth_state.dart';
import '../shared/data/collections.dart';
import '../shared/data/docs.dart';
import '../shared/exceptions.dart';

class AliasLogic {
  AliasLogic._();

  static const String asiasRules = 'Alias should be 4-40 characters long, '
      'and may contain english letters, numbers and signs _ and -.';

  static bool isAliasValid(String alias) {
    return RegExp(r'^[0-9a-z-_]+$', caseSensitive: false).hasMatch(alias) &&
        alias.length >= 4 &&
        alias.length <= 40;
  }

  static Future<bool> isAliasAvailable({required String alias}) async {
    final aliasDoc = await Collections.alias.query(alias);
    return aliasDoc == null;
  }

  static Future<void> createAlias(String alias) async {
    if (!isAliasValid(alias)) throw UiMessageException(asiasRules);
    if (!(await isAliasAvailable(alias: alias))) {
      throw UiMessageException('Alias is already taken.');
    }
    await Collections.alias.set(
      id: alias,
      doc: Alias(alias: alias),
    );
    await Collections.person.set(
      id: AuthState.instance.user.value!.uid,
      doc: Person(alias: alias),
    );
    AuthState.instance.setAlias(alias);
  }
}
