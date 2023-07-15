// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:date_game/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Prerequisite to run for macos:
// flutter create --platforms=macos .

// Run for macos:
// flutter test integration_test/app_test.dart -d macos

// Run headless:
// flutter test integration_test/app_test.dart -d flutter-tester

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke', (tester) async {
    app.main([]);
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 10));
  });
}
