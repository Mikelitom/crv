import 'package:flutter/material.dart';

class CatalogDataTable extends StatelessWidget {
  final List<dynamic> items;
  final String type;
  final Function(dynamic) onDetailsPressed;
  final Color primaryRed;

  const CatalogDataTable({
    super.key,
    required this.items,
    required this.type,
    required this.onDetailsPressed,
    required this.primaryRed,
  });

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4B5563), fontSize: 11, letterSpacing: 0.5);
    final cellStyle = TextStyle(color: Colors.blueGrey.shade900, fontSize: 13, fontWeight: FontWeight.w500);

    List<DataColumn> columns = [];
    
    // Configuración de columnas ordenada de acuerdo al flujo oficial
    if (type == "vehiculo") {
      columns = const [
        DataColumn(label: Text("PLACA", style: headerStyle)),
        DataColumn(label: Text("MARCA / MODELO", style: headerStyle)),
        DataColumn(label: Text("AÑO", style: headerStyle)),
        DataColumn(label: Text("ESTADO OPERATIVO", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else if (type == "cliente") {
      columns = const [
        DataColumn(label: Text("NOMBRE", style: headerStyle)),
        DataColumn(label: Text("COMPAÑÍA", style: headerStyle)),
        DataColumn(label: Text("RFC SAT", style: headerStyle)),
        DataColumn(label: Text("TELÉFONO", style: headerStyle)),
        DataColumn(label: Text("EMAIL", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else {
      columns = const [
        DataColumn(label: Text("TAMAÑO", style: headerStyle)),
        DataColumn(label: Text("TIPO / MODELO", style: headerStyle)),
        DataColumn(label: Text("SERIE", style: headerStyle)),
        DataColumn(label: Text("ESTADO OPERATIVO", style: headerStyle)),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    }

    return SizedBox(
      width: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.grey.withOpacity(0.08)),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
          dataRowMaxHeight: 68,
          headingRowHeight: 52,
          horizontalMargin: 24,
          columnSpacing: 16,
          showCheckboxColumn: false,
          columns: columns,
          rows: items.map((item) {
            return DataRow(
              cells: [
                if (type == "vehiculo") ...[
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFE9F0F7), borderRadius: BorderRadius.circular(6)),
                      child: Text(item.plate ?? "-", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF2C3E50))),
                    ),
                  ),
                  DataCell(Text("${item.brand ?? '-'} ${item.model ?? '-'}", style: cellStyle)),
                  DataCell(Text(item.year?.toString() ?? "-", style: cellStyle)),
                  DataCell(_buildStatusBadge(item.toString().contains('estado') ? item.estado : "Disponible")),
                ] else if (type == "cliente") ...[
                  DataCell(Text(item.name ?? "-", style: cellStyle.copyWith(fontWeight: FontWeight.w700))),
                  DataCell(Text(item.company ?? "-", style: cellStyle)),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                      child: Text(item.toString().contains('rfc') && item.rfc != null ? item.rfc : "SIN RFC", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF475569))),
                    ),
                  ),
                  DataCell(Text(item.phone ?? "-", style: cellStyle)),
                  DataCell(Text(item.email ?? "-", style: cellStyle)),
                ] else ...[
                  DataCell(Text(item.size ?? "-", style: cellStyle)),
                  DataCell(Text("${item.type ?? '-'} / ${item.model ?? '-'}", style: cellStyle)),
                  DataCell(Text(item.serie ?? "-", style: cellStyle.copyWith(fontWeight: FontWeight.w700))),
                  DataCell(_buildStatusBadge(item.toString().contains('estado') ? item.estado : "Pendiente")),
                ],
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (type != "cliente") ...[
                        _buildActionButton(Icons.visibility_rounded, const Color(0xFFE8F5E9), Colors.green.shade700, () => onDetailsPressed(item)),
                        const SizedBox(width: 8),
                      ],
                      _buildActionButton(Icons.edit_rounded, const Color(0xFFE3F2FD), const Color(0xFF2196F3), () {}),
                      const SizedBox(width: 8),
                      _buildActionButton(Icons.delete_rounded, const Color(0xFFFFEBEE), primaryRed, () {}),
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

    switch (status) {
      case "Disponible":
      case "En Curso":
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case "En Uso":
      case "Pendiente":
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        break;
      case "En Taller":
      case "En Mantenimiento":
      case "Atrasado":
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFEF6C00);
        break;
      default:
        bgColor = const Color(0xFFF5F5F5);
        textColor = const Color(0xFF616161);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.3),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: iconColor, size: 16),
      ),
    );
  }
}