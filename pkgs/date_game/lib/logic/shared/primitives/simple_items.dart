import 'package:flutter/foundation.dart';

/// For debugging purposes.
///
/// Will be printed to console on startup.
const version = 1;

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
