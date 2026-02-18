import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';

class TableInspector extends StatelessWidget {
  final List<InspectionRowUI> items;
  final ValueChanged<String> onSearch;

  const TableInspector({
    super.key,
    required this.items,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        // ESTÉTICA DE ALTURAS (Igual a Gestión de Usuarios)
        headingRowHeight: 68,
        dataRowMaxHeight: 85,
        horizontalMargin: 32,
        columnSpacing: 40,
        // Fondo gris sutil para el encabezado
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
        dividerThickness: 1,
        
        columns: _buildColumns(),
        rows: items.map((item) => _buildRow(item)).toList(),
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
          fontSize: 13, 
          letterSpacing: 0.8
        ),
      ),
    )).toList();
  }

  DataRow _buildRow(InspectionRowUI item) {
    return DataRow(
      cells: [
        // ID
        DataCell(Text(
          "#${item.id}", 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))
        )),
        
        // TIPO (Con fuente más limpia)
        DataCell(Text(
          item.equipment, 
          style: const TextStyle(fontSize: 14, color: Color(0xFF454B4E))
        )),
        
        // FECHA
        DataCell(Text(
          item.date, 
          style: const TextStyle(fontSize: 14, color: Color(0xFF546E7A))
        )),
        
        // ESTADO (Badge estilizado)
        DataCell(_buildStatusBadge(item.state)),
        
        // ACCIONES
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_rounded, color: Colors.blue, size: 22),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColor.withOpacity(0.2)),
      ),
      child: Text(
        state.toUpperCase(),
        style: TextStyle(
          color: baseColor, 
          fontSize: 11, 
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5
        ),
      ),
    );
  }
}