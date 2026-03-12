import 'package:flutter/material.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'login_button.dart';
import 'remember_me_checkbox.dart';
import 'forgot_password_button.dart';
import '../pages/register_page.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC62828)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              const Text('Acceso al Sistema', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text('Ingrese sus credenciales para continuar', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 40),
              
              const Text('Nombre de usuario', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              EmailField(controller: emailController),
              
              const SizedBox(height: 24),
              
              const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              PasswordField(controller: passwordController),
              
              const SizedBox(height: 16),
              
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
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

              const SizedBox(height: 24),

              // --- APARTADO DE REGISTRO ---
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Usuario nuevo?', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                      },
                      child: const Text('Regístrate aquí', style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}