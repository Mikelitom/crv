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
  // Variables de estado declaradas para evitar errores
  bool _isCatalogExpanded = false;
  bool _isServicesExpanded = false;

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
            icon: Icons.assessment_outlined,
            label: 'Activos',
            isActive: widget.selectedIndex == 3,
            onTap: () => widget.onItemSelected(3),
          ),

          // --- SUBMENÚ CATÁLOGO ---
          _buildSubMenu(
            label: 'Catálogo',
            icon: Icons.book_outlined,
            isExpanded: _isCatalogExpanded,
            onExpand: () => setState(() {
              _isCatalogExpanded = !_isCatalogExpanded;
              _isServicesExpanded = false;
            }),
            items: [
              _SubItem(
                label: 'Vehículos',
                icon: Icons.local_shipping_outlined,
                index: 5,
              ),
              _SubItem(
                label: 'Prensas',
                icon: Icons.settings_input_component_rounded,
                index: 6,
              ),
            ],
          ),

          // --- SUBMENÚ SERVICIOS ---
          _buildSubMenu(
            label: 'Servicios',
            icon: Icons.build_outlined,
            isExpanded: _isServicesExpanded,
            onExpand: () => setState(() {
              _isServicesExpanded = !_isServicesExpanded;
              _isCatalogExpanded = false;
            }),
            items: [
              _SubItem(
                label: 'Servicio Vehículos',
                icon: Icons.car_repair_outlined,
                index: 7,
              ),
              _SubItem(
                label: 'Servicio Prensas',
                icon: Icons.precision_manufacturing_outlined,
                index: 8,
              ),
            ],
          ),

          SidebarItem(
            icon: Icons.person_add_alt_outlined,
            label: 'Gestión de Usuarios',
            isActive: widget.selectedIndex == 4,
            onTap: () => widget.onItemSelected(4),
          ),
          SidebarItem(
            icon: Icons.person_outline,
            label: 'Perfil',
            isActive: widget.selectedIndex == 9,
            onTap: () => widget.onItemSelected(9),
          ),

          const Spacer(),
          const LogoutButton(showLabel: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSubMenu({
    required String label,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onExpand,
    required List<_SubItem> items,
  }) {
    bool isAnyActive = items.any((item) => widget.selectedIndex == item.index);
    return Column(
      children: [
        SidebarItem(
          icon: icon,
          label: label,
          isActive: isAnyActive,
          onTap: onExpand,
        ),
        if (isExpanded || isAnyActive)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: items
                  .map(
                    (item) => SidebarItem(
                      icon: item.icon,
                      label: item.label,
                      isActive: widget.selectedIndex == item.index,
                      onTap: () => widget.onItemSelected(item.index),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _SubItem {
  final String label;
  final IconData icon;
  final int index;
  _SubItem({required this.label, required this.icon, required this.index});
}

