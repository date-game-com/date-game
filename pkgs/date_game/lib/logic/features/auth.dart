import 'package:firebase_auth/firebase_auth.dart';

import '../shared/auth_state.dart';
import '../shared/exceptions.dart';

class AuthLogic {
  AuthLogic._();

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    AuthState.instance.setSignedOut();
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> signUp(String email) async {
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

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> delete({required String password}) async {
    final theUser = AuthState.instance.user.value;
    assert(theUser != null);
    if (theUser == null) return;

    await theUser.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: theUser.email!,
        password: password,
      ),
    );
    await theUser.delete();
    AuthState.instance.setSignedOut();
  }
}
