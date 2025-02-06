import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(dividerText),
        Flexible(
          child: Divider(
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          )
        )
      ],
    );
  }
}