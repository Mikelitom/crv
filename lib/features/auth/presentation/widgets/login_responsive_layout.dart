import 'package:flutter/material.dart';
import 'login_form.dart';
import 'login_hero.dart';

class LoginResponsiveLayout extends StatelessWidget {
  const LoginResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Si la pantalla es menor a 850px, solo mostramos el formulario
          if (constraints.maxWidth < 850) {
            return const LoginForm();
          }

          // Para pantallas grandes, dividimos 50/50
          return Row(
            children: const [
              Expanded(child: LoginHero()),
              Expanded(child: LoginForm()),
            ],
          );
        },
      ),
    );
  }
}