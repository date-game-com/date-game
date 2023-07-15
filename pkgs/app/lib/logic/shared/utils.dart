import 'package:flutter/foundation.dart';

void debugPrint(String message) {
  assert(() {
    if (kDebugMode) {
      print(message);
    }
    return true;
  }());
}
