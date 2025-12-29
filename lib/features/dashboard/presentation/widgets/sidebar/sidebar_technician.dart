import 'package:flutter/material.dart';
import 'sidebar_item.dart';

class SidebarTechnician extends StatelessWidget {
  const SidebarTechnician({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.grey.shade100,
      child: Column(
        children: const [
          SizedBox(height: 24),
          SidebarItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
          ),
          SidebarItem(
            icon: Icons.search, 
            label: 'Inspecciones',
            badgeCount: 3,
          ),
          SidebarItem(
            icon: Icons.report, 
            label: 'Reportes',
            badgeCount: 3,
          ),
          Spacer(),
          SidebarItem(
            icon: Icons.logout, 
            label: 'Cerrar sesión'
          )
        ],
      ),
    );
  }
}

