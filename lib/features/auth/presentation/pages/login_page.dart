import 'package:flutter/material.dart';
import '../widgets/login_responsive_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginResponsiveLayout(),
    );
  }
}
