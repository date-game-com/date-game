import 'dart:math';

import 'package:flutter/material.dart';

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    const double boxWidth = 400;

    double screenWidth = MediaQuery.of(context).size.width;

    double hInsets = max(5, (screenWidth - boxWidth) / 2);

    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: hInsets, right: hInsets, top: 40),
        width: screenWidth,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: titleStyle,
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
