import 'package:flutter/foundation.dart';

void debugPrint(String message) {
  assert(() {
    if (kDebugMode) {
      print(message);
    }
    return true;
  }());
}

void checkFakingIsOk() {
  bool isRelease = true;
  assert(() {
    if (!kReleaseMode) {
      isRelease = false;
    }
    return true;
  }());
  if (isRelease) {
    throw StateError('Faking is not allowed in release mode.');
  }
}
