import 'package:flutter/material.dart';
import '../widgets/navbar/dashboard_navbar.dart';

class DashboardLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget content;
  final bool isDesktop; // Recibimos el estado desde el ResponsiveLayout

  const DashboardLayout({
    super.key,
    required this.sidebar,
    required this.content,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Si NO es desktop, la sidebar se va al Drawer (el menú lateral oculto)
      drawer: !isDesktop ? Drawer(child: sidebar) : null,
      body: Row(
        children: [
          // La Sidebar solo aparece fija si es Desktop
          if (isDesktop) sidebar,

          Expanded(
            child: Column(
              children: [
                // AQUÍ CORREGIMOS EL ERROR: Pasamos todos los parámetros requeridos
                DashboardNavbar(
                  userName: "Juan Soto", 
                  userRole: "Empleado",
                  isDesktop: isDesktop, 
                ),
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