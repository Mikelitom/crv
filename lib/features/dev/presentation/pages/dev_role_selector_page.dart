import 'package:flutter/material.dart';
import '../../../dashboard/presentation/pages/dashboard_entry_page.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardEntryPage(
                      role: UserRole.admin,
                    ),
                  ),
                );
              },
              child: const Text('Entrar como ADMIN'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardEntryPage(
                      role: UserRole.technician,
                    ),
                  ),
                );
              },
              child: const Text('Entrar como TÉCNICO'),
            ),
          ],
        ),
      ),
    );
  }
}
