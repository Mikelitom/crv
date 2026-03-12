import 'package:flutter/material.dart';

class UserFilterBar extends StatelessWidget {
  final String selectedStatus;
  final String selectedRole;
  final Function(String?) onStatusChanged;
  final Function(String?) onRoleChanged;
  final VoidCallback onReset;

  const UserFilterBar({
    super.key,
    required this.selectedStatus,
    required this.selectedRole,
    required this.onStatusChanged,
    required this.onRoleChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: Colors.grey.withOpacity(0.1))
      ),
      child: Wrap(
        spacing: 16, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.filter_list_rounded, color: Color(0xFFC62828), size: 20),
          _buildDropdown(selectedStatus, ['Todos los Estados', 'Habilitados', 'Deshabilitados'], onStatusChanged),
          Container(width: 1, height: 24, color: Colors.grey.withOpacity(0.2)),
          _buildDropdown(selectedRole, ['Todos los Roles', 'Administrador', 'Admin Área', 'Técnico'], onRoleChanged),
          IconButton(onPressed: onReset, icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.blueGrey)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}