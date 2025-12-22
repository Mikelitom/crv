import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({ Key? key }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _EmailField(),
                SizedBox(height: 16),
                _PasswordField(),
                SizedBox(height: 24),
                _LoginButton(),
              ],
            ),
          ),
        ),
      );
  }
}