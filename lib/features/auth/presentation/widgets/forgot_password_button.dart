import 'package:flutter/material.dart';
import '../pages/forget_password.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Flexible para que el botón se adapte al espacio restante
    // y no cause el error de "Overflow" que se ve en tu imagen.
    return Flexible(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFC62828), // Tu rojo oficial
          padding: const EdgeInsets.symmetric(horizontal: 8),
          // Esto ayuda a que el botón sea más compacto si el espacio es poco
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
          );
        },
        child: const Text(
          '¿Olvidaste tu contraseña?',
          textAlign: TextAlign.right, // Lo alineamos a la derecha
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          // Estas dos líneas son la clave para la responsividad:
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}