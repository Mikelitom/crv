import 'package:flutter/material.dart';
import 'admin/admin_dashboard_page.dart';
import 'technician/technician_dashboard_page.dart';

enum UserRole { admin, technician }

class DashboardEntryPage extends StatelessWidget {
  final UserRole role;

  const DashboardEntryPage({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserRole.admin:
        return const AdminDashboardPage();
      case UserRole.technician:
        return const TechnicianDashboardPage();
    }
  }
}
