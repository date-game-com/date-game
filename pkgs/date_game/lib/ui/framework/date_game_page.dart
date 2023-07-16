import 'package:flutter/material.dart';

import '../../logic/auth/controller.dart';
import '../screens/dashboard_screen.dart';
import '../screens/landing_screen.dart';
import '../shared/auth/auth_dialog.dart';
import '../shared/auth/user_status.dart';

class DateGamePage extends StatelessWidget {
  const DateGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        title: const Text('Date Game  (under construction)'),
        actions: const [UserStatus()],
      ),
      body: const _DateGameBody(),
    );
  }
}

class _DateGameBody extends StatefulWidget {
  const _DateGameBody();

  @override
  State<_DateGameBody> createState() => _DateGameBodyState();
}

class _DateGameBodyState extends State<_DateGameBody> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AuthController.instance.state,
      builder: (context, state, ___) {
        switch (state) {
          case AuthState.signedIn:
            return const DashboardScreen();
          case AuthState.signedOut:
            return const LandingScreen();
          case AuthState.wantToSignIn:
          case AuthState.wantToSignUp:
            return const AuthScreen();
        }
      },
    );
  }
}
