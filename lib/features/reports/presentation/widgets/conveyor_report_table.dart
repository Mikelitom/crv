import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/reports/data/models/conveyor_history_model.dart';
import 'package:crv_reprosisa/core/utils/report_action_handler.dart';
import 'package:crv_reprosisa/core/utils/conveyor_pdf_processor.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/client_pdf_viewer_page.dart';
import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';

const Color kPrimaryRed = Color(0xFFC62828);

class ConveyorReportTable extends ConsumerWidget with ReportActionHandler {
  final List<dynamic> reports;
  final bool isAdmin;

  const ConveyorReportTable({
    super.key,
    required this.reports,
    required this.isAdmin,
  });

  Future<void> _sendReviewNote(
    BuildContext context,
    WidgetRef ref,
    String versionId,
    String notes,
  ) async {
    if (notes.isEmpty) return;
    try {
      // Se envía el versionId completo para evitar el error 404
      await ref.read(sendConveyorNoteUseCaseProvider).call(versionId, notes);
      await ref.read(reportsNotifierProvider.notifier).loadAllReports();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nota enviada correctamente"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: kPrimaryRed),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) return _buildMobileView(context, ref);
        return _buildDesktopView(context, ref, constraints);
      },
    );
  }

  Widget _buildDesktopView(
    BuildContext context,
    WidgetRef ref,
    BoxConstraints constraints,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text("REPORTE")),
          DataColumn(label: Text("INSPECTOR")),
          DataColumn(label: Text("FECHA")),
          DataColumn(label: Text("ESTADO")),
          DataColumn(label: Text("ACCIONES")),
        ],
        rows: reports.map((r) {
          final item = r as ConveyorHistoryModel;
          return DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 180, // Límite de ancho para evitar el overflow
                  child: Row(
                    children: [
                      const Icon(
                        Icons.settings_input_component,
                        color: kPrimaryRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Truncado visual: mostramos solo los primeros 8 caracteres
                            Text(
                              "Banda v${item.versionId.substring(0, 8)}...",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Folio: ${item.folio}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(item.inspectorName),
                  ],
                ),
              ),
              DataCell(Text(item.inspectionDate.toString().split(' ')[0])),
              DataCell(_statusChip(item.state)),
              DataCell(_actionMenu(context, ref, item)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileView(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, i) {
        final item = reports[i] as ConveyorHistoryModel;
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.settings_input_component,
              color: kPrimaryRed,
            ),
            title: Text(
              "Banda v${item.versionId.substring(0, 8)}...",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Folio: ${item.folio} • ${item.state}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showManagementDialog(context, ref, item),
          ),
        );
      },
    );
  }

  Future<void> _acceptReport(
    BuildContext context,
    WidgetRef ref,
    String reportId,
  ) async {
    try {
      // Asegúrate de usar el provider que inyecta tu servicio de aceptación
      await ref.read(reportsNotifierProvider.notifier).acceptReport(reportId);
      await ref.read(reportsNotifierProvider.notifier).loadAllReports();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reporte aceptado y completado"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Cierra el diálogo si se llama desde ahí
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al aceptar: $e"),
            backgroundColor: kPrimaryRed,
          ),
        );
      }
    }
  }

  Widget _statusChip(String? state) {
    final statusMap = {
      'IN_PROGRESS': 'EN PROCESO',
      'COMPLETED': 'COMPLETADO',
      'IN_REVISION': 'PENDIENTE DE REVISION',
      'RETURNED': 'DEVUELTO',
    };
    final label = statusMap[(state ?? 'PENDING').toUpperCase()] ?? 'PENDIENTE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _showManagementDialog(
    BuildContext context,
    WidgetRef ref,
    ConveyorHistoryModel item,
  ) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Gestionar Reporte",
          style: TextStyle(color: kPrimaryRed, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: "Nueva observación",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
          OutlinedButton.icon(
            onPressed: () => _acceptReport(context, ref, item.reportId),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            label: const Text("Aceptar"),
          ),
          FilledButton.icon(
            onPressed: () => _sendReviewNote(
              context,
              ref,
              item.versionId,
              noteController.text,
            ),
            style: FilledButton.styleFrom(backgroundColor: kPrimaryRed),
            icon: const Icon(Icons.send),
            label: const Text("Enviar"),
          ),
        ],
      ),
    );
  }

  Widget _actionMenu(
    BuildContext context,
    WidgetRef ref,
    ConveyorHistoryModel item,
  ) => PopupMenuButton<String>(
    onSelected: (val) {
      if (val == 'view') {
        _handleView(context, ref, item);
      } else if (val == 'manage') {
        _showManagementDialog(context, ref, item);
      } else if (val == 'accept') {
        _acceptReport(context, ref, item.reportId);
      }
    },
    itemBuilder: (_) => [
      const PopupMenuItem(
        value: 'view',
        child: ListTile(
          dense: true,
          leading: Icon(Icons.picture_as_pdf, color: kPrimaryRed),
          title: Text("Ver PDF"),
        ),
      ),
      const PopupMenuItem(
        value: 'manage',
        child: ListTile(
          dense: true,
          leading: Icon(Icons.comment, color: Colors.grey),
          title: Text("Evaluar / Notas"),
        ),
      ),
      const PopupMenuItem(
        value: 'accept',
        child: ListTile(
          dense: true,
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text("Aceptar Reporte"),
        ),
      ),
    ],
  );

  Future<void> _handleView(
    BuildContext context,
    WidgetRef ref,
    ConveyorHistoryModel item,
  ) async {
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
  }
}
