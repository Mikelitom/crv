import 'package:flutter/material.dart';
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_admin.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveDashboardLayout(
      sidebar: const SidebarAdmin(),
      content: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Panel de Administración',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text('Estadísticas generales'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
