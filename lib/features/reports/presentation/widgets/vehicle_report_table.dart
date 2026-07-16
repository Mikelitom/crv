import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/vehicle_history_model.dart';

class VehicleReportTable extends StatelessWidget {
  final List<dynamic> reports;
  final bool isAdmin;

  const VehicleReportTable({
    super.key,
    required this.reports,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTable(
      columns: const [
        "PLATE", 
        "FOLIO", 
        "STATE", 
        "RESPONSIBLE", 
        "VERSION", 
        "DATE", 
        "ACTIONS"
      ],
      rows: reports.map((r) {
        // Validación de tipo segura
        final item = r is VehicleHistoryModel ? r : null;

        return DataRow(cells: [
          // PROTECCIÓN TOTAL: Todos los campos usan ?? 'N/A' o valores por defecto
          DataCell(Text(item?.plate ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(item?.folio ?? 'N/A')),
          DataCell(statusChip(item?.state ?? 'PENDING')), // Ya protegido en BaseTable
          DataCell(Text(item?.responsibleName ?? 'N/A')),
          DataCell(Text("V${item?.versionNumber ?? '0'}")),
          
          // PROTECCIÓN ESPECIAL PARA FECHAS:
          DataCell(Text(
            item?.inspectionDate != null 
              ? item!.inspectionDate.toString().split(' ')[0] 
              : 'Sin fecha'
          )),
          
          actionCell(item, isAdmin),
        ]);
      }).toList(),
    );
  }
}