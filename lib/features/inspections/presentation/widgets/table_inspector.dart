import 'package:crv_reprosisa/features/inspections/presentation/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';

class TableInspector extends StatelessWidget {
  final List<InspectionRowUI> items;

  const TableInspector({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay ítems tras el filtro
    if (items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No se encontraron inspecciones.")),
      );
    }

    // Scroll horizontal para evitar el error de "Overflow" en móviles
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: DataTable(
          headingRowHeight: 68,
          dataRowMaxHeight: 85,
          horizontalMargin: 24,
          columnSpacing: 24,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
          dividerThickness: 1,
          columns: _buildColumns(),
          rows: items.map((item) => _buildRow(item)).toList(),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    const labels = ['ID', 'TIPO DE EQUIPO', 'FECHA', 'ESTADO', 'ACCIONES'];
    return labels.map((label) => DataColumn(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xFF454B4E),
          fontSize: 12,
          letterSpacing: 0.5
        ),
      ),
    )).toList();
  }

  DataRow _buildRow(InspectionRowUI item) {
    return DataRow(
      cells: [
        DataCell(Text("#${item.id}", style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(item.equipment)),
        DataCell(Text(item.date)),
        DataCell(_buildStatusBadge(item.state)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_rounded, color: Colors.blue, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.print_rounded, color: Color(0xFFD32F2F), size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String state) {
    bool isDone = state.toLowerCase().contains('completada');
    Color baseColor = isDone ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        state.toUpperCase(),
        style: TextStyle(color: baseColor, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }
}