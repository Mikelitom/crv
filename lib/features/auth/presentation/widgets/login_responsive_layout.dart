import 'package:flutter/material.dart';
import 'login_form.dart';
import 'login_hero.dart';

class LoginResponsiveLayout extends StatelessWidget {
  const LoginResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return const LoginForm();
        }

        return Row(
          children: const [
            Expanded(child: LoginHero()),
            Expanded(child: LoginForm()),
          ],
        );
      },
    );
  }
}
