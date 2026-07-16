import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/conveyor_history_model.dart';
// Importamos el mixin de acciones y el provider del notifier
import 'package:crv_reprosisa/core/utils/report_action_handler.dart'; 
import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';

class ConveyorReportTable extends StatelessWidget with ReportActionHandler {
  final List<dynamic> reports;
  final bool isAdmin;

  const ConveyorReportTable({
    super.key, 
    required this.reports, 
    required this.isAdmin
  });

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para acceder a ref
    return Consumer(builder: (context, ref, _) {
      return BaseTable(
        columns: const [
          "CLIENTE", 
          "MINA", 
          "FOLIO", 
          "STATE", 
          "FECHA", 
          "INSPECTOR", 
          "ACTIONS"
        ],
        rows: reports.map((r) {
          final item = r is ConveyorHistoryModel ? r : null;

          return DataRow(cells: [
            DataCell(Text(item?.clientCompany ?? 'N/A')),
            DataCell(Text(item?.mineName ?? 'N/A')),
            DataCell(Text(item?.folio ?? 'N/A')),
            DataCell(statusChip(item?.state ?? 'PENDING')),
            DataCell(Text(item?.inspectionDate?.toString().split(' ')[0] ?? 'N/A')),
            DataCell(Text(item?.inspectorName ?? 'N/A')),
            
            // Aquí usamos nuestra función actionCell modificada 
            // que ahora recibe los callbacks onView y onPrint
            actionCell(
              item, 
              isAdmin, 
              onView: () => handlePdfAction(context, ref, item, false),
              onPrint: () => handlePdfAction(context, ref, item, true),
            ),
          ]);
        }).toList(),
      );
    });
  }
}