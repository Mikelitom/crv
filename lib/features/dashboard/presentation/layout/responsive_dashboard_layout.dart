import 'package:flutter/material.dart';
import 'dashboard_layout.dart';

class ResponsiveDashboardLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget content;

  const ResponsiveDashboardLayout({
    super.key,
    required this.sidebar,
    required this.content,
  });

  static const double desktopBreakpoint = 1024;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 📱 Mobile / Tablet
    if (width < desktopBreakpoint) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        drawer: Drawer(
          child: sidebar,
        ),
        body: content,
      );
    }

    // 🖥 Desktop
    return DashboardLayout(
      sidebar: sidebar,
      content: content,
    );
  }
}
