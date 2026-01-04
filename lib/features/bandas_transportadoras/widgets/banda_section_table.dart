import 'package:flutter/material.dart';

class BandaSectionTable extends StatelessWidget {
  final String sectionTitle;
  final int sectionNumber;
  final List<BandaComponentItem> items;

  const BandaSectionTable({
    super.key, 
    required this.sectionTitle, 
    required this.sectionNumber, 
    required this.items
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la sección (Roja como en la imagen)
          _buildSectionHeader(),
          
          // Tabla de componentes
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              dataRowMinHeight: 100, // Espacio para los radios
              dataRowMaxHeight: 150,
              columns: const [
                DataColumn(label: Text('ACCESORIOS')),
                DataColumn(label: Text('OBSERVACIONES')),
                DataColumn(label: Text('DIMENSIONES')),
                DataColumn(label: Text('ACCIONES Y RECOMENDACIONES')),
                DataColumn(label: Text('EVIDENCIA')),
              ],
              rows: items.map((item) => DataRow(cells: [
                DataCell(Text(item.accessory, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(_buildObservationRadios(item)),
                DataCell(SizedBox(width: 60, child: TextField(textAlign: TextAlign.center, decoration: const InputDecoration(hintText: "0")))),
                DataCell(const SizedBox(width: 200, child: TextField(maxLines: 3))),
                DataCell(IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.red), onPressed: () {})),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFC62828), shape: BoxShape.circle),
            child: const Icon(Icons.settings, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text("Sección $sectionNumber: $sectionTitle", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildObservationRadios(BandaComponentItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: item.observationOptions.map((opt) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(value: opt, groupValue: item.selectedObservation, onChanged: (v) {}),
          Text(opt, style: const TextStyle(fontSize: 12)),
        ],
      )).toList(),
    );
  }
}