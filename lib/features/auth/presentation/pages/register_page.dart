import 'package:flutter/material.dart';
import '../widgets/register_responsive_layout.dart'; // Importamos el nuevo layout responsivo

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Permitimos que el teclado empuje el contenido hacia arriba
      resizeToAvoidBottomInset: true, 
      // Llamamos al layout responsivo partido 50/50
      body: RegisterResponsiveLayout(),
    );
  }
}