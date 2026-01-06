import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/router/app_routes.dart';

class DevRoleSelectorPage extends StatelessWidget {
  const DevRoleSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev Role Selector')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                authSession.setRole(UserRole.admin);
                context.go(AppRoutes.dashboard);
              },
              child: const Text('Entrar como ADMIN'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                authSession.setRole(UserRole.technician);
                context.go(AppRoutes.dashboard);
              },
              child: const Text('Entrar como TÉCNICO'),
            ),
          ],
        ),
      ),
    );
  }
}
