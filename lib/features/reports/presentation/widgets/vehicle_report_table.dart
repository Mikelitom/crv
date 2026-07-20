import 'package:crv_reprosisa/features/servicios/presentation/utils/pdf_report_processor.dart';
import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/vehicle_history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

const Color kPrimaryRed = Color(0xFFC62828);

class VehicleReportTable extends StatelessWidget {
  final List<dynamic> reports;
  final bool isAdmin;

  const VehicleReportTable({
    super.key,
    required this.reports,
    required this.isAdmin,
  });

  // Traducción completa de estados al español para vehículos (incluyendo IN_PROGRESS)
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
      case 'IN_PROGRESS':
      case 'EN PROGRESO':
        return 'EN PROGRESO';
      default:
        return state.toUpperCase();
    }
  }

  // Chip de estado traducido y con colores correctos
  Widget statusChip(String state) {
    final translated = _translateStatus(state);
    Color color = Colors.grey;

    if (translated.contains('COMPLETADO') || translated.contains('ACEPTADO')) {
      color = Colors.green;
    } else if (translated.contains('REVISIÓN') || translated.contains('PENDIENTE')) {
      color = Colors.amber.shade700;
    } else if (translated.contains('PROGRESO')) {
      color = Colors.blue;
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
            .where((r) => r is VehicleHistoryModel)
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            // Si el ancho es menor a 800px, mostramos la vista móvil de tarjetas desplegables
            if (constraints.maxWidth < 800) {
              return _buildMobileView(context, ref, filteredReports);
            }

            // De lo contrario, mostramos la tabla de escritorio normal
            return BaseTable(
              columns: const [
                "PLACA",
                "FOLIO",
                "ESTADO",
                "RESPONSABLE",
                "VERSIÓN",
                "FECHA",
                "ACCIONES",
              ],
              rows: filteredReports.map((r) {
                final item = r as VehicleHistoryModel;

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item.plate,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text(item.folio)),
                    DataCell(statusChip(item.state)),
                    DataCell(Text(item.responsibleName)),
                    DataCell(Text("V${item.versionNumber}")),
                    DataCell(
                      Text(item.inspectionDate.toString().split(' ')[0]),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.blue,
                              size: 20,
                            ),
                            onPressed: () async =>
                                _handleView(context, ref, item),
                            tooltip: 'Ver PDF',
                          ),
                          if (isAdmin)
                            IconButton(
                              icon: const Icon(
                                Icons.print,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () async =>
                                  _handlePrint(context, ref, item),
                              tooltip: 'Imprimir',
                            ),
                        ],
                      ),
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

  // Vista Móvil tipo Acordeón/Expansible para Vehículos
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
        final item = filteredReports[index] as VehicleHistoryModel;
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
            leading: const Icon(Icons.directions_car, color: Colors.blueGrey),
            title: Text(
              "Placa: ${item.plate}",
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
                          "Responsable: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.responsibleName,
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
                          "Versión: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "V${item.versionNumber}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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

  // Lógica centralizada para la vista previa del PDF
  Future<void> _handleView(
    BuildContext context,
    WidgetRef ref,
    VehicleHistoryModel item,
  ) async {
    final data = await PdfReportProcessor.generatePdfFromVersionId(
      ref,
      item.versionId,
    );

    if (data == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo generar la vista previa")),
        );
      }
      return;
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Vista Previa PDF")),
            body: PdfPreview(build: (format) => data),
          ),
        ),
      );
    }
  }

  // Lógica centralizada para imprimir de forma directa
  Future<void> _handlePrint(
    BuildContext context,
    WidgetRef ref,
    VehicleHistoryModel item,
  ) async {
    final data = await PdfReportProcessor.generatePdfFromVersionId(
      ref,
      item.versionId,
    );

    if (data != null) {
      await Printing.layoutPdf(onLayout: (_) async => data);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se pudo generar el documento para impresión"),
          ),
        );
      }
    }
  }
}