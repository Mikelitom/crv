import 'package:flutter/material.dart';
class VehicleInspectionItem {
  final String description;
  int? status; // 0: Buena, 1: Mala, 2: Reposición, 3: Reparación

  VehicleInspectionItem({required this.description, this.status});
}

class VehicleInspectionSection extends StatelessWidget {
  final String title;
  final List<VehicleInspectionItem> items;

  const VehicleInspectionSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
              columns: const [
                DataColumn(label: Text('Descripción del Componenete')),
                DataColumn(label: Text('Buena')),
                DataColumn(label: Text('Mala')),
                DataColumn(label: Text('Reposición')),
                DataColumn(label: Text('Reparación')),
                DataColumn(label: Text('Observaciones')),
                DataColumn(label: Text('Foto')),
              ],
              rows: items.map((item) => DataRow(cells: [
                DataCell(Text(item.description)),
                DataCell(Checkbox(value: item.status == 0, onChanged: (v) {})),
                DataCell(Checkbox(value: item.status == 1, onChanged: (v) {})),
                DataCell(Checkbox(value: item.status == 2, onChanged: (v) {})),
                DataCell(Checkbox(value: item.status == 3, onChanged: (v) {})),
                DataCell(const SizedBox(width: 150, child: TextField())),
                DataCell(IconButton(icon: const Icon(Icons.file_upload, color: Colors.red), onPressed: () {})),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }
}