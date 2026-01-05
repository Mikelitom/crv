import 'package:flutter/material.dart';
import 'sidebar_container.dart';
import 'sidebar_header.dart';
import 'sidebar_item.dart';

class SidebarTechnician extends StatelessWidget {
  const SidebarTechnician({ super.key });
  
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
            isActive: true
          ),
          SidebarItem(
            icon: Icons.people, 
            label: 'Usuarios',
            badgeCount: 3,
          ),
          SidebarItem(
            icon: Icons.bar_chart_outlined, 
            label: 'Reportes'
          ),

          const Spacer(),

          SidebarItem(
            icon: Icons.logout, 
            label: 'Cerrar Sesion'
          ),
          const SizedBox(height: 12)
        ],
      )
    );
  }
}

