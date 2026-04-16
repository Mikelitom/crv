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

  // Mapeo estricto para evitar errores en el Mapper de infraestructura
  static const Map<String, String> _scopeMap = {
    'General': 'ALL',
    'Bandas': 'CONVEYOR',
    'Vehículo': 'VEHICLE',
    'Prensas': 'PRESS',
    'Pendiente': 'NONE',
  };

  String _getFriendlyScope(String scope) {
    final clean = scope.trim().toUpperCase();
    if (clean == 'NONE') return 'Pendiente';
    return _scopeMap.entries
        .firstWhere((e) => e.value == clean, orElse: () => MapEntry(scope, scope))
        .key;
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("Sin registros")));

    return DataTable(
      columnSpacing: 20,
      horizontalMargin: 24,
      headingRowHeight: 56,
      dataRowMaxHeight: 72,
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
      dividerThickness: 0.5,
      columns: const [
        DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.black45, letterSpacing: 1))),
        DataColumn(label: Text('USUARIO', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.black45, letterSpacing: 1))),
        DataColumn(label: Text('ROL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.black45, letterSpacing: 1))),
        DataColumn(label: Text('ÁREA DE ACCESO', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.black45, letterSpacing: 1))),
      ],
      rows: users.map((user) {
        final isPending = user.scope.toUpperCase() == 'NONE';
        return DataRow(
          cells: [
            DataCell(Transform.scale(
              scale: 0.7,
              child: Switch(
                value: user.isActive,
                activeColor: Colors.green,
                onChanged: (v) => onToggleStatus(user.id, v),
              ),
            )),
            DataCell(_userCell(user.name, user.isActive, isPending)),
            DataCell(_buildDropdown(
              current: user.role.first,
              items: ['admin', 'technician'],
              isActive: user.isActive,
              onChanged: (val) => onRoleChanged(user.id, [val!]),
            )),
            DataCell(_buildDropdown(
              current: _getFriendlyScope(user.scope),
              items: _scopeMap.keys.toList(),
              isActive: user.isActive,
              isHighlight: isPending,
              onChanged: (val) {
                // CORRECCIÓN: Enviamos el string puro que la API y el Mapper reconocen
                final backendValue = _scopeMap[val];
                if (backendValue != null) {
                  onScopeChanged(user.id, backendValue);
                }
              },
            )),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({required String current, required List<String> items, required bool isActive, bool isHighlight = false, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFC62828).withOpacity(0.08) : const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isHighlight ? const Color(0xFFC62828).withOpacity(0.2) : Colors.transparent),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(current) ? current : items.first,
          isDense: true,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black45),
          style: TextStyle(
            fontSize: 12, 
            color: isHighlight ? const Color(0xFFC62828) : Colors.black87,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600
          ),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: isActive ? onChanged : null,
        ),
      ),
    );
  }

  Widget _userCell(String name, bool isActive, bool isPending) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isPending 
                ? [Colors.orange, Colors.orangeAccent] 
                : [const Color(0xFFC62828), const Color(0xFFE53935)]
            ),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Center(
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : "?", 
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? Colors.black87 : Colors.grey)),
      ],
    );
  }
}