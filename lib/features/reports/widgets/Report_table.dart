import 'package:crv_reprosisa/features/reports/models/report_row_ui.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/table/app_table.dart';
import '../../../core/widgets/table/app_table_column.dart';
import '../../../core/widgets/table/app_table_cell.dart';

class ReportTable extends StatelessWidget {
  const ReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = <AppTableColumn<ReportRowUI>>[
      const AppTableColumn(label: 'Tipo'),
      const AppTableColumn(label: 'Título'),
      const AppTableColumn(label: 'Fecha'),
      const AppTableColumn(label: 'Estado'),
      const AppTableColumn(label: 'Acciones'),
    ];

    final data = _sampleData();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filtros de Búsqueda",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(flex: 3, child: _buildSearchField()),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: _buildDropdown("Tipo de Reporte")),
                    const SizedBox(width: 16),
                    _buildApplyButton(),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Text(
              "Lista de Reportes Aprobados",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AppTable<ReportRowUI>(
              columns: columns,
              data: data,
              cellBuilder: (item, column) {
                switch (column.label) {
                  case 'Tipo':
                    return Text(item.tipo);

                  case 'Título':
                    return Text(
                      item.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );

                  case 'Fecha':
                    return Text(item.fecha);

                  case 'Estado':
                    return _buildBadge();

                  case 'Acciones':
                    return Row(
                      children: [
                        AppTableCell(
                          onTap: () {},
                          child: const Icon(
                            Icons.visibility,
                            color: Color(0xFFC62828),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        AppTableCell(
                          onTap: () {},
                          child: const Icon(
                            Icons.file_download,
                            color: Color(0xFFC62828),
                            size: 20,
                          ),
                        ),
                      ],
                    );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- Widgets auxiliares ---

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Buscar reportes...",
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
          borderSide: BorderSide.none,
        ),
      ),
      items: const [],
      onChanged: (_) {},
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Aprobado",
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<ReportRowUI> _sampleData() {
    return const [
      ReportRowUI(
        tipo: 'Vehículo',
        titulo: 'Inspección V-008',
        fecha: '2024-05-15',
      ),
      ReportRowUI(
        tipo: 'Prensa',
        titulo: 'Inspección P-002',
        fecha: '2024-05-12',
      ),
    ];
  }
}
