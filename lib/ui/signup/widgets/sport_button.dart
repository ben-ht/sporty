import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SportButton extends StatefulWidget {
  const SportButton({super.key, required this.sportName});

  final String sportName;

  @override
  State<StatefulWidget> createState() {
    return _SportButtonState();
  }

}

class _SportButtonState extends State<SportButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.blueAccent),
        child: Text(widget.sportName));
  }

}