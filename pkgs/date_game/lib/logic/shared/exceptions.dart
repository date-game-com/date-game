import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Some possible values of [FirebaseAuthException.code].
enum FirebaseErrorCodes {
  emailAlreadyInUse('email-already-in-use'),
  ;

  final String value;

  const FirebaseErrorCodes(this.value);
}

String exceptionToUiMessage(Object? exception) {
  if (exception is FirebaseAuthException) {
    return exception.message ?? 'Unexpected firebase error';
  }

  if (exception is UiMessageException) {
    return exception.message;
  }

  debugPrint('Unexpected error of type ${exception.runtimeType}: $exception');

  return 'Unexpected error. Check console for details.';
}

/// Exception that showld be shown to the user.
class UiMessageException implements Exception {
  String message;
  UiMessageException(this.message);
}
