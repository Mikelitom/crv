import 'package:crv_reprosisa/features/reports/models/report_row_ui.dart';
import 'package:flutter/material.dart';

class ReportTable extends StatelessWidget {
  final List<ReportRowUI> items;

  const ReportTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint para detectar pantallas pequeñas (Móvil)
        bool isCompact = constraints.maxWidth < 900;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ENCABEZADO DINÁMICO ---
                // Si es pequeño usa Column, si hay espacio usa Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                  child: isCompact 
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lista de Reportes Aprobados",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
                          ),
                          const SizedBox(height: 16),
                          _buildSearchField(double.infinity), // Ancho completo en móvil
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Lista de Reportes Aprobados",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
                          ),
                          _buildSearchField(380), // Ancho fijo en escritorio
                        ],
                      ),
                ),

                const SizedBox(height: 16),

                // --- TABLA CON SCROLL HORIZONTAL ---
                // El Scroll horizontal evita que la tabla se corte en pantallas pequeñas
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 12)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: isCompact ? 800 : constraints.maxWidth),
                        child: DataTable(
                          headingRowHeight: 68,
                          dataRowMaxHeight: 85,
                          horizontalMargin: 32,
                          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
                          columns: const [
                            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                            DataColumn(label: Text('TIPO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                            DataColumn(label: Text('FECHA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                            DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                          ],
                          rows: items.map((item) => _buildDataRow(item)).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField(double width) {
    return SizedBox(
      width: width,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar reportes...",
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(ReportRowUI item) {
    return DataRow(cells: [
      DataCell(Text(item.titulo.split(' ').last, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(item.tipo)),
      DataCell(Text(item.fecha, style: const TextStyle(color: Color(0xFF546E7A), fontWeight: FontWeight.bold))),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.visibility_rounded, color: Colors.blue, size: 22), onPressed: () {}),
          IconButton(icon: const Icon(Icons.print_rounded, color: Color(0xFFC62828), size: 20), onPressed: () {}),
        ],
      )),
    ]);
  }
}