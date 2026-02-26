import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/pages/dashboard_entry_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_router_notifier_provider.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authRouterNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: authNotifier,
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const DashboardEntryPage(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isAuthenticated;
      final isLogin = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isLogin) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isLogin) {
        return AppRoutes.dashboard;
      }

      return null;
    },
  );
});
