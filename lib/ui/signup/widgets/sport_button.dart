import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SportButton extends StatefulWidget {
  const SportButton({
    super.key,
    required this.sportName,
    required this.onSelectionChanged,
  });

  final String sportName;
  final Function(String, bool) onSelectionChanged;

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
          widget.onSelectionChanged(widget.sportName, isSelected);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.blueAccent),
        child: Text(widget.sportName));
  }

}