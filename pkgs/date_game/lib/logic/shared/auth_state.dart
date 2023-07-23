import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'data/collections.dart';
import 'primitives/simple_items.dart';

enum AuthStates {
  loading,
  signedOut,
  signedIn,
  wantToSignIn,
  wantToSignUp,
  wantToDeleteAccount,
}

class AuthState {
  static late final AuthState instance;

  static void initialize({bool fake = false}) {
    instance = AuthState._(fake: fake);
  }

  AuthState._({bool fake = false}) {
    if (fake) {
      checkFakingIsOk();
      return;
    }

    FirebaseAuth.instance.authStateChanges().listen(handleUserChanged);
    FirebaseAuth.instance.userChanges().listen(handleUserChanged);
    FirebaseAuth.instance.idTokenChanges().listen(handleUserChanged);
  }

  Future<void> handleUserChanged(User? newUser) async {
    print(1);
    if (newUser == null) {
      _alias.value = null;
      _user.value = null;
      _state.value = AuthStates.signedOut;
      print(2);
      return;
    }

    if (newUser.uid == _user.value?.uid) {
      _user.value = newUser;
      print(3);
      return;
    }

    debugPrint('uid: ${newUser.uid}');
    _state.value = AuthStates.loading;
    _user.value = newUser;
    print(4);
    try {
      print(5);
      _alias.value = (await Collections.person.query(newUser.uid))?.alias;
      print(6);
    } catch (e) {
      // ignore: avoid_print
      print('Error getting alias: $e');
      rethrow;
    }
    print(7);
    _state.value = AuthStates.signedIn;
    print(8);
  }

  ValueListenable<User?> get user => _user;
  final ValueNotifier<User?> _user = ValueNotifier(null);
  void setSignedOut() {
    _user.value = null;
    _state.value = AuthStates.signedOut;
  }

  ValueListenable<AuthStates> get state => _state;
  final ValueNotifier<AuthStates> _state = ValueNotifier(AuthStates.signedOut);

  ValueListenable<String?> get alias => _alias;
  final ValueNotifier<String?> _alias = ValueNotifier(null);
  void setAlias(String alias) => _alias.value = alias;

  void requestSignIn() {
    assert(user.value == null);
    assert(state.value == AuthStates.signedOut);
    _state.value = AuthStates.wantToSignIn;
  }

  void requestDeleteAccount() {
    assert(user.value != null);
    assert(state.value == AuthStates.signedIn);
    _state.value = AuthStates.wantToDeleteAccount;
  }

  void cancelSignIn() {
    assert(user.value == null);
    _state.value = AuthStates.signedOut;
  }
}
