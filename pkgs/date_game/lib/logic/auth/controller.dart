import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../shared/exceptions.dart';

class AuthController {
  static final AuthController instance = AuthController();

  AuthController() {
    void handleUserChanged(User? newUser) => user.value = newUser;

    FirebaseAuth.instance.authStateChanges().listen(handleUserChanged);
    FirebaseAuth.instance.userChanges().listen(handleUserChanged);
    FirebaseAuth.instance.idTokenChanges().listen(handleUserChanged);
  }

  ValueNotifier<User?> user = ValueNotifier(null);

  Future<void> signIn({required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    user.value = null;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signUp(String email) async {
    String randomPassword() => DateTime.now().microsecondsSinceEpoch.toString();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: randomPassword());
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code != FirebaseErrorCodes.emailAlreadyInUse.value) rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> delete() async {
    user.value = null;
    await user.value?.delete();
  }
}
