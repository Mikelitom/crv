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

  String _translateStatus(String state) {
    switch (state.toUpperCase()) {
      case 'IN_REVISION':
      case 'EN REVISIÓN':
      case 'PENDING':
      case 'PENDIENTE':
        return 'En revisión';
      case 'COMPLETED':
      case 'COMPLETADO':
      case 'ACCEPTED':
      case 'ACEPTADO':
        return 'Aprobado';
      case 'REJECTED':
      case 'RECHAZADO':
        return 'Regresado';
      default:
        return 'Aprobado';
    }
  }

  @override
  Widget statusChip(String state) {
    final translated = _translateStatus(state);
    Color color = Colors.green;
    IconData icon = Icons.check_circle_outlined;

    if (translated == 'En revisión') {
      color = Colors.amber.shade700;
      icon = Icons.access_time_rounded;
    } else if (translated == 'Regresado') {
      color = Colors.purple;
      icon = Icons.keyboard_return;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            translated,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
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
            content: Text("Reporte aprobado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al aprobar: $e"),
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
            style: OutlinedButton.styleFrom(
              overlayColor: kPrimaryRed.withValues(alpha: 0.1),
            ),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            label: const Text("Aprobar"),
          ),
          FilledButton.icon(
            onPressed: () => _sendReviewNote(
              context,
              ref,
              item.versionId,
              noteController.text,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: kPrimaryRed,
              overlayColor: Colors.white.withValues(alpha: 0.2),
            ),
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

        final totalCount = filteredReports.length;
        final revisionCount = filteredReports
            .where((r) => _translateStatus((r as ConveyorHistoryModel).state) == 'En revisión')
            .length;
        final approvedCount = filteredReports
            .where((r) => _translateStatus((r as ConveyorHistoryModel).state) == 'Aprobado')
            .length;
        final returnedCount = filteredReports
            .where((r) => _translateStatus((r as ConveyorHistoryModel).state) == 'Regresado')
            .length;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contadores superiores adaptables (Grid en pantallas grandes, Wrap/Column en móvil)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: LayoutBuilder(
                    builder: (context, gridConstraints) {
                      if (gridConstraints.maxWidth < 600) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildHeaderCounterCard(
                                    title: "Total",
                                    value: "$totalCount",
                                    subtitle: "Registrados",
                                    icon: Icons.folder_open,
                                    color: kPrimaryRed,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildHeaderCounterCard(
                                    title: "En revisión",
                                    value: "$revisionCount",
                                    subtitle: "Pendientes",
                                    icon: Icons.access_time_rounded,
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildHeaderCounterCard(
                                    title: "Aprobados",
                                    value: "$approvedCount",
                                    subtitle: "Completados",
                                    icon: Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildHeaderCounterCard(
                                    title: "Regresados",
                                    value: "$returnedCount",
                                    subtitle: "Observaciones",
                                    icon: Icons.keyboard_return,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _buildHeaderCounterCard(
                              title: "Total",
                              value: "$totalCount",
                              subtitle: "Registrados",
                              icon: Icons.folder_open,
                              color: kPrimaryRed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildHeaderCounterCard(
                              title: "En revisión",
                              value: "$revisionCount",
                              subtitle: "Pendientes",
                              icon: Icons.access_time_rounded,
                              color: Colors.amber.shade800,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildHeaderCounterCard(
                              title: "Aprobados",
                              value: "$approvedCount",
                              subtitle: "Completados",
                              icon: Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildHeaderCounterCard(
                              title: "Regresados",
                              value: "$returnedCount",
                              subtitle: "Observaciones",
                              icon: Icons.keyboard_return,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (isMobile)
                  _buildMobileView(context, ref, filteredReports)
                else
                  BaseTable(
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
                      
                      final isInRevision = _translateStatus(item.state) == 'En revisión';

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
                                Expanded(
                                  child: Text(
                                    item.inspectorName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(item.inspectionDate.toString().split(' ')[0]),
                          ),
                          DataCell(statusChip(item.state)),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 22, color: Colors.grey),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              onSelected: (value) {
                                if (value == 'view') {
                                  _handleView(context, ref, item);
                                } else if (value == 'print') {
                                  _handlePrint(context, ref, item);
                                } else if (value == 'manage') {
                                  _showManagementDialog(context, ref, item);
                                } else if (value == 'approve') {
                                  _acceptReport(context, ref, item.reportId);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility, color: Colors.blue, size: 18),
                                      SizedBox(width: 8),
                                      Text('Ver PDF'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'print',
                                  child: Row(
                                    children: [
                                      Icon(Icons.print, color: kPrimaryRed, size: 18),
                                      SizedBox(width: 8),
                                      Text('Imprimir'),
                                    ],
                                  ),
                                ),
                                if (isAdmin) ...[
                                  const PopupMenuItem(
                                    value: 'manage',
                                    child: Row(
                                      children: [
                                        Icon(Icons.note_add, color: Colors.orange, size: 18),
                                        SizedBox(width: 8),
                                        Text('Gestionar / Notas'),
                                      ],
                                    ),
                                  ),
                                  if (isInRevision)
                                    const PopupMenuItem(
                                      value: 'approve',
                                      child: Row(
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.green, size: 18),
                                          SizedBox(width: 8),
                                          Text('Aprobar Reporte', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderCounterCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        final isInRevision = _translateStatus(item.state) == 'En revisión';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPrimaryRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings_input_component,
                      color: kPrimaryRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "REPORTE",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Banda v$versionText...",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Folio: ${item.folio}",
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "ESTADO",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      statusChip(item.state),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "INSPECTOR",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.inspectorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "FECHA",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateStr,
                        style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ACCIONES",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 22, color: Colors.grey),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    onSelected: (value) {
                      if (value == 'view') {
                        _handleView(context, ref, item);
                      } else if (value == 'print') {
                        _handlePrint(context, ref, item);
                      } else if (value == 'manage') {
                        _showManagementDialog(context, ref, item);
                      } else if (value == 'approve') {
                        _acceptReport(context, ref, item.reportId);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.blue, size: 18),
                            SizedBox(width: 8),
                            Text('Ver PDF'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'print',
                        child: Row(
                          children: [
                            Icon(Icons.print, color: kPrimaryRed, size: 18),
                            SizedBox(width: 8),
                            Text('Imprimir'),
                          ],
                        ),
                      ),
                      if (isAdmin) ...[
                        const PopupMenuItem(
                          value: 'manage',
                          child: Row(
                            children: [
                              Icon(Icons.note_add, color: Colors.orange, size: 18),
                              SizedBox(width: 8),
                              Text('Gestionar / Notas'),
                            ],
                          ),
                        ),
                        if (isInRevision)
                          const PopupMenuItem(
                            value: 'approve',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green, size: 18),
                                SizedBox(width: 8),
                                Text('Aprobar Reporte', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ],
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