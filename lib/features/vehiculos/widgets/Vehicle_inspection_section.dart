import 'package:flutter/material.dart';
import '../models/inspection_vehicle_model.dart';
class VehicleInspectionSection extends StatelessWidget {
  final String title;
  final List<InspectionItemModel> items;

  const VehicleInspectionSection({
    super.key, 
    required this.title, 
    required this.items
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              columns: const [
                DataColumn(label: Text('Componente')),
                DataColumn(label: Text('Buena')),
                DataColumn(label: Text('Mala')),
                DataColumn(label: Text('Reposición')),
                DataColumn(label: Text('Reparación')),
                DataColumn(label: Text('Observaciones')),
                DataColumn(label: Text('Foto')),
              ],
              rows: items.map((item) => DataRow(cells: [
                DataCell(Text(item.description)),
                DataCell(Checkbox(value: item.status == 0, onChanged: (v) {}, activeColor: Colors.red)),
                DataCell(Checkbox(value: item.status == 1, onChanged: (v) {}, activeColor: Colors.red)),
                DataCell(Checkbox(value: item.status == 2, onChanged: (v) {}, activeColor: Colors.red)),
                DataCell(Checkbox(value: item.status == 3, onChanged: (v) {}, activeColor: Colors.red)),
                DataCell(SizedBox(width: 150, child: TextField(decoration: InputDecoration(hintText: "Escribir...", border: InputBorder.none)))),
                DataCell(IconButton(icon: const Icon(Icons.camera_alt, color: Colors.red), onPressed: () {})),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }
}