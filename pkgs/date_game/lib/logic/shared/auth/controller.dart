import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../exceptions.dart';
import '../primitives/fb_crud.dart';
import '../primitives/utils.dart';

enum AuthState {
  signedOut,
  signedIn,
  wantToSignIn,
  wantToSignUp,
  wantToDeleteAccount,
}

class Person {
  final String alias;

  const Person({
    required this.alias,
  });
}

enum _Json {
  alias,
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
      _state.value = newUser == null ? AuthState.signedOut : AuthState.signedIn;
    }

    FirebaseAuth.instance.authStateChanges().listen(handleUserChanged);
    FirebaseAuth.instance.userChanges().listen(handleUserChanged);
    FirebaseAuth.instance.idTokenChanges().listen(handleUserChanged);
  }

  ValueListenable<User?> get user => _user;
  final ValueNotifier<User?> _user = ValueNotifier(null);

  ValueListenable<AuthState> get state => _state;
  final ValueNotifier<AuthState> _state = ValueNotifier(AuthState.signedOut);

  ValueListenable<Person?> get person => _person;
  final ValueNotifier<Person?> _person = ValueNotifier(null);

  bool get wantToSignIn => _wantToSignIn.value;
  final ValueNotifier<bool> _wantToSignIn = ValueNotifier(false);

  void requestSignIn() {
    assert(user.value == null);
    assert(state.value == AuthState.signedOut);
    _state.value = AuthState.wantToSignIn;
  }

  void requestDeleteAccount() {
    assert(user.value != null);
    assert(state.value == AuthState.signedIn);
    _state.value = AuthState.wantToDeleteAccount;
  }

  void cancelSignIn() {
    assert(user.value == null);
    _state.value = AuthState.signedOut;
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

  Future<void> createAlias(String alias) async {
    final json = {
      _Json.alias.name: alias,
    };
    await createDoc(
      collection: Collections.person,
      path: user.value!.uid,
      json: json,
    );
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
    _state.value = AuthState.signedOut;
  }
}
