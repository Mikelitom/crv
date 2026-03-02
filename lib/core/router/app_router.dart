import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_status.dart';
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
        path: AppRoutes.dashboard,
        builder: (_, __) => const DashboardEntryPage(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final location = state.matchedLocation;

      if (authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading) {
        return location == AppRoutes.login ? null : AppRoutes.login;
      }

      if (authState.status == AuthStatus.unauthenticated ||
          authState.status == AuthStatus.loading) {
        return null;
      }

      if (authState.status == AuthStatus.authenticated) {
        if (location == AppRoutes.login) {
          return AppRoutes.dashboard;
        }
      }

      return null;
    },
  );
});
