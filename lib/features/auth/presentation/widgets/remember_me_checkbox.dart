import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatefulWidget {
  const RememberMeCheckbox({super.key});

  @override
  State<RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  bool _isSelected = false; // Estado para que el check funcione

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _isSelected,
          activeColor: const Color(0xFFC62828), // Rojo oficial
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (bool? value) {
            setState(() {
              _isSelected = value ?? false;
            });
          },
        ),
        const Text(
          'Recuérdame',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}