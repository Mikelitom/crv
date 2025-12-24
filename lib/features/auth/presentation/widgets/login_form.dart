import 'package:flutter/material.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({ super.key });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(constraints: constraints),
    )
  }
}
