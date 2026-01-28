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
          const SidebarHeader(),
          const SizedBox(height: 8),

          SidebarItem(
            icon: Icons.home_outlined,
            label: 'Dashboard',
            isActive: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),

          SidebarItem(
            icon: Icons.assignment_outlined,
            label: 'Inspecciones',
            isActive: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),

          SidebarItem(
            icon: Icons.folder_open_outlined,
            label: 'Reportes',
            isActive: selectedIndex == 2,
            onTap: () => onItemSelected(2),
          ),

          SidebarItem(
            icon: Icons.inventory_2_outlined,
            label: 'Activos',
            isActive: selectedIndex == 3,
            onTap: () => onItemSelected(3),
          ),

          SidebarItem(
            icon: Icons.person_add_alt_outlined,
            label: 'Gestión de Usuarios',
            isActive: selectedIndex == 4,
            onTap: () => onItemSelected(4),
          ),

          SidebarItem(
            icon: Icons.book,
            label: 'Catalogo',
            isActive: selectedIndex == 5,
            onTap: () => onItemSelected(5),
          ),
         SidebarItem(
            icon: Icons.book,
            label: 'Servicios',
            isActive: selectedIndex == 6,
            onTap: () => onItemSelected(6),
          ),

          SidebarItem(
            icon: Icons.notifications_none_outlined,
            label: 'Perfil',
            isActive: selectedIndex == 7,
            onTap: () => onItemSelected(7),
          ),

          const Spacer(),
          const Divider(indent: 20, endIndent: 20),

          SidebarItem(
            icon: Icons.logout,
            label: 'Cerrar Sesión',
            onTap: () {
              // Lógica de logout
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}