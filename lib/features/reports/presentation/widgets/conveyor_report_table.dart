import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/reports/data/models/conveyor_history_model.dart';
import 'package:crv_reprosisa/core/utils/report_action_handler.dart'; 
import 'package:crv_reprosisa/core/utils/conveyor_pdf_processor.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/client_pdf_viewer_page.dart';

// Helper de estados unificado
Widget statusChip(String? state) {
  final s = (state ?? 'IN_PROGRESS').toUpperCase();
  final Map<String, Map<String, dynamic>> config = {
    'COMPLETED':   {'label': 'APROBADO', 'color': Colors.green},
    'IN_PROGRESS': {'label': 'EN PROCESO', 'color': Colors.blue},
    'IN_REVISION': {'label': 'EN REVISIÓN', 'color': Colors.orange},
    'RETURNED':    {'label': 'REGRESADO', 'color': Colors.purple},
  };
  final data = config[s] ?? {'label': s, 'color': Colors.grey};

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: (data['color'] as Color).withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(data['label'], style: TextStyle(color: data['color'], fontSize: 11, fontWeight: FontWeight.bold)),
  );
}

class ConveyorReportTable extends StatelessWidget with ReportActionHandler {
  final List<dynamic> reports;
  final bool isAdmin;

  const ConveyorReportTable({super.key, required this.reports, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16), 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Consumer(builder: (context, ref, _) {
              return DataTable(
                columnSpacing: constraints.maxWidth * 0.05,
                horizontalMargin: 24,
                dataRowHeight: 80,
                headingTextStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
                columns: const [
                  DataColumn(label: Text("REPORTE")),
                  DataColumn(label: Text("INSPECTOR")),
                  DataColumn(label: Text("FECHA")),
                  DataColumn(label: Text("ESTADO")),
                  DataColumn(label: Text("ACCIÓN")),
                ],
                rows: reports.map((r) {
                  final item = r is ConveyorHistoryModel ? r : null;
                  return DataRow(cells: [
                    DataCell(SizedBox(
                      width: constraints.maxWidth * 0.25,
                      child: Row(children: [
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.layers_outlined, color: Color(0xFFC62828), size: 20)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text("Banda Transportadora", style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                          Text("Folio: ${item?.folio ?? 'N/A'}", style: TextStyle(color: Colors.grey.shade600, fontSize: 11), overflow: TextOverflow.ellipsis),
                        ]))
                      ]),
                    )),
                    DataCell(Row(children: [
                      CircleAvatar(backgroundColor: Colors.grey.shade200, radius: 16, child: Text(item?.inspectorName[0] ?? '?', style: const TextStyle(fontSize: 12))),
                      const SizedBox(width: 12),
                      Text(item?.inspectorName ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ])),
                    DataCell(Text(item?.inspectionDate.toString().split(' ')[0] ?? 'N/A')),
                    DataCell(statusChip(item?.state)),
                    DataCell(PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onSelected: (value) => _handleAction(context, ref, value, item),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'view', child: ListTile(leading: Icon(Icons.visibility), title: Text("Ver reporte"))),
                        const PopupMenuItem(value: 'comment', child: ListTile(leading: Icon(Icons.comment), title: Text("Comentar / Evaluar"))),
                        const PopupMenuItem(value: 'version', child: ListTile(leading: Icon(Icons.history), title: Text("Elegir versión"))),
                      ],
                    )),
                  ]);
                }).toList(),
              );
            }),
          ),
        ),
      );
    });
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action, ConveyorHistoryModel? item) {
    if (item == null) return;
    if (action == 'view') _handleView(context, ref, item);
    if (action == 'comment') _showCommentDialog(context, item);
  }

  void _showCommentDialog(BuildContext context, ConveyorHistoryModel item) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Observaciones del reporte"),
        content: TextField(controller: controller, maxLines: 4, decoration: const InputDecoration(hintText: "Escribe tus comentarios...", border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          OutlinedButton(onPressed: () => print("Devuelto: ${controller.text}"), child: const Text("Regresar")),
          FilledButton(onPressed: () => print("Aprobado: ${controller.text}"), child: const Text("Aprobar")),
        ],
      ),
    );
  }

  Future<void> _handleView(BuildContext context, WidgetRef ref, ConveyorHistoryModel item) async {
    final pdfData = await ConveyorPdfProcessor.getPdfData(ref, item.versionId);
    if (pdfData != null && context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ClientPdfViewerPage(folio: item.folio, pdfGenerator: () => BandaPdfGenerator.generateReport(pdfData.datosNormalizados, pdfData.sections, pdfData.rodillos))));
    }
  }
}