import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController {
  static final AuthController instance = AuthController();

  AuthController() {
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      user.value = newUser;
    });
  }

  ValueNotifier<User?> user = ValueNotifier(null);
}
