import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/layout/responsive_dashboard_layout.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/sidebar/sidebar_technician.dart';
import 'package:crv_reprosisa/features/profile/presentation/page/profile_page.dart';
import 'package:crv_reprosisa/features/inspections/presentation/pages/inspections_page.dart';
import 'package:crv_reprosisa/features/reports/Pages/reports_page.dart';

class TechnicianDashboardPage extends ConsumerStatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  ConsumerState<TechnicianDashboardPage> createState() =>
      _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState
    extends ConsumerState<TechnicianDashboardPage> {
  int _internalIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user;
    if (user == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Validación de seguridad
    final bool isVerified = user.scope.trim().toUpperCase() != 'NONE';
    final int activeIndex = isVerified
        ? _internalIndex
        : 3; // Forzamos 3 (Perfil) si no es verificado

    final pages = [
      const Center(child: Text("Dashboard")), // 0
      const InspectionPage(stats: [], actions: [], inspections: []), // 1
      const ReportsPage(), // 2
      const ProfilePage(), // 3
    ];

    return ResponsiveDashboardLayout(
      userName: user.name,
      userRole: user.role[0],
      sidebar: SidebarTechnician(
        selectedIndex: activeIndex,
        onItemSelected: (i) {
          if (isVerified) setState(() => _internalIndex = i);
        },
      ),
      content: Padding(
        padding: const EdgeInsets.all(24),
        child: pages[activeIndex],
      ),
    );
  }
}
