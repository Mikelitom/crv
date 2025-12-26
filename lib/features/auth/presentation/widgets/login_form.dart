import 'package:flutter/material.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'login_button.dart';
import 'remember_me_checkbox.dart';
import 'forgot_password_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

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
            children: const [
              Text(
                'Acceso al sistema',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Ingrese sus credenciales para continuar',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 32),
              EmailField(),
              SizedBox(height: 16),
              PasswordField(),
              SizedBox(height: 24),
              Row(
                children: [
                  RememberMeCheckbox(),
                  Spacer(),
                  ForgotPasswordButton(),
                ],
              ),
              SizedBox(height: 24),
              LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
