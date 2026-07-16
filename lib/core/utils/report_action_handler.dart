import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:crv_reprosisa/core/utils/loading_overlay.dart';

mixin ReportActionHandler {
  Future<void> handlePdfAction(BuildContext context, WidgetRef ref, dynamic item, bool isPrint) async {
    LoadingOverlay.show(context, "Generando PDF...");
    final bytes = await ref.read(reportsNotifierProvider.notifier).generatePdfForReport(item);
    if (context.mounted) LoadingOverlay.hide(context);

    if (bytes != null) {
      if (isPrint) {
        await Printing.sharePdf(bytes: bytes, filename: 'Reporte_${item.folio}.pdf');
      } else {
        if (!context.mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("Vista Previa")),
          body: PdfPreview(build: (_) => bytes),
        )));
      }
    } else {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al generar PDF")));
    }
  }
}