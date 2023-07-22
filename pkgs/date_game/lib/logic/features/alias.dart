import '../shared/auth_state.dart';
import '../shared/exceptions.dart';
import '../shared/primitives/docs.dart';
import '../shared/primitives/fb_crud.dart';

class AliasController {
  static const String asiasRules = 'Alias must be 4-40 characters long, '
      'and contain only lowercase letters and numbers.';

  bool isAliasValid(String alias) {
    return RegExp(r'^[0-9a-z]+$').hasMatch(alias) &&
        alias.length >= 4 &&
        alias.length <= 40;
  }

  Future<bool> isAliasAvailable({required String alias}) async {
    final doc = await queryDoc(
      collection: Collections.alias,
      id: alias,
    );
    return doc?.isEmpty ?? true;
  }

  Future<void> createAlias(String alias) async {
    if (!isAliasValid(alias)) throw UiMessageException(asiasRules);
    if (!(await isAliasAvailable(alias: alias))) {
      throw UiMessageException('Alias is already taken.');
    }
    await setDoc(
      collection: Collections.alias,
      id: alias,
      json: Alias(alias: alias).toJson(),
    );
    await setDoc(
      collection: Collections.person,
      id: AuthState.instance.user.value!.uid,
      json: Person(alias: alias).toJson(),
    );
    AuthState.instance.setAlias(alias);
  }
}
