import 'package:flutter/material.dart';
import '../widgets/navbar/dashboard_navbar.dart';

class DashboardLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget content;

  const DashboardLayout({
    super.key,
    required this.sidebar,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Row(
        children: [
          // Sidebar
          sidebar,

          // Main content
          Expanded(
            child: Column(
              children: [
                const DashboardNavbar(),
                Expanded(
                  child: content,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
