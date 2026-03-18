import 'package:flutter/material.dart';
import '../pages/forget_password.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFC62828), // Tu rojo oficial
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
        );
      },
      child: const Text(
        '¿Olvidaste tu contraseña?',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}