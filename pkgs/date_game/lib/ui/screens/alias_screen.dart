import 'package:flutter/material.dart';

import '../../logic/shared/auth/controller.dart';

class SetAliasScreen extends StatefulWidget {
  const SetAliasScreen({super.key});

  @override
  State<SetAliasScreen> createState() => _SetAliasScreenState();
}

class _SetAliasScreenState extends State<SetAliasScreen> {
  final _aliasController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Choose unique alias:'),
        TextField(
          controller: _aliasController,
        ),
        TextButton(
          onPressed: () async {
            await AuthController.instance.createAlias(_aliasController.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
