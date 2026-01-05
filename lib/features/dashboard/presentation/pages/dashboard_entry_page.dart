import 'package:crv_reprosisa/core/session/auth_session.dart';
import 'package:flutter/material.dart';
import 'admin/admin_dashboard_page.dart';
import 'technician/technician_dashboard_page.dart';

class DashboardEntryPage extends StatelessWidget {
  const DashboardEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserRole?>(
      valueListenable: authSession,
      builder: (_, role, __) {
        switch (role) {
          case UserRole.admin:
            return const AdminDashboardPage();
          case UserRole.technician:
            return const TechnicianDashboardPage();
          default:
            return const SizedBox.shrink(); // o loader
        }
      },
    );
  }
}