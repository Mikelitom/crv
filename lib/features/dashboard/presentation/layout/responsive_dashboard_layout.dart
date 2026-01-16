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
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= desktopBreakpoint;

    // Ya no usamos un IF con dos retornos diferentes. 
    // Usamos el DashboardLayout y le pasamos el estado 'isDesktop'.
    return DashboardLayout(
      sidebar: sidebar,
      content: content,
      isDesktop: isDesktop,
    );
  }
}