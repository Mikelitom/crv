import 'package:flutter/material.dart';

class BaseTable extends StatelessWidget {
  final List<String> columns;
  final List<DataRow> rows;

  const BaseTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) => const Color(0xFFF9FAFB),
            ),
            columns: columns.map((c) => DataColumn(
              label: Container(
                constraints: const BoxConstraints(maxWidth: 150), 
                child: Text(
                  c,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )).toList(),
            rows: rows,
          ),
        ),
      ),
    );
  }
}

/// Helper para generar las celdas de acción de forma consistente
DataCell actionCell(
  dynamic r,
  bool isAdmin, {
  VoidCallback? onView,
  VoidCallback? onPrint,
  VoidCallback? onEdit,
}) => DataCell(
  Row(
    children: [
      // Botón Ver
      IconButton(
        icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
        onPressed: onView ?? () {},
      ),

      // Botones administrativos
      if (isAdmin) ...[
        // Botón Imprimir
        IconButton(
          icon: const Icon(Icons.print, color: Colors.red, size: 20),
          onPressed: onPrint ?? () {},
        ),
        // Botón Editar / Extra
        IconButton(
          icon: const Icon(Icons.note_add, color: Colors.orange, size: 20),
          onPressed: onEdit ?? () {},
        ),
      ],
    ],
  ),
);

Widget statusChip(String? state) {
  final safeState = (state ?? 'PENDING').toUpperCase();
  final isApproved = safeState == 'APPROVED' || safeState == 'COMPLETED';

  return Chip(
    label: Text(
      safeState,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: isApproved ? Colors.green.shade700 : Colors.orange.shade700,
      ),
    ),
    backgroundColor: isApproved ? Colors.green.shade50 : Colors.orange.shade50,
    side: BorderSide.none,
  );
}
