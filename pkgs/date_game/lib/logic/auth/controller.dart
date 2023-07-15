import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController {
  static final AuthController instance = AuthController();

  AuthController() {
    void handleUserChanged(User? newUser) => user.value = newUser;

    FirebaseAuth.instance.authStateChanges().listen(handleUserChanged);
    FirebaseAuth.instance.userChanges().listen(handleUserChanged);
    FirebaseAuth.instance.idTokenChanges().listen(handleUserChanged);
  }

  ValueNotifier<User?> user = ValueNotifier(null);

  Future<void> signIn() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> signOut() async {
    user.value = null;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signUp(String email, String password) async {
    user.value = null;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> delete() async {
    user.value = null;
    await user.value?.delete();
  }
}
