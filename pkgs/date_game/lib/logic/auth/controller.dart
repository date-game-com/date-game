import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../shared/exceptions.dart';

enum AuthState {
  signedOut,
  signedIn,
  wantToSignIn,
  wantToSignUp,
}

class AuthController {
  static late final AuthController instance;

  void initialize() {
    instance = AuthController();
  }

  AuthController() {
    void handleUserChanged(User? newUser) {
      print('setting $newUser');
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

  bool get wantToSignIn => _wantToSignIn.value;
  final ValueNotifier<bool> _wantToSignIn = ValueNotifier(false);
  void requestSignIn() {
    assert(user.value == null);
    assert(state.value == AuthState.signedOut);
    _state.value = AuthState.wantToSignIn;
  }

  void cancelSignIn() {
    assert(user.value == null);
    assert(state.value == AuthState.wantToSignIn);
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

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> delete() async {
    _user.value = null;
    await user.value?.delete();
  }
}
