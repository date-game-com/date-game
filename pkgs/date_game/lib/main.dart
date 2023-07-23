import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'logic/shared/auth_state.dart';
import 'logic/shared/primitives/utils.dart';
import 'ui/framework/date_game_page.dart';

Completer? _initialized;

Future<void> initializeApp({bool fakeFirebase = false}) async {
  try {
    if (_initialized != null) return _initialized!.future;
    _initialized = Completer();

    if (fakeFirebase) checkFakingIsOk();

    WidgetsFlutterBinding.ensureInitialized();

    if (!fakeFirebase) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    AuthState.initialize(fake: fakeFirebase);

    _initialized!.complete();
  } catch (e) {
    debugPrint('Error initializing app: $e');
  }
}

Future<void> main(List<String> args) async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key, this.fakeFirebase = false});

  final bool fakeFirebase;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    unawaited(
      initializeApp(fakeFirebase: widget.fakeFirebase).then((_) {
        setState(() {});
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DateGamePage(appInitialized: _initialized!.isCompleted),
      debugShowCheckedModeBanner: false,
    );
  }
}
