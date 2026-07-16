import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

// Modelos y Utils
import 'package:crv_reprosisa/features/reports/data/models/conveyor_history_model.dart';
import 'package:crv_reprosisa/core/utils/report_action_handler.dart'; 
import 'package:crv_reprosisa/core/utils/conveyor_pdf_processor.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/client_pdf_viewer_page.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';

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
            
            actionCell(
              item, 
              isAdmin, 
              // Lógica de Visualización
              onView: () async {
                if (item == null) return;
                final pdfData = await ConveyorPdfProcessor.getPdfData(ref, item.versionId);
                
                if (pdfData != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientPdfViewerPage(
                        folio: item.folio,
                        pdfGenerator: () => BandaPdfGenerator.generateReport(
                          pdfData.datosNormalizados,
                          pdfData.sections,
                          pdfData.rodillos,
                        ),
                      ),
                    ),
                  );
                }
              },
              // Lógica de Impresión/Descarga
              onPrint: () async {
                if (item == null) return;
                final pdfBytes = await ConveyorPdfProcessor.generatePdfFromVersionId(ref, item.versionId);
                
                if (pdfBytes != null) {
                  await Printing.sharePdf(
                    bytes: pdfBytes,
                    filename: 'Reporte_${item.folio}.pdf',
                  );
                }
              },
            ),
          ]);
        }).toList(),
      );
    });
  }
}