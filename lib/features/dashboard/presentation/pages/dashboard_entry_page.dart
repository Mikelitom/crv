import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/pages/admin/admin_dashboard_page.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/pages/technician/technician_dashboard_page.dart';

class DashboardEntryPage extends ConsumerWidget {
  const DashboardEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (user.role.contains("admin")) {
      return const AdminDashboardPage();
    }

    return const TechnicianDashboardPage();
  }
}