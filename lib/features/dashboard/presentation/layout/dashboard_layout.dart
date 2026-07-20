import 'package:crv_reprosisa/core/connectivity/widgets/connection_status_banner.dart';
import 'package:flutter/material.dart';
import '../widgets/navbar/dashboard_navbar.dart';

class DashboardLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget content;
  final bool isDesktop;

  final String userName;
  final String userRole;

  const DashboardLayout({
    super.key,
    required this.sidebar,
    required this.content,
    required this.isDesktop,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      drawer: !isDesktop ? Drawer(child: sidebar) : null,

      body: Row(
        children: [

          if (isDesktop) sidebar,

          Expanded(
            child: Column(
              children: [

                DashboardNavbar(
                  userName: userName,
                  userRole: userRole,
                  isDesktop: isDesktop,
                ),

                const ConnectionStatusBanner(),

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