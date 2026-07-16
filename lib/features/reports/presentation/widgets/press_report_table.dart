import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/press_history_model.dart';

class PressReportTable extends StatelessWidget {
  final List<dynamic> reports;
  final bool isAdmin;

  const PressReportTable({
    super.key, 
    required this.reports, 
    required this.isAdmin
  });

  @override
  Widget build(BuildContext context) {
    return BaseTable(
      columns: const ["SERIE", "TIPO", "FOLIO", "STATE", "FECHA", "AREA", "RESPONSABLE", "ACTIONS"],
      rows: reports.map((r) {
        // FORZAMOS a que 'r' sea Prensa. Si no lo es, 'item' será null.
        final item = r is PressHistoryModel ? r : null;

        return DataRow(cells: [
          DataCell(Text(item?.serie ?? 'N/A')),         // <-- Aquí está 'serie'
          DataCell(Text(item?.type ?? 'N/A')),
          DataCell(Text(item?.folio ?? 'N/A')),
          DataCell(statusChip(item?.state ?? 'PENDING')),
          DataCell(Text(item?.inspectionDate?.toString().split(' ')[0] ?? 'N/A')),
          DataCell(Text(item?.area ?? 'N/A')),
          DataCell(Text(item?.responsibleName ?? 'N/A')),
          actionCell(item, isAdmin),
        ]);
      }).toList(),
    );
  }
}