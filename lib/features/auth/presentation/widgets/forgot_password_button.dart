import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // navegación futura
      },
      child: const Text('¿Olvidaste tu contraseña?'),
    );
  }
}
