import 'package:flutter/material.dart';
import 'asset_detail_modal.dart';

class CatalogDataTable extends StatelessWidget {
  final List<dynamic> items;
  final String type;
  final Color primaryRed;
  

  const CatalogDataTable({
    super.key,
    required this.items,
    required this.type,
    required this.primaryRed,
  });

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF374151), fontSize: 12, letterSpacing: 0.5);
    final cellStyle = TextStyle(color: Colors.blueGrey.shade900, fontSize: 13, fontWeight: FontWeight.w600);

    List<DataColumn> columns = [];
    if (type == "cliente") {
      columns = const [
        DataColumn(label: Text("NOMBRE", style: headerStyle)),
        DataColumn(label: Text("COMPAÑÍA", style: headerStyle)),
        DataColumn(label: Text("E-MAIL", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else if (type == "vehiculo") {
      columns = const [
        DataColumn(label: Text("PLACA", style: headerStyle)),
        DataColumn(label: Text("MARCA / MODELO", style: headerStyle)),
        DataColumn(label: Text("AÑO", style: headerStyle)),
        DataColumn(label: Text("ESTADO OPERATIVO", style: headerStyle)),
        DataColumn(label: Text("UBICACIÓN", style: headerStyle)),
        // RESPONSABLE ELIMINADO AQUÍ
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else {
      columns = const [
        DataColumn(label: Text("SERIE", style: headerStyle)),
        DataColumn(label: Text("TAMAÑO", style: headerStyle)),
        DataColumn(label: Text("TIPO", style: headerStyle)),
        DataColumn(label: Text("MODELO", style: headerStyle)),
        DataColumn(label: Text("ESTADO OPERATIVO", style: headerStyle)),
        DataColumn(label: Text("UBICACIÓN", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    }

    return SizedBox(
      width: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.grey.withOpacity(0.08)),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
          dataRowMaxHeight: 64,
          headingRowHeight: 52,
          horizontalMargin: 24,
          columnSpacing: 16,
          showCheckboxColumn: false,
          columns: columns,
          rows: items.map((item) {
            final String state = (type == "vehiculo") ? (item.operationState ?? 'Disponible') : '';
            final String pressType = type == "prensa" ? (item.type ?? 'Mechanical') : '';
            final bool isFija = pressType.toLowerCase().contains('hydrau') || pressType.toLowerCase().contains('fija');

            return DataRow(
              cells: [
                if (type == "cliente") ...[
                  DataCell(Text(item.name ?? "-", style: cellStyle.copyWith(color: const Color(0xFF111827)))),
                  DataCell(Text(item.company ?? "-", style: cellStyle)),
                  DataCell(Text(item.email ?? "-", style: cellStyle)),
                  // DataCell(Text(item.toString().contains('mines') && item.mines != null ? "Minas vinculadas" : "0 Minas", style: cellStyle.copyWith(color: primaryRed))),
                ] else if (type == "vehiculo") ...[
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(6)),
                      child: Text(item.plate ?? "-", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: primaryRed, letterSpacing: 0.5)),
                    ),
                  ),
                  DataCell(Text("${item.brand ?? '-'} ${item.model ?? '-'}", style: cellStyle)),
                  DataCell(Text(item.year?.toString() ?? "-", style: cellStyle)),
                  DataCell(_buildStatusBadge(state)),
                  DataCell(Text(item.currentLocation ?? "-", style: cellStyle)),
                  // RESPONSABLE ELIMINADO AQUÍ
                ] else ...[
                  DataCell(Text(item.serie ?? "-", style: cellStyle.copyWith(color: primaryRed, fontWeight: FontWeight.w800))),
                  DataCell(Text(item.size ?? "-", style: cellStyle)),
                  DataCell(Text(isFija ? "Hidráulica (Fija)" : "Mecánica (Móvil)", style: cellStyle)),
                  DataCell(Text(isFija ? "-" : (item.model ?? "-"), style: cellStyle)),
                  DataCell(_buildStatusBadge(item.operationState ?? 'Disponible')),
                  DataCell(Text(item.currentLocation ?? "-", style: cellStyle)),
                ],
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(Icons.visibility_rounded, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), () {
                        showDialog(
                          context: context,
                          builder: (context) => AssetDetailModal(item: item, type: type, primaryRed: primaryRed),
                        );
                      }),
                      const SizedBox(width: 8),
                      _buildActionButton(Icons.edit_rounded, const Color(0xFFE3F2FD), const Color(0xFF2196F3), () {}),
                      const SizedBox(width: 8),
                      _buildActionButton(Icons.block_rounded, const Color(0xFFFFEBEE), primaryRed, () {}),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    if (status == "Disponible") {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
    } else if (status == "Estado operativo" || status == "Operativo" || status == "En Uso") {
      bgColor = const Color(0xFFE3F2FD);
      textColor = const Color(0xFF1565C0);
    } else {
      bgColor = const Color(0xFFFFF3E0);
      textColor = const Color(0xFFEF6C00);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildActionButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(height: 32, width: 32, decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 16)),
    );
  }
}