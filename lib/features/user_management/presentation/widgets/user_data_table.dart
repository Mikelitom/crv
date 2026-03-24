import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user.dart';

class UserDataTable extends StatelessWidget {
  final List<User> users;
  final Function(String, bool) onToggleStatus;
  final Function(String, List<String>) onRoleChanged;
  final Function(String, String) onScopeChanged;

  const UserDataTable({
    super.key,
    required this.users,
    required this.onToggleStatus,
    required this.onRoleChanged,
    required this.onScopeChanged,
  });

  // Traduce los códigos de base de datos a nombres amigables para la UI
  String _getFriendlyScope(String scope) {
    switch (scope.toUpperCase()) {
      case 'ALL': return 'General';
      case 'CONVEYOR': return 'Bandas';
      case 'VEHICLE': return 'Vehiculo';
      case 'PRESS': return 'Prensas';
      default: return scope;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,
      horizontalMargin: 16,
      headingRowHeight: 52,
      dataRowMaxHeight: 68,
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
      columns: const [
        DataColumn(label: Text('ESTADO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        DataColumn(label: Text('USUARIO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        DataColumn(label: Text('ROL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        DataColumn(label: Text('ÁREA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
      ],
      rows: users.map((user) {
        final isActive = user.isActive;
        return DataRow(
          cells: [
            DataCell(
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: isActive,
                  activeColor: Colors.green,
                  onChanged: (val) => onToggleStatus(user.id, val),
                ),
              ),
            ),
            DataCell(_userCell(user.name, isActive)),
            DataCell(_buildDropdown(
              current: user.role.isNotEmpty ? user.role.first : 'technician',
              items: ['admin', 'technician', 'Admin Área'],
              isActive: isActive,
              onChanged: (val) => onRoleChanged(user.id, [val!]),
            )),
            DataCell(_buildDropdown(
              current: _getFriendlyScope(user.scope),
              items: ['General', 'Bandas', 'Vehiculo', 'Prensas'],
              isActive: isActive,
              onChanged: (val) => onScopeChanged(user.id, val!),
            )),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({required String current, required List<String> items, required bool isActive, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.blueGrey.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(current) ? current : items.first,
          isDense: true,
          style: TextStyle(fontSize: 12, color: isActive ? Colors.black87 : Colors.grey, fontWeight: FontWeight.w500),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: isActive ? onChanged : null,
        ),
      ),
    );
  }

  Widget _userCell(String name, bool isActive) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? const Color(0xFFC62828) : Colors.grey,
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : "?", 
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? Colors.black87 : Colors.grey),
          ),
        ),
      ],
    );
  }
}