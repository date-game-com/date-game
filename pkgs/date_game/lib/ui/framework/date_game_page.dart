import 'package:flutter/material.dart';

import '../../logic/shared/auth_state.dart';
import '../screens/alias_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/landing_screen.dart';
import '../shared/primitives/simple_items.dart';
import 'auth/auth_dialog.dart';
import 'auth/user_status.dart';

class DateGamePage extends StatefulWidget {
  const DateGamePage({super.key, required this.appInitialized});

  final bool appInitialized;

  @override
  State<DateGamePage> createState() => _DateGamePageState();
}

class _DateGamePageState extends State<DateGamePage> {
  @override
  Widget build(BuildContext context) {
    if (!widget.appInitialized) {
      return const Scaffold(
        body: Center(
          child: Progress(),
        ),
      );
    }

    return ValueListenableBuilder(
      valueListenable: AuthState.instance.state,
      builder: (context, state, ___) {
        return Scaffold(
          appBar: AppBar(
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

  final AuthStates state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AuthStates.signedIn:
        return const _AliasOrDashboard();
      case AuthStates.signedOut:
        return const LandingScreen();
      case AuthStates.wantToSignIn:
      case AuthStates.wantToSignUp:
        return const AuthDialog();
      case AuthStates.wantToDeleteAccount:
        return const Placeholder();
      case AuthStates.loading:
        return const Progress();
    }
  }
}

class _AliasOrDashboard extends StatelessWidget {
  const _AliasOrDashboard();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: AuthState.instance.alias,
      builder: (context, alias, __) {
        if (alias == null) return const SetAliasScreen();
        return const DashboardScreen();
      },
    );
  }
}
