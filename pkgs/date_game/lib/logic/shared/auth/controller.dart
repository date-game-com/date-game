import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../exceptions.dart';
import '../primitives/utils.dart';

enum AuthStates {
  signedOut,
  signedIn,
  wantToSignIn,
  wantToSignUp,
  wantToDeleteAccount,
}

class AuthController {
  static late final AuthController instance;

  static void initialize({bool fake = false}) {
    instance = AuthController(fake: fake);
  }

  AuthController({bool fake = false}) {
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

  Future<void> signIn({required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    _user.value = null;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signUp(String email) async {
    String randomPassword() => DateTime.now().microsecondsSinceEpoch.toString();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: randomPassword(),
      );
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code != FirebaseErrorCodes.emailAlreadyInUse.value) rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> delete({required String password}) async {
    final theUser = user.value;
    assert(theUser != null);
    if (theUser == null) return;

    await theUser.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: theUser.email!,
        password: password,
      ),
    );
    await theUser.delete();

    _user.value = null;
    _state.value = AuthStates.signedOut;
  }
}
