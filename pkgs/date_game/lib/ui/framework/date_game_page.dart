import 'package:flutter/material.dart';

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

class _DateGameBody extends StatelessWidget {
  const _DateGameBody();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
