import 'package:flutter/material.dart';

import 'register_form.dart'; // Importaremos el formulario que crearemos en el paso 2

class RegisterResponsiveLayout extends StatelessWidget {
  const RegisterResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos LayoutBuilder para conocer el espacio disponible
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Si el ancho es menor a 850px (punto de corte), mostramos diseño móvil
          if (constraints.maxWidth < 850) {
            return const RegisterForm();
          }

          // Para pantallas grandes, diseño partido 50/50 usando Row y Expanded
          return Row(
            children: [
              // LADO IZQUIERDO: Hero Rojo (idéntico al del Login)
              const Expanded(
                child: _RegisterHero(),
              ),
              // LADO DERECHO: Formulario Blanco
              const Expanded(
                child: RegisterForm(),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- WIDGET PRIVADO PARA EL HERO IZQUIERDO (IGUAL AL LOGIN) ---
class _RegisterHero extends StatelessWidget {
  const _RegisterHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFC62828), // Tu rojo oficial
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contenedor del icono/logo con opacidad
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset(
                'assets/images/logo_reprosisa_blanco.png', // Tu logo versión blanca
                height: 100,
                fit: BoxFit.contain,
                // Si no hay imagen, muestra el icono por defecto
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.print_rounded, size: 90, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            // Nombre de la empresa
            const Text(
              'CRV Reprosisa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}