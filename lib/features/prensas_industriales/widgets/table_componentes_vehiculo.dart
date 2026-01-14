import 'package:crv_reprosisa/features/prensas_industriales/Models/prensa_inspection_model.dart';
import 'package:flutter/material.dart';
class PrensaInspectionTable extends StatelessWidget {
  final List<PrensaComponentItem> items;

  const PrensaInspectionTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Responsividad horizontal
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
          columns: const [
            DataColumn(label: Text('Cant.')),
            DataColumn(label: Text('Unidad')),
            DataColumn(label: Text('Descripción del Componente')),
            DataColumn(label: Text('Buenas')),
            DataColumn(label: Text('Malas')),
            DataColumn(label: Text('N/A')),
            DataColumn(label: Text('Observaciones')),
          ],
          rows: items.map((item) => DataRow(cells: [
            DataCell(SizedBox(width: 40, child: TextField(textAlign: TextAlign.center))),
            DataCell(Text(item.unidad)),
            DataCell(Text(item.descripcion)),
            DataCell(Checkbox(value: item.estado == 0, onChanged: (v) {}, activeColor: Colors.red)),
            DataCell(Checkbox(value: item.estado == 1, onChanged: (v) {}, activeColor: Colors.red)),
            DataCell(Checkbox(value: item.estado == 2, onChanged: (v) {}, activeColor: Colors.red)),
            DataCell(const SizedBox(width: 200, child: TextField())),
          ])).toList(),
        ),
      ),
    );
  }
}