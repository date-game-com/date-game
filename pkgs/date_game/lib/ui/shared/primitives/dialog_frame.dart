import 'dart:math';

import 'package:flutter/material.dart';

class DialogFrame extends StatelessWidget {
  const DialogFrame({
    super.key,
    required this.title,
    required this.content,
    required this.onClose,
  });

  final String title;
  final Widget content;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    const double boxWidth = 200;
    const double boxHeight = 500;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double vInsets = max(5, (screenHeight - boxHeight) / 2);
    double hInsets = max(5, (screenWidth - boxWidth) / 2);

    final style = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: vInsets, horizontal: hInsets),
        width: screenWidth,
        height: screenHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: style?.fontSize,
                    ),
                    onPressed: onClose,
                  ),
                ],
              ),
              Text(
                title,
                style: style,
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
