import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../logic/features/auth.dart';
import '../../../logic/shared/auth_state.dart';

class UserStatus extends StatelessWidget {
  const UserStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AuthState.instance.user,
      builder: (context, user, child) {
        if (user == null) {
          return TextButton(
            onPressed: () {
              AuthState.instance.requestSignIn();
            },
            child: const Text('Log in'),
          );
        }

        return _UserDropDown(user: user);
      },
    );
  }
}

class _UserDropDown extends StatelessWidget {
  const _UserDropDown({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final email = user.email ?? '?';

    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return TextButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: const Icon(Icons.face),
        );
      },
      menuChildren: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Logged in as $email'),
              TextButton(
                onPressed: () {
                  AuthController().signOut();
                },
                child: const Text('Log out'),
              ),
              TextButton(
                onPressed: () {
                  AuthState.instance.requestDeleteAccount();
                },
                child: const Text('Delete account'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
