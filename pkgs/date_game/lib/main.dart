import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'logic/auth/controller.dart';
import 'logic/shared/primitives/utils.dart';
import 'ui/framework/date_game_page.dart';

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
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.fakeFirebase) checkFakingIsOk();

    _initFirebase().then((_) {
      _initControllers();
      setState(() => _initialized = true);
    });
  }

  Future<void> _initFirebase() async {
    if (widget.fakeFirebase) return;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _initControllers() {
    AuthController.initialize(fake: widget.fakeFirebase);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DateGamePage(initialized: _initialized),
      debugShowCheckedModeBanner: false,
    );
  }
}
