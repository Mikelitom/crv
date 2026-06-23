import 'dart:typed_data';
import 'package:crv_reprosisa/features/assets/presentation/pages/pdf_viewer_page.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/domain/entities/banda_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../bandas_transportadoras/domain/entities/roller.dart';
import 'package:pdf/pdf.dart';

// Importaciones del proyecto
import '../models/inspector_row_ui.dart';
import '../provider/inspection_providers.dart';
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/utils/pdf_report_manager.dart';

// Generadores de PDF
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';

// Providers de los módulos de Assets
import 'package:crv_reprosisa/features/assets/presentation/providers/press_report_detail_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/conveyor_report_detail_provider.dart';

// Páginas para navegación
import 'package:crv_reprosisa/features/prensas_industriales/presentation/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/pages/vehicle_inspection_page.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/pages/banda_inspection_page.dart';

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

Future<Uint8List?> _buildPdfBytes(InspectionRowUI item) async {
    try {
      final type = item.reportType.toUpperCase();
      dynamic model;

      // 1. OBTENCIÓN DE DATOS SEGÚN EL TIPO
      if (type.contains('PRESS')) {
        await ref
            .read(pressReportDetailProvider.notifier)
            .fetchDetail(item.versionId);
        model = ref.read(pressReportDetailProvider).data;
      } else if (type.contains('VEHICLE')) {
        model = await ref
            .read(inspectionProvider.notifier)
            .getReportDetail(item.versionId);
      } else if (type.contains('CONVEYOR')) {
        await ref
            .read(conveyorReportDetailProvider.notifier)
            .fetchDetail(item.versionId);
        model = ref.read(conveyorReportDetailProvider).data;
      }

      if (model == null) return null;

      // 2. GENERACIÓN DE PDF SEGÚN EL TIPO
      if (type.contains('PRESS')) {
        return await PdfReportManager.generatePdf(
          dio: ref.read(dioProvider),
          detailModel: model,
          mapper: (m) => PrensaPdfGenerator.mapDetailModelToPdfData(m),
          generator: (data) => PrensaPdfGenerator.generateEsqueleto(data),
        );
      } else if (type.contains('VEHICLE')) {
        return await PdfReportManager.generatePdf(
          dio: ref.read(dioProvider),
          detailModel: model,
          mapper: (m) => VehiculoPdfGenerator.mapDetailModelToPdfData(m),
          generator: (data) => VehiculoPdfGenerator.generateEsqueleto(data),
        );
      } else if (type.contains('CONVEYOR')) {
        // A. Preparar datos normalizados
        final Map<String, dynamic> datosNormalizados = {
          'planta': model.conveyor['mine'] ?? "",
          'area': model.conveyor['area'] ?? "",
          'responsable': model.report['conveyor_responsible'] ?? "",
          'seccion': model.report['section']?.toString() ?? "",
          'transportador': model.conveyor['name'] ?? "",
          'banda': model.report['recommended_belt'] ?? "",
          'material': "${model.report['material'] ?? ''} / ${model.report['granulometry'] ?? ''}",
          'elaboro': model.inspector['name'] ?? "",
          'presentar': model.report['present_to'] ?? "",
          'comentarios': model.report['comentarios'] ?? "",
        };

        // B. Mapear secciones
        final sections = await _mapAnswersToSections(model.answers);

        // C. Mapear rodillos desde el modelo (Asegúrate de ajustar 'model.rollers' según tu estructura)
        final List<Roller> rodillos = (model.rollers as List<dynamic>?)
            ?.map((r) => Roller(
                  tableNumber: r.tableNumber,
                  baseNumber: r.baseNumber,
                  isLeft: r.isLeft,
                  isCenter: r.isCenter,
                  isRight: r.isRight,
                  isImpact: r.isImpact,
                  isReturn: r.isReturn,
                  isTriple: r.isTriple,
                  isSelfAligning: r.isSelfAligning,
                  observation: r.observation,
                ))
            .toList() ?? [];

        // D. Generar pasándole los 3 argumentos requeridos
        return await BandaPdfGenerator.generateReport(
          datosNormalizados,
          sections,
          rodillos, 
        );
      }
      return null;
    } catch (e) {
      debugPrint("Error al procesar PDF de ${item.reportType}: $e");
      return null;
    }
  }

  Future<void> _viewReport(InspectionRowUI item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFC62828)),
      ),
    );
    final pdfBytes = await _buildPdfBytes(item);
    if (mounted) Navigator.pop(context);
    if (pdfBytes == null) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al cargar detalle o generar PDF"),
          ),
        );
      return;
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Vista Previa"),
            backgroundColor: primaryRed,
          ),
          body: PdfPreview(
            build: (format) => pdfBytes,
            initialPageFormat: PdfPageFormat.letter,
          ),
        ),
      ),
    );
  }

  Future<void> _printReport(InspectionRowUI item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFC62828)),
      ),
    );
    final pdfBytes = await _buildPdfBytes(item);
    if (mounted) Navigator.pop(context);
    if (pdfBytes != null)
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'Reporte_${item.folio}.pdf',
      );
  }

  void _navigateToForm(InspectionRowUI item, {required bool isReadOnly}) {
    Widget page;
    final String type = item.reportType.toUpperCase();
    if (type.contains('PRESS')) {
      page = PrensaInspectionPage(isReadOnly: isReadOnly);
    } else if (type.contains('VEHICLE')) {
      page = VehicleInspectionPage(isReadOnly: isReadOnly);
    } else {
      page = BandaInspectionPage(isReadOnly: isReadOnly);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _editReport(InspectionRowUI item) async {
    _navigateToForm(item, isReadOnly: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty)
      return const SizedBox(
        height: 250,
        child: Center(child: Text("Sin registros")),
      );
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 800
            ? _buildMobileList()
            : _buildDesktopTable(constraints.maxWidth);
      },
    );
  }

  Future<List<BandaSection>> _mapAnswersToSections(List<dynamic> answers) async {
    final Map<String, List<BandaComponent>> sectionsMap = {};
    
    for (var a in answers) {
      // Si 'a' es de tipo Answer (la entidad), asegúrate de que tenga los campos
      // Si viene de un JSON, recuerda castearlo correctamente.
      final String sectionName = a.section.name ?? "Sin Sección";
      
      if (!sectionsMap.containsKey(sectionName)) {
        sectionsMap[sectionName] = [];
      }
      
      sectionsMap[sectionName]!.add(BandaComponent(
        id: a.answerId, 
        name: a.accessory.name, // Asegúrate que 'accessory' sea el nombre correcto
        observation: a.recommendedAction ?? "",      
        options: [], // Si necesitas opciones, mapealas aquí igual que en el ejemplo
selectedOptionIds: [a.option.label.toString()],
        dimentions: a.dimentions > 0 ? a.dimentions.toString() : '',
        evidenceBefore: [], // Mapea tus evidencias aquí
        evidenceAfter: [],
      ));
    }

    return sectionsMap.entries.map((e) => BandaSection(
      id: e.key.hashCode.toString(), 
      name: e.key, 
      components: e.value
    )).toList();
  }

  Widget _buildDesktopTable(double maxWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: maxWidth),
            child: DataTable(
              headingRowHeight: 52,
              dataRowMaxHeight: 85,
              horizontalMargin: 20,
              columnSpacing: 20,
              headingRowColor: WidgetStateProperty.all(headerColor),
              showCheckboxColumn: false,
              columns: const [
                DataColumn(
                  label: _HeaderLabel(
                    text: 'REPORTE',
                    color: Color(0xFF4B5563),
                  ),
                ),
                DataColumn(
                  label: _HeaderLabel(text: 'ESTADO', color: Color(0xFF4B5563)),
                ),
                DataColumn(
                  label: _HeaderLabel(text: 'FECHA', color: Color(0xFF4B5563)),
                ),
                DataColumn(
                  label: _HeaderLabel(
                    text: 'ACCIONES',
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
              rows: widget.items
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          _StatusBadge(
                            state: item.state,
                            label: item.translatedState,
                          ),
                        ),
                        DataCell(
                          Text(
                            item.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              _ActionIconBtn(
                                icon: Icons.visibility_outlined,
                                color: const Color(0xFF6366F1),
                                onTap: () => _viewReport(item),
                              ),
                              const SizedBox(width: 8),
                              _ActionIconBtn(
                                icon: Icons.edit_outlined,
                                color: const Color(0xFF4B5563),
                                onTap: () => _editReport(item),
                              ),
                              const SizedBox(width: 8),
                              _ActionIconBtn(
                                icon: Icons.print_outlined,
                                color: primaryRed,
                                onTap: () => _printReport(item),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        var item = widget.items[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor),
          ),
          child: ListTile(
            leading: Icon(Icons.assignment_outlined, color: primaryRed),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${item.date} • ${item.translatedState}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 20),
                  onPressed: () => _viewReport(item),
                ),
                IconButton(
                  icon: const Icon(Icons.print, size: 20),
                  onPressed: () => _printReport(item),
                ),
              ],
            ),
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
    Color color = state.toUpperCase().contains('COMPLET')
        ? Colors.green
        : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _HeaderLabel({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w800,
      color: color,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  );
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionIconBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    ),
  );
}
