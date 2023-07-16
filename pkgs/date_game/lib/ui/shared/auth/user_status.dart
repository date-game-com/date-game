import 'package:flutter/material.dart';

import '../../../logic/auth/controller.dart';

class UserStatus extends StatelessWidget {
  const UserStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AuthController.instance.user,
      builder: (context, user, child) {
        final displayName = user?.displayName;
        if (displayName == null) {
          return TextButton(
              onPressed: () {
                AuthController.instance.setWantToSignIn(true);
              },
              child: const Text('Log in'));
        } else {
          return Text(displayName);
        }
      },
    );
  }
}
