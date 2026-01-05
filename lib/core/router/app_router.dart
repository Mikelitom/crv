import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dev/presentation/pages/dev_role_selector_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_entry_page.dart';
import '../session/auth_session.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.dev,
  refreshListenable: authSession,
  routes: [
    GoRoute(
      path: AppRoutes.dev,
      builder: (_, __) => const DevRoleSelectorPage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (_, __) => const DashboardEntryPage(),
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = authSession.isAuthenticated;
    final isDev = state.matchedLocation == AppRoutes.dev;

    if (!isLoggedIn && !isDev) {
      return AppRoutes.dev;
    }

    if (isLoggedIn && isDev) {
      return AppRoutes.dashboard;
    }

    return null;
  },
);
