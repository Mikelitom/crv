import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'package:crv_reprosisa/core/utils/press_pdf_processor.dart';
import 'package:crv_reprosisa/core/utils/report_action_handler.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/press_history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

class PressReportTable extends StatelessWidget with ReportActionHandler {
  final List<dynamic> reports;
  final bool isAdmin;

  const PressReportTable({
    super.key, 
    required this.reports, 
    required this.isAdmin
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return BaseTable(
        columns: const ["SERIE", "FOLIO", "STATE", "FECHA", "ACTIONS"],
        rows: reports.map((r) {
          // Intentamos castear a nuestro modelo esperado
          final item = r is PressHistoryModel ? r : null;

          return DataRow(cells: [
            DataCell(Text(item?.serie ?? 'N/A')),
            DataCell(Text(item?.folio ?? 'N/A')),
            DataCell(statusChip(item?.state ?? 'PENDING')),
            DataCell(Text(item?.inspectionDate.toString().split(' ')[0] ?? 'N/A')),
            
            // Usamos el handler estandarizado para las acciones
            actionCell(
              item, 
              isAdmin, 
              onView: () async {
                // Validación de seguridad para el null safety
                if (item == null) return;

                final data = await PressPdfProcessor.generatePdfFromVersionId(ref, item.versionId);
                
                if (data != null && context.mounted) {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => PdfViewerPage(datos: data))
                  );
                }
              },
              onPrint: () async {
                // Validación de seguridad para el null safety
                if (item == null) return;

                final data = await PressPdfProcessor.generatePdfFromVersionId(ref, item.versionId);
                
                if (data != null) {
                  // Generación del PDF físico usando tu clase generadora
                  final pdfBytes = await PrensaPdfGenerator.generateEsqueleto(data);
                  await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
                }
              },
            ),
          ]);
        }).toList(),
      );
    });
  }
}