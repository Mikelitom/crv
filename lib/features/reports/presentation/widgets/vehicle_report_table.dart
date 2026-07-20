import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/servicios/presentation/utils/pdf_report_processor.dart';
import 'package:crv_reprosisa/features/reports/presentation/widgets/base_report_table.dart';
import 'package:crv_reprosisa/features/reports/data/models/vehicle_history_model.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/client_pdf_viewer_page.dart';
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

  String _translateStatus(String state) {
    switch (state.toUpperCase()) {
      case 'PENDING':
      case 'PENDIENTE':
        return 'Pendiente';
      case 'COMPLETED':
      case 'COMPLETADO':
        return 'Completado';
      case 'ACCEPTED':
      case 'ACEPTADO':
        return 'Aprobado';
      case 'REJECTED':
      case 'RECHAZADO':
        return 'Regresado';
      case 'IN_REVISION':
      case 'EN REVISIÓN':
        return 'En revisión';
      case 'IN_PROGRESS':
      case 'EN PROGRESO':
        return 'En progreso';
      default:
        return 'Aprobado';
    }
  }

  Widget statusChip(String state) {
    final translated = _translateStatus(state);
    Color color = Colors.green;
    IconData icon = Icons.check_circle_outlined;

    if (translated == 'En revisión' || translated == 'Pendiente') {
      color = Colors.amber.shade700;
      icon = Icons.access_time_rounded;
    } else if (translated == 'Regresado') {
      color = Colors.purple;
      icon = Icons.keyboard_return;
    } else if (translated == 'En progreso') {
      color = Colors.blue;
      icon = Icons.sync;
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final filteredReports = reports
            .where((r) => r is VehicleHistoryModel)
            .toList();

        final totalCount = filteredReports.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contador compacto estilo tarjeta cuadrada idéntico a los demás
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SizedBox(
                width: 260,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPrimaryRed.withValues(alpha: 0.2)),
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
                          color: kPrimaryRed.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.folder_open, color: kPrimaryRed, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total de Reportes",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "$totalCount",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: kPrimaryRed,
                              ),
                            ),
                            const Text(
                              "Registrados",
                              style: TextStyle(
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
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  return _buildMobileView(context, ref, filteredReports);
                }

                return BaseTable(
                  columns: const [
                    "VEHÍCULO",
                    "RESPONSABLE",
                    "FECHA",
                    "ESTADO",
                    "ACCIONES",
                  ],
                  rows: filteredReports.map((r) {
                    final item = r as VehicleHistoryModel;

                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 180,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.directions_car,
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
                                        "Placa: ${item.plate}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Folio: ${item.folio} (v${item.versionNumber})",
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
                                  item.responsibleName,
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
                              if (isAdmin)
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
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        );
      },
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
        final item = filteredReports[index] as VehicleHistoryModel;
        final dateStr = item.inspectionDate.toString().split(' ')[0];

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
                      Icons.directions_car,
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
                          "VEHÍCULO",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Placa: ${item.plate}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Folio: ${item.folio} (v${item.versionNumber})",
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
                          "RESPONSABLE",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.responsibleName,
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
                      if (isAdmin)
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
          builder: (_) => ClientPdfViewerPage(
            folio: item.folio,
            pdfGenerator: () async => data,
          ),
        ),
      );
    }
  }

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