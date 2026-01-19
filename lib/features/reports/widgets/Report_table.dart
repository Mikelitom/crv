import 'package:flutter/material.dart';

class ReportTableCombined extends StatelessWidget {
  const ReportTableCombined({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // La tabla abarca todo el tamaño disponible
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SECCIÓN FILTROS (Sin empleado)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Filtros de Búsqueda", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildSearchField(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildDropdown("Tipo de Reporte"),
                    ),
                    const SizedBox(width: 16),
                    _buildApplyButton(),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // SECCIÓN TABLA
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Text("Lista de Reportes Aprobados", 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          
          // DataTable que abarca el ancho total
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('Tipo')),
                DataColumn(label: Text('Título')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: _generateSampleRows(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Buscar reportes...",
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
        ),
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
        ),
      ),
      items: const [],
      onChanged: (v) {},
    );
  }

  Widget _buildApplyButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.filter_list, size: 18),
      label: const Text("Aplicar Filtros"),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFC62828),
        side: const BorderSide(color: Color(0xFFFDECEA)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  List<DataRow> _generateSampleRows() {
    return [
      _rowItem("Vehículo", "Inspección V-008", "2024-05-15"),
      _rowItem("Prensa", "Inspección P-002", "2024-05-12"),
    ];
  }

  DataRow _rowItem(String tipo, String titulo, String fecha) {
    return DataRow(cells: [
      DataCell(Text(tipo)),
      DataCell(Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(fecha)),
      DataCell(_buildBadge()),
      DataCell(Row(
        children: const [
          Icon(Icons.visibility, color: Color(0xFFC62828), size: 20),
          SizedBox(width: 12),
          Icon(Icons.file_download, color: Color(0xFFC62828), size: 20),
        ],
      )),
    ]);
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text("Aprobado", 
        style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}