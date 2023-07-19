import 'package:flutter/material.dart';

import '../../logic/shared/auth/controller.dart';
import '../screens/dashboard_screen.dart';
import '../screens/landing_screen.dart';
import '../shared/auth/auth_dialog.dart';
import '../shared/auth/user_status.dart';
import '../shared/primitives/simple_items.dart';

class DateGamePage extends StatefulWidget {
  const DateGamePage({super.key, required this.initialized});

  final bool initialized;

  @override
  State<DateGamePage> createState() => _DateGamePageState();
}

class _DateGamePageState extends State<DateGamePage> {
  @override
  Widget build(BuildContext context) {
    if (!widget.initialized) {
      return const Scaffold(
        body: Center(
          child: Progress(),
        ),
      );
    }

    return ValueListenableBuilder(
      valueListenable: AuthController.instance.state,
      builder: (context, state, ___) {
        bool hideAppBar =
            {AuthState.wantToSignIn, AuthState.wantToSignUp}.contains(state);
        return Scaffold(
          appBar: hideAppBar
              ? null
              : AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  centerTitle: false,
                  title: const Text('Date Game  (under construction)'),
                  actions: const [UserStatus()],
                ),
          body: _DateGameBody(state),
        );
      },
    );
  }
}

class _DateGameBody extends StatelessWidget {
  const _DateGameBody(this.state);

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AuthState.signedIn:
        return const DashboardScreen();
      case AuthState.signedOut:
        return const LandingScreen();
      case AuthState.wantToSignIn:
      case AuthState.wantToSignUp:
        return const AuthDialog();

      case AuthState.wantToDeleteAccount:
        throw UnimplementedError();
    }
  }
}
