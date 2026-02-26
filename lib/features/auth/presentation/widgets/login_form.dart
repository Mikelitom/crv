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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Acceso al sistema',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Ingrese sus credenciales para continuar',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 32),
              EmailField(controller: emailController),
              const SizedBox(height: 16),
              PasswordField(controller: passwordController),
              const SizedBox(height: 24),
              Row(
                children: [
                  RememberMeCheckbox(),
                  Spacer(),
                  ForgotPasswordButton(),
                ],
              ),
              const SizedBox(height: 24),
              LoginButton(
                emailController: emailController,
                passwordController: passwordController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
