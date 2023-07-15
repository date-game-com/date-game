import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController {
  static final AuthController instance = AuthController();

  AuthController() {
    FirebaseAuth.instance.authStateChanges().listen(_handleUserChanged);
    FirebaseAuth.instance.userChanges().listen(_handleUserChanged);
    FirebaseAuth.instance.idTokenChanges().listen(_handleUserChanged);
  }

  ValueNotifier<User?> user = ValueNotifier(null);
  void _handleUserChanged(User? newUser) {
    user.value = newUser;
  }
}
