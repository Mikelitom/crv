import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Contraseña',
        border: OutlineInputBorder()
      ),
    );
  }
}
