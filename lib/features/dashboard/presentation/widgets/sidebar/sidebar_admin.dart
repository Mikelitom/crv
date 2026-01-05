import 'package:flutter/material.dart';
import 'sidebar_container.dart';
import 'sidebar_header.dart';
import 'sidebar_item.dart';

class SidebarAdmin extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SidebarAdmin({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SidebarHeader(),
          const SizedBox(height: 8),

          SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isActive: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),

          SidebarItem(
            icon: Icons.people,
            label: 'Usuarios',
            badgeCount: 3,
            isActive: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),

          SidebarItem(
            icon: Icons.bar_chart_outlined,
            label: 'Reportes',
            isActive: selectedIndex == 2,
            onTap: () => onItemSelected(2),
          ),

          const Spacer(),

          SidebarItem(
            icon: Icons.logout,
            label: 'Cerrar Sesión',
            onTap: () {
              // aquí luego conectas auth / logout
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
