import 'package:flutter/material.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'login_button.dart';
import 'remember_me_checkbox.dart';
import 'forgot_password_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Detectamos si la pantalla es estrecha para mostrar el logo
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Corregido: propiedad de alineación
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- LOGO DE LA EMPRESA ---
              if (isMobile) ...[
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC62828),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.print_rounded, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'CRV Reprosisa',
                        style: TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFFC62828)
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              const Text(
                'Acceso al Sistema',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingrese sus credenciales para continuar',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              const Text('Nombre de usuario', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              EmailField(controller: emailController),
              
              const SizedBox(height: 24),
              
              const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              PasswordField(controller: passwordController),
              
              const SizedBox(height: 16),
              
              // --- SOLUCIÓN AL OVERFLOW: Wrap manda los elementos abajo si no caben ---
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, // Espacio horizontal
                runSpacing: 8, // Espacio vertical cuando se va para abajo
                children: const [
                  RememberMeCheckbox(),
                  ForgotPasswordButton(),
                ],
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: LoginButton(
                  emailController: emailController,
                  passwordController: passwordController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}