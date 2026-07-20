import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/reports/data/models/conveyor_history_model.dart';
import 'package:crv_reprosisa/core/utils/report_action_handler.dart';
import 'package:crv_reprosisa/core/utils/conveyor_pdf_processor.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/client_pdf_viewer_page.dart';
import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:printing/printing.dart';

const Color kPrimaryRed = Color(0xFFC62828);

class ConveyorReportTable extends StatelessWidget with ReportActionHandler {
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: kPrimaryRed),
        );
      }
    }
  }

  Future<void> _acceptReport(
    BuildContext context,
    WidgetRef ref,
    String reportId,
  ) async {
    try {
      await ref.read(reportsNotifierProvider.notifier).acceptReport(reportId);
      await ref.read(reportsNotifierProvider.notifier).loadAllReports();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reporte aceptado y completado"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final filteredReports = reports
            .where((r) => r is ConveyorHistoryModel)
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            // Si el ancho es menor a 800px, mostramos la vista móvil de tarjetas desplegables
            if (constraints.maxWidth < 800) {
              return _buildMobileView(context, ref, filteredReports);
            }

            // De lo contrario, mostramos la tabla de escritorio optimizada
            return BaseTable(
              columns: const [
                "REPORTE",
                "INSPECTOR",
                "FECHA",
                "ESTADO",
                "ACCIONES",
              ],
              rows: filteredReports.map((r) {
                final item = r as ConveyorHistoryModel;
                final versionText = item.versionId.length >= 8
                    ? item.versionId.substring(0, 8)
                    : item.versionId;

                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 180,
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
                                  Text(
                                    "Banda v$versionText...",
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
                    DataCell(
                      Text(item.inspectionDate.toString().split(' ')[0]),
                    ),
                    DataCell(statusChip(item.state)),
                    actionCell(
                      item,
                      isAdmin,
                      onView: () async => _handleView(context, ref, item),
                      onPrint: () async => _handlePrint(context, ref, item),
                      onEdit: isAdmin
                          ? () => _showManagementDialog(context, ref, item)
                          : null,
                    ),
                  ],
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  // Vista Móvil tipo Acordeón/Expansible
  Widget _buildMobileView(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> filteredReports,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        final item = filteredReports[index] as ConveyorHistoryModel;
        final versionText = item.versionId.length >= 8
            ? item.versionId.substring(0, 8)
            : item.versionId;
        final dateStr = item.inspectionDate.toString().split(' ')[0];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ExpansionTile(
            shape: const Border(), // Evita bordes adicionales al abrirse
            leading: const Icon(
              Icons.settings_input_component,
              color: kPrimaryRed,
            ),
            title: Text(
              "Banda v$versionText...",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  "Folio: ${item.folio}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  "Fecha: $dateStr",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            children: [
              // ... dentro de _buildMobileView, en la sección de children del ExpansionTile:
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          "Inspector: ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        // Expanded evita el overflow si el nombre es muy largo
                        Expanded(
                          child: Text(
                            item.inspectorName,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis, // Opcional: recorta con "..." si es larguísimo
                            maxLines: 2, // Permite hasta 2 líneas si quieres que baje automáticamente
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "Estado: ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        statusChip(item.state),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Acciones",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () => _handleView(context, ref, item),
                          tooltip: 'Ver PDF',
                        ),
                        if (isAdmin) ...[
                          IconButton(
                            icon: const Icon(Icons.print, color: Colors.red),
                            onPressed: () => _handlePrint(context, ref, item),
                            tooltip: 'Imprimir',
                          ),
                          IconButton(
                            icon: const Icon(Icons.note_add, color: Colors.orange),
                            onPressed: () => _showManagementDialog(context, ref, item),
                            tooltip: 'Gestionar / Notas',
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Funciones auxiliares para evitar duplicar lógica de PDF
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

  Future<void> _handlePrint(
    BuildContext context,
    WidgetRef ref,
    ConveyorHistoryModel item,
  ) async {
    final pdfData = await ConveyorPdfProcessor.getPdfData(ref, item.versionId);
    if (pdfData != null) {
      final pdfBytes = await BandaPdfGenerator.generateReport(
        pdfData.datosNormalizados,
        pdfData.sections,
        pdfData.rodillos,
      );
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    }
  }
}
