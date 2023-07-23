import 'package:flutter/material.dart';

import '../../logic/features/alias.dart';
import '../shared/primitives/colors.dart';
import '../shared/primitives/screen_frame.dart';

class SetAliasScreen extends StatefulWidget {
  const SetAliasScreen({super.key});

  @override
  State<SetAliasScreen> createState() => _SetAliasScreenState();
}

class _SetAliasScreenState extends State<SetAliasScreen> {
  final _alias = TextEditingController();
  String? _error = AliasLogic.asiasRules;
  bool? isValid = false;

  @override
  void initState() {
    super.initState();
    _alias.addListener(_handleChange);
  }

  Future<void> _handleChange() async {
    final text = _alias.text;
    isValid = null;

    if (!AliasLogic.isAliasValid(text)) {
      setState(() {
        _error = AliasLogic.asiasRules;
        isValid = false;
      });
      return;
    }

    print('text is valid, checking availability');

    if (!await AliasLogic.isAliasAvailable(alias: text)) {
      if (_alias.text != text) return;
      setState(() {
        _error = 'Alias is already taken.';
        isValid = false;
      });
      return;
    }

    if (_alias.text != text) return;

    setState(() {
      _error = null;
      isValid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Choose unique alias',
      child: Column(
        children: [
          const Text('Alias cannot be modified later. '
              'To change alias, you will need to recreate your account.'),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(child: TextField(controller: _alias)),
                if (isValid == true)
                  Icon(Icons.check, color: AppColors.verified.color),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(_error ?? ''),
          TextButton(
            onPressed: () async {
              await AliasLogic.createAlias(_alias.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
