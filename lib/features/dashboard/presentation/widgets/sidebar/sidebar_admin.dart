import 'package:flutter/material.dart';
import 'sidebar_container.dart';
import 'sidebar_header.dart';
import 'sidebar_item.dart';
import 'logout_button.dart';

class SidebarAdmin extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SidebarAdmin({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<SidebarAdmin> createState() => _SidebarAdminState();
}

class _SidebarAdminState extends State<SidebarAdmin> {
  // Controlamos si el submenú está abierto
  bool _isCatalogExpanded = false;

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
            isActive: widget.selectedIndex == 0,
            onTap: () => widget.onItemSelected(0),
          ),
          SidebarItem(
            icon: Icons.assignment_outlined,
            label: 'Inspecciones',
            isActive: widget.selectedIndex == 1,
            onTap: () => widget.onItemSelected(1),
          ),
          SidebarItem(
            icon: Icons.folder_open_outlined,
            label: 'Reportes',
            isActive: widget.selectedIndex == 2,
            onTap: () => widget.onItemSelected(2),
          ),
          SidebarItem(
            icon: Icons.inventory_2_outlined,
            label: 'Activos',
            isActive: widget.selectedIndex == 3,
            onTap: () => widget.onItemSelected(3),
          ),
          SidebarItem(
            icon: Icons.person_add_alt_outlined,
            label: 'Gestión de Usuarios',
            isActive: widget.selectedIndex == 4,
            onTap: () => widget.onItemSelected(4),
          ),

          // --- SECCIÓN CATÁLOGO CON SUBMENÚ ---
          Column(
            children: [
              SidebarItem(
                icon: Icons.book_outlined,
                label: 'Catálogo',
                // Activo si está seleccionado Vehículos (5) o Prensas (8)
                isActive: widget.selectedIndex == 5 || widget.selectedIndex == 6,
                onTap: () {
                  setState(() => _isCatalogExpanded = !_isCatalogExpanded);
                },
              ),
              if (_isCatalogExpanded || widget.selectedIndex == 5 || widget.selectedIndex == 6)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    children: [
                      SidebarItem(
                        icon: Icons.local_shipping_outlined,
                        label: 'Vehículos',
                        isActive: widget.selectedIndex == 5,
                        onTap: () => widget.onItemSelected(5),
                      ),
                      SidebarItem(
                        icon: Icons.settings_input_component_rounded,
                        label: 'Prensas',
                        isActive: widget.selectedIndex == 6,
                        onTap: () => widget.onItemSelected(6),
                      ),
                    ],
                  ),
                ),
            ],
          ),

        // --- SUBMENÚ SERVICIOS ---
          Column(
            children: [
              SidebarItem(
                icon: Icons.build_outlined,
                label: 'Servicios',
                isActive: widget.selectedIndex == 7 || widget.selectedIndex == 9, // Ajustado para nuevo índice
                onTap: () {
                  setState(() {
                    _isServicesExpanded = !_isServicesExpanded;
                    _isCatalogExpanded = false;
                  });
                },
              ),
              if (_isServicesExpanded || widget.selectedIndex == 7 || widget.selectedIndex == 9)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    children: [
                      SidebarItem(
                        icon: Icons.car_repair_outlined,
                        label: 'Servicio Vehículos',
                        isActive: widget.selectedIndex == 7,
                        onTap: () => widget.onItemSelected(7),
                      ),
                      SidebarItem(
                        icon: Icons.precision_manufacturing_outlined,
                        label: 'Servicio Prensas',
                        isActive: widget.selectedIndex == 9,
                        onTap: () => widget.onItemSelected(9),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SidebarItem(
            icon: Icons.person_outline,
            label: 'Perfil',
            isActive: widget.selectedIndex == 8,
            onTap: () => widget.onItemSelected(8),
          ),

          const Spacer(),
          const Divider(indent: 20, endIndent: 20),
          const LogoutButton(showLabel: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}