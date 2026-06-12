import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import '../models/inspector_row_ui.dart';
import '../provider/inspection_providers.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';

class TableInspector extends ConsumerStatefulWidget {
  final List<InspectionRowUI> items;

  const TableInspector({super.key, required this.items});

  @override
  ConsumerState<TableInspector> createState() => _TableInspectorState();
}

class _TableInspectorState extends ConsumerState<TableInspector> {
  final Color primaryRed = const Color(0xFFC62828);
  final Color headerColor = const Color(0xFFF9FAFB);
  final Color borderColor = const Color(0xFFE5E7EB);

  // 👁️ VISTA PREVIA DEL PDF
  Future<void> _viewReport(InspectionRowUI item) async {
    final model = await ref.read(inspectionProvider.notifier).getReportDetail(item.versionId);
    if (model == null) return;

    final pdfData = VehiculoPdfGenerator.mapDetailModelToPdfData(model);
    
    for (var sec in pdfData['secciones']) {
      for (var item in sec['items']) {
        if (item['url_antes'] != null) item['foto_antes_bytes'] = await _downloadImage(item['url_antes']);
        if (item['url_despues'] != null) item['foto_despues_bytes'] = await _downloadImage(item['url_despues']);
      }
    }

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
      appBar: AppBar(title: const Text("Vista Previa"), backgroundColor: primaryRed),
      body: PdfPreview(
        build: (format) => VehiculoPdfGenerator.generateEsqueleto(pdfData),
        initialPageFormat: PdfPageFormat.letter,
      ),
    )));
  }

  // 🖨️ IMPRESIÓN DIRECTA DEL PDF
  Future<void> _printReport(InspectionRowUI item) async {
    final model = await ref.read(inspectionProvider.notifier).getReportDetail(item.versionId);
    if (model == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al generar PDF")));
      return;
    }

    final pdfData = VehiculoPdfGenerator.mapDetailModelToPdfData(model);
    
    for (var sec in pdfData['secciones']) {
      for (var item in sec['items']) {
        if (item['url_antes'] != null) item['foto_antes_bytes'] = await _downloadImage(item['url_antes']);
        if (item['url_despues'] != null) item['foto_despues_bytes'] = await _downloadImage(item['url_despues']);
      }
    }

    final pdfBytes = await VehiculoPdfGenerator.generateEsqueleto(pdfData);

    // Lanza el diálogo de impresión nativo del dispositivo
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: 'Reporte_${item.folio}',
    );
  }

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200 ? response.bodyBytes : null;
    } catch (e) { return null; }
  }

  // ✏️ EDICIÓN NO FUNCIONAL AÚN
  Future<void> _editReport(InspectionRowUI item) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("La funcionalidad de edición estará disponible próximamente.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox(height: 250, child: Center(child: Text("Sin registros")));
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 800) return _buildMobileList();
      return _buildDesktopTable(constraints.maxWidth);
    });
  }

  Widget _buildDesktopTable(double maxWidth) {
    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
      child: ClipRRect(borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: ConstrainedBox(constraints: BoxConstraints(minWidth: maxWidth),
            child: DataTable(headingRowHeight: 52, dataRowMaxHeight: 85, horizontalMargin: 20, columnSpacing: 20,
              headingRowColor: WidgetStateProperty.all(headerColor),
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: _HeaderLabel(text: 'REPORTE', color: Color(0xFF4B5563))),
                DataColumn(label: _HeaderLabel(text: 'ESTADO', color: Color(0xFF4B5563))),
                DataColumn(label: _HeaderLabel(text: 'FECHA', color: Color(0xFF4B5563))),
                DataColumn(label: _HeaderLabel(text: 'ACCIONES', color: Color(0xFF4B5563))),
              ],
              rows: widget.items.map((item) => DataRow(cells: [
                DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF111827))),
                    Text(item.description, style: TextStyle(fontSize: 11, color: Colors.grey.shade500))
                ])),
                DataCell(_StatusBadge(state: item.state, label: item.translatedState)),
                DataCell(Text(item.date, style: const TextStyle(fontSize: 12, color: Colors.black54))),
                DataCell(Row(children: [
                    _ActionIconBtn(icon: Icons.visibility_outlined, color: const Color(0xFF6366F1), onTap: () => _viewReport(item)),
                    const SizedBox(width: 8),
                    _ActionIconBtn(icon: Icons.edit_outlined, color: const Color(0xFF4B5563), onTap: () => _editReport(item)),
                    const SizedBox(width: 8),
                    _ActionIconBtn(icon: Icons.print_outlined, color: primaryRed, onTap: () => _printReport(item)),
                ])),
              ])).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: widget.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        var item = widget.items[index];
        return Card(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: borderColor)),
          child: ListTile(
            leading: Icon(Icons.assignment_outlined, color: primaryRed),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${item.date} • ${item.translatedState}"),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.visibility, size: 20), onPressed: () => _viewReport(item)),
                IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => _editReport(item)),
                IconButton(icon: const Icon(Icons.print, size: 20), onPressed: () => _printReport(item)),
            ]),
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String state, label;
  const _StatusBadge({required this.state, required this.label});
  @override
  Widget build(BuildContext context) {
    Color color = state.toUpperCase().contains('COMPLET') ? Colors.green : Colors.orange;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))), child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)));
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _HeaderLabel({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Text(text, style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 11, letterSpacing: 0.5));
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionIconBtn({required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)));
}