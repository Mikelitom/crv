import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/reports_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    if (user == null) return ReportsView(isAdmin: false);

    final isAdmin = user.role.contains("admin");

    return ReportsView(isAdmin: isAdmin);
  }
}
