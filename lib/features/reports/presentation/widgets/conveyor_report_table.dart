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

  // Traducción completa de estados al español
  String _translateStatus(String state) {
    switch (state.toUpperCase()) {
      case 'PENDING':
      case 'PENDIENTE':
        return 'PENDIENTE';
      case 'COMPLETED':
      case 'COMPLETADO':
        return 'COMPLETADO';
      case 'ACCEPTED':
      case 'ACEPTADO':
        return 'ACEPTADO';
      case 'REJECTED':
      case 'RECHAZADO':
        return 'RECHAZADO';
      case 'IN_REVISION':
      case 'EN REVISIÓN':
        return 'EN REVISIÓN';
      default:
        return state.toUpperCase();
    }
  }

  // Chip de estado traducido y con colores correctos (Verde para completado/aceptado, Ámbar para revisión/pendiente, Rojo para rechazado)
  Widget statusChip(String state) {
    final translated = _translateStatus(state);
    Color color = Colors.grey;

    if (translated.contains('COMPLETADO') || translated.contains('ACEPTADO')) {
      color = Colors.green;
    } else if (translated.contains('REVISIÓN') || translated.contains('PENDIENTE')) {
      color = Colors.amber.shade700;
    } else if (translated.contains('RECHAZADO')) {
      color = kPrimaryRed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        translated,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

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

  void _showManagementDialog(
    BuildContext context,
    WidgetRef ref,
    ConveyorHistoryModel item,
  ) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
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
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryRed, width: 2),
                  ),
                  prefixIcon: Icon(Icons.note_alt_outlined, color: kPrimaryRed),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar", style: TextStyle(color: Colors.grey)),
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
            if (constraints.maxWidth < 800) {
              return _buildMobileView(context, ref, filteredReports);
            }

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
            shape: const Border(),
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
                        Expanded(
                          child: Text(
                            item.inspectorName,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
                            icon: const Icon(Icons.print, color: kPrimaryRed),
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