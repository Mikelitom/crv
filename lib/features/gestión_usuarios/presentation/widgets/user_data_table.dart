import 'package:flutter/material.dart';

class UserDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Function(int, bool) onToggleStatus;

  const UserDataTable({
    super.key, 
    required this.users, 
    required this.onToggleStatus
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dividerThickness: 0.1,
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
      dataRowMaxHeight: 85,
      columns: ["ESTADO", "USUARIO", "ROL", "ÁREA", "ACCIONES"]
          .map((l) => DataColumn(label: Text(l, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey))))
          .toList(),
      rows: List.generate(users.length, (index) {
        final user = users[index];
        bool isActive = user['isActive'];

        return DataRow(
          color: WidgetStateProperty.resolveWith<Color?>((states) => isActive ? null : Colors.grey.withOpacity(0.05)),
          cells: [
            DataCell(Switch(
              value: isActive, 
              activeColor: Colors.green, 
              onChanged: (val) => onToggleStatus(index, val)
            )),
            DataCell(_userCell(user['name'], isActive)),
            DataCell(Text(user['role'], style: TextStyle(color: isActive ? Colors.black87 : Colors.grey))),
            DataCell(Text(user['area'], style: TextStyle(color: isActive ? Colors.black87 : Colors.grey))),
            DataCell(Row(children: [
              _actionIcon(Icons.edit_note_rounded, Colors.blue, isActive),
              const SizedBox(width: 8),
              _actionIcon(Icons.history_rounded, Colors.orange, isActive),
            ])),
          ],
        );
      }),
    );
  }

  Widget _userCell(String name, bool isActive) {
    return Row(children: [
      CircleAvatar(
        radius: 18, 
        backgroundColor: isActive ? const Color(0xFFFDECEA) : Colors.grey.shade200, 
        child: Text(name[0], style: TextStyle(color: isActive ? const Color(0xFFC62828) : Colors.grey, fontWeight: FontWeight.bold))
      ),
      const SizedBox(width: 14),
      Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black87 : Colors.grey)),
    ]);
  }

  Widget _actionIcon(IconData icon, Color color, bool active) => Container(
    padding: const EdgeInsets.all(8), 
    decoration: BoxDecoration(color: active ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1), shape: BoxShape.circle), 
    child: Icon(icon, color: active ? color : Colors.grey, size: 20)
  );
}