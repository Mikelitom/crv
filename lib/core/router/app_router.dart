import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// Dev
import 'app_routes.dart';
import '../../features/dev/presentation/pages/dev_role_selector_page.dart';

// Auth
import '../../features/auth/presentation/pages/login_page.dart';

// Core Pages
import '../../features/dashboard/presentation/pages/dashboard_entry_page.dart';
import '../../features/inspections/pages/inspections_page.dart';
// import '../../features/reports/pages/reports_page.dart';

// Admin only pages
// import '../../features/users/pages/users_page.dart';
// import '../../features/assets/pages/assets_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,

    initialLocation: kDebugMode
      ? AppRoutes.devUser
      : AppRoutes.login,

    redirect: (context, state) {
      // TODO: Implement Auth
      // final loggedIn = Auth.isLoggedIn;
      final location = state.matchedLocation;

      final isLogin = location == AppRoutes.login;
      final isDevRoute = location == AppRoutes.devUser;
      final isDebug = kDebugMode;

      // if (!loggedId) {
      //   if (isDebug && isDevRoute) return null;
      //   if (!isLogin) return AppRoutes.login;
      // }

      // if (loggedIn && (isLogin || isDevRoute)) {
      //   return AppRoutes.dashboard;
      // }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      // DEV user selector (solo debug)
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.devUser,
          builder: (context, state) => const DevUserSelectorPage(),
        ),

      // Dashboard
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),

      // Inspections
      GoRoute(
        path: AppRoutes.inspections,
        builder: (context, state) => const InspectionsPage(),
      ),

      // Reports
      GoRoute(
        path: AppRoutes.reports,
        builder: (context, state) => const ReportsPage(),
      ),

      // Users (admin UI decides access)
      GoRoute(
        path: AppRoutes.users,
        builder: (context, state) => const UsersPage(),
      ),

      // Assets (admin UI decides access)
      GoRoute(
        path: AppRoutes.assets,
        builder: (context, state) => const AssetsPage(),
      ),
    ],

    // Ruta no encontrada
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Ruta no encontrada'),
      ),
    ),
  );


}