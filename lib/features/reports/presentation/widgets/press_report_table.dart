import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'package:crv_reprosisa/core/utils/press_pdf_processor.dart';
import 'package:crv_reprosisa/core/utils/report_action_handler.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/press_history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

const Color kPrimaryRed = Color(0xFFC62828);

class PressReportTable extends StatelessWidget with ReportActionHandler {
  final List<dynamic> reports;
  final bool isAdmin;

  const PressReportTable({
    super.key,
    required this.reports,
    required this.isAdmin,
  });

  // Traducción completa de estados al español para prensas
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

  Widget statusChip(String state) {
    final translated = _translateStatus(state);
    Color color = Colors.grey;

    if (translated.contains('COMPLETADO') || translated.contains('ACEPTADO')) {
      color = Colors.green;
    } else if (translated.contains('REVISIÓN') ||
        translated.contains('PENDIENTE')) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final filteredReports = reports
            .where((r) => r is PressHistoryModel)
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            // Si el ancho es menor a 800px, mostramos la vista móvil de tarjetas desplegables
            if (constraints.maxWidth < 800) {
              return _buildMobileView(context, ref, filteredReports);
            }

            // De lo contrario, mostramos la tabla de escritorio normal
            return BaseTable(
              columns: const ["SERIE", "FOLIO", "ESTADO", "FECHA", "ACCIONES"],
              rows: filteredReports.map((r) {
                final item = r as PressHistoryModel;

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.serie,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text(item.folio)),
                    DataCell(statusChip(item.state)),
                    DataCell(
                      Text(item.inspectionDate.toString().split(' ')[0]),
                    ),
                    actionCell(
                      item,
                      isAdmin,
                      onView: () async => _handleView(context, ref, item),
                      onPrint: () async => _handlePrint(context, ref, item),
                      onEdit: null, // Omitimos notas/gestión en prensas
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

  // Vista Móvil tipo Acordeón/Expansible para Prensas
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
        final item = filteredReports[index] as PressHistoryModel;
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
              Icons.precision_manufacturing,
              color: Colors.orange,
            ),
            title: Text(
              "Serie: ${item.serie}",
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
                          "Estado: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.blue,
                          ),
                          onPressed: () async =>
                              _handleView(context, ref, item),
                          tooltip: 'Ver PDF',
                        ),
                        IconButton(
                          icon: const Icon(Icons.print, color: Colors.red),
                          onPressed: () async =>
                              _handlePrint(context, ref, item),
                          tooltip: 'Imprimir',
                        ),
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

  // Lógica centralizada para la vista previa del PDF en Prensas
  Future<void> _handleView(
    BuildContext context,
    WidgetRef ref,
    PressHistoryModel item,
  ) async {
    final data = await PressPdfProcessor.generatePdfFromVersionId(
      ref,
      item.versionId,
    );

    if (data != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PdfViewerPage(datos: data)),
      );
    }
  }

  // Lógica centralizada para imprimir de forma directa en Prensas
  Future<void> _handlePrint(
    BuildContext context,
    WidgetRef ref,
    PressHistoryModel item,
  ) async {
    final data = await PressPdfProcessor.generatePdfFromVersionId(
      ref,
      item.versionId,
    );

    if (data != null) {
      final pdfBytes = await PrensaPdfGenerator.generateEsqueleto(data);
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    }
  }
}
