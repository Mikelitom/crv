import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            activeColor: const Color(0xFFC62828),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: onChanged,
            side: const BorderSide(color: Colors.grey, width: 1.5),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Recuérdame',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}