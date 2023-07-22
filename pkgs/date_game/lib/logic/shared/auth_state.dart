import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'primitives/utils.dart';

enum AuthStates {
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

    void handleUserChanged(User? newUser) {
      _user.value = newUser;
      _state.value =
          newUser == null ? AuthStates.signedOut : AuthStates.signedIn;
    }

    FirebaseAuth.instance.authStateChanges().listen(handleUserChanged);
    FirebaseAuth.instance.userChanges().listen(handleUserChanged);
    FirebaseAuth.instance.idTokenChanges().listen(handleUserChanged);
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
