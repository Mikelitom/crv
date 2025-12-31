import 'package:crv_reprosisa/features/dashboard/presentation/pages/admin/admin_dashboard_page.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/pages/dashboard_entry_page.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/pages/technician/technician_dashboard_page.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const DashboardEntryPage(role: UserRole.admin);
      },
      routes: [
        GoRoute(
          path: 'admin/dashboard',
          builder: (context, state) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: 'technician/dashboard',
          builder: (context, state) => const TechnicianDashboardPage()
        )
      ]
    )
  ]
);
