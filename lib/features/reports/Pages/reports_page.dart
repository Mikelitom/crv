import 'package:crv_reprosisa/core/session/auth_session.dart';
import 'package:crv_reprosisa/features/reports/widgets/reports_view.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserRole?>(
      valueListenable: authSession,
      builder: (_, role, __) {
        final isAdmin = role == UserRole.admin;

        return ReportsView(isAdmin: isAdmin);
      },
    );
  }
}
