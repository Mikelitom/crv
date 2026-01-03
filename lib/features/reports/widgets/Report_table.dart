import 'package:flutter/material.dart';

class ReportTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ReportTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Título')),
            DataColumn(label: Text('Fecha')),
            DataColumn(label: Text('Estado')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: data.map((report) => DataRow(cells: [
            DataCell(Text(report['tipo'])),
            DataCell(Text(report['titulo'])),
            DataCell(Text(report['fecha'])),
            DataCell(_buildBadge(report['estado'])), // Etiqueta dinámica
            DataCell(Row(
              children: [
                IconButton(icon: const Icon(Icons.visibility, color: Colors.red), onPressed: () {}),
                IconButton(icon: const Icon(Icons.download, color: Colors.red), onPressed: () {}),
              ],
            )),
          ])).toList(),
        ),
      ),
    );
  }

  // Widget para las etiquetas de estado (Aprobado, Pendiente)
  Widget _buildBadge(String status) {
    Color color = status == "Aprobado" ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}