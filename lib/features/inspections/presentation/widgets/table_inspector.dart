import 'dart:typed_data';
import 'package:crv_reprosisa/core/utils/loading_overlay.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/domain/entities/banda_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../bandas_transportadoras/domain/entities/roller.dart';
import '../../../../core/utils/imege_downloader.dart';
import '../models/inspector_row_ui.dart';
import '../provider/inspection_providers.dart';
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/utils/pdf_report_manager.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_report_detail_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/conveyor_report_detail_provider.dart';
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
      final dio = ref.read(dioProvider);

      dynamic model;
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

      if (type.contains('PRESS')) {
        final Map<int, Map<String, Uint8List>> cacheImagenes = {};

        for (int i = 0; i < model.answers.length; i++) {
          var answer = model.answers[i];
          if (answer.evidencePaths != null && answer.evidencePaths is List) {
            final paths = answer.evidencePaths as List;
            final Map<String, Uint8List> fotos = {};

            for (int j = 0; j < paths.length; j++) {
              final bytes = await ImageDownloader.download(dio, paths[j]);
              if (bytes != null) {
                if (j == 0) fotos['antes'] = bytes;
                if (j == 1) fotos['despues'] = bytes;
              }
            }
            cacheImagenes[i] = fotos;
          }
        }

        return await PdfReportManager.generatePdf(
          dio: dio,
          detailModel: model,
          mapper: (m) {
            final data = PrensaPdfGenerator.mapDetailModelToPdfData(m);

            for (int i = 0; i < data['items'].length; i++) {
              if (cacheImagenes.containsKey(i)) {
                data['items'][i]['foto_antes_bytes'] =
                    cacheImagenes[i]!['antes'];
                data['items'][i]['foto_despues_bytes'] =
                    cacheImagenes[i]!['despues'];
              }
            }
            return data;
          },
          generator: (data) => PrensaPdfGenerator.generateEsqueleto(data),
        );
      } else if (type.contains('VEHICLE')) {
        return await PdfReportManager.generatePdf(
          dio: dio,
          detailModel: model,
          mapper: (m) => VehiculoPdfGenerator.mapDetailModelToPdfData(m),
          generator: (data) => VehiculoPdfGenerator.generateEsqueleto(data),
        );
      } else if (type.contains('CONVEYOR')) {
        for (var answer in model.answers) {
          if (answer.evidences != null) {
            for (var ev in answer.evidences) {
              if (ev.bytes == null && ev.signedUrl != null) {
                ev.bytes = await ImageDownloader.download(dio, ev.signedUrl);
              }
            }
          }
        }

        final Map<String, dynamic> datosNormalizados = {
          'planta': model.conveyor['mine'] ?? "",
          'area': model.conveyor['area'] ?? "",
          'responsable': model.report['conveyor_responsible'] ?? "",
          'seccion': model.report['section']?.toString() ?? "",
          'transportador': model.conveyor['name'] ?? "",
          'banda': model.report['recommended_belt'] ?? "",
          'material':
              "${model.report['material'] ?? ''} / ${model.report['granulometry'] ?? ''}",
          'elaboro': model.inspector['name'] ?? "",
          'presentar': model.report['present_to'] ?? "",
          'comentarios': model.report['comentarios'] ?? "",
        };

        final sections = await _mapAnswersToSections(model.answers);
        final List<Roller> rodillos =
            (model.rollers as List<dynamic>?)
                ?.map(
                  (r) => Roller(
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
                  ),
                )
                .toList() ??
            [];

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

  Future<void> _handleReportAction(
    InspectionRowUI item, {
    required bool isPrint,
  }) async {
    final List<InspectionRowUI> versiones =
        widget.items.where((i) => i.id == item.id).toList()..sort(
          (a, b) => b.versionNumber.compareTo(a.versionNumber),
        );

    InspectionRowUI itemFinal = item;

    if (versiones.length > 1) {
      final selected = await showModalBottomSheet<InspectionRowUI>(
        context: context,
        builder: (context) => ListView.builder(
          shrinkWrap: true,
          itemCount: versiones.length,
          itemBuilder: (context, index) {
            final v = versiones[index];
            return ListTile(
              title: Text("Versión ${v.versionNumber}"),
              subtitle: Text(
                v.versionId == item.versionId
                    ? "Versión actual seleccionada"
                    : "",
              ),
              onTap: () => Navigator.pop(context, v),
            );
          },
        ),
      );

      if (selected == null) return;
      itemFinal = selected;
    }
    LoadingOverlay.show(context, isPrint ? "Generando..." : "Cargando...");
    final pdfBytes = await _buildPdfBytes(itemFinal);
    if (mounted) LoadingOverlay.hide(context);

    if (pdfBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al cargar reporte")),
        );
      }
      return;
    }

    if (isPrint) {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'Reporte_${itemFinal.folio}_v${itemFinal.versionNumber}.pdf',
      );
    } else {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text("Vista Previa"),
              backgroundColor: primaryRed,
            ),
            body: PdfPreview(build: (_) => pdfBytes),
          ),
        ),
      );
    }
  }

  List<InspectionRowUI> get _filteredItems {
    final Map<String, InspectionRowUI> uniqueMap = {};
    for (var item in widget.items) {
      if (!uniqueMap.containsKey(item.id) ||
          item.versionNumber > (uniqueMap[item.id]?.versionNumber ?? 0)) {
        uniqueMap[item.id] = item;
      }
    }
    return uniqueMap.values.toList();
  }

  Future<void> _viewReport(InspectionRowUI item) =>
      _handleReportAction(item, isPrint: false);
  Future<void> _printReport(InspectionRowUI item) =>
      _handleReportAction(item, isPrint: true);
  Future<void> _editReport(InspectionRowUI item) async {
    _navigateToForm(item, isReadOnly: false);
  }

  void _navigateToForm(InspectionRowUI item, {required bool isReadOnly}) {
    Widget page;
    final String type = item.reportType.toUpperCase();

    if (type.contains('PRESS')) {
      page = PrensaInspectionPage(isReadOnly: isReadOnly, itemToEdit: item);
    } else if (type.contains('VEHICLE')) {
      page = VehicleInspectionPage(isReadOnly: isReadOnly, itemToEdit: item);
    } else {
      page = BandaInspectionPage(isReadOnly: isReadOnly, itemToEdit: item);
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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

  Future<List<BandaSection>> _mapAnswersToSections(
    List<dynamic> answers,
  ) async {
    final Map<String, List<BandaComponent>> sectionsMap = {};

    for (var a in answers) {
      final String sectionName = (a.section?.name ?? "Sin Sección");
      final String accessoryName = (a.accessory?.name ?? "Accesorio");

      if (!sectionsMap.containsKey(sectionName)) {
        sectionsMap[sectionName] = [];
      }

      final List<BandaOption> opcionesFijas =
          BandaPdfGenerator.obtenerOpcionesFijasParaComponente(accessoryName);

      final String labelSeleccionado = (a.option?.label ?? a.customOption ?? "")
          .toString()
          .trim();
      final bool esCustom =
          a.option == null ||
          !opcionesFijas.any(
            (o) =>
                o.label.trim().toLowerCase() == labelSeleccionado.toLowerCase(),
          );

      final List<EvidenceFile> evidenciasConvertidas =
          (a.evidences as List<dynamic>?)
              ?.where((e) => e.bytes != null)
              .map(
                (e) => EvidenceFile(
                  bytes: e.bytes!,
                  type: e.fileType ?? 'image/png',
                  mimeType: e.mimeType ?? 'image/png',
                ),
              )
              .toList() ??
          [];

      sectionsMap[sectionName]!.add(
        BandaComponent(
          id: a.answerId?.toString() ?? "0",
          name: accessoryName,
          observation: (a.recommendedAction ?? "").trim(),
          comment: (a.comment ?? "").trim(),
          options: opcionesFijas,
          selectedOptionIds: a.option != null
              ? [
                  a.option!.id.toString().trim().toLowerCase(),
                  a.option!.label.toString().trim().toLowerCase(),
                  a.option!.value.toString().trim().toLowerCase(),
                ]
              : [],
          customOptions: (esCustom && labelSeleccionado.isNotEmpty)
              ? [labelSeleccionado]
              : [],
          dimentions: a.dimentions?.toString() ?? '',
          evidenceBefore: evidenciasConvertidas,
          evidenceAfter: [],
        ),
      );
    }

    return sectionsMap.entries
        .map(
          (e) => BandaSection(
            id: e.key.hashCode.toString(),
            name: e.key,
            components: e.value,
          ),
        )
        .toList();
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
              rows: _filteredItems.map((item) {
                final versiones =
                    widget.items.where((i) => i.id == item.id).toList()..sort(
                      (a, b) => b.versionNumber.compareTo(a.versionNumber),
                    );

                return DataRow(
                  cells: [
                    DataCell(
                      PopupMenuButton<InspectionRowUI>(
                        onSelected: (selectedItem) => _viewReport(selectedItem),
                        offset: const Offset(0, 40),
                        tooltip: "Cambiar versión",
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        itemBuilder: (context) => versiones
                            .map(
                              (v) => PopupMenuItem(
                                value: v,
                                child: Text("Versión ${v.versionNumber}"),
                              ),
                            )
                            .toList(),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    if (item.reviewNotes != null &&
                                        item.reviewNotes!.isNotEmpty) ...[
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () =>
                                            _showReviewDialog(context, item),
                                        child: Icon(
                                          item.reviewAnswer != null
                                              ? Icons.check_circle
                                              : Icons.info,
                                          color: item.reviewAnswer != null
                                              ? Colors.green
                                              : Colors.orange,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  "Versión ${item.versionNumber} • ${item.folio}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                );
              }).toList(),
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
      itemCount: _filteredItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        var item = _filteredItems[index];
        final versiones =
            widget.items.where((i) => i.id == item.id).toList()..sort(
              (a, b) => b.versionNumber.compareTo(a.versionNumber),
            );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
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
                      color: primaryRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: primaryRed,
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
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Selector táctil de versión adaptado con salto de línea si es necesario
                        GestureDetector(
                          onTap: versiones.length > 1
                              ? () async {
                                  final selected = await showModalBottomSheet<InspectionRowUI>(
                                    context: context,
                                    builder: (context) => ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: versiones.length,
                                      itemBuilder: (context, idx) {
                                        final v = versiones[idx];
                                        return ListTile(
                                          title: Text("Versión ${v.versionNumber}"),
                                          subtitle: Text(
                                            v.versionId == item.versionId
                                                ? "Versión actual seleccionada"
                                                : "",
                                          ),
                                          onTap: () => Navigator.pop(context, v),
                                        );
                                      },
                                    ),
                                  );
                                  if (selected != null) {
                                    _viewReport(selected);
                                  }
                                }
                              : null,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            children: [
                              Text(
                                "Versión ${item.versionNumber} • ${item.folio}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  decoration: versiones.length > 1 ? TextDecoration.underline : null,
                                ),
                              ),
                              if (versiones.length > 1)
                                Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey.shade600),
                            ],
                          ),
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
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusBadge(
                        state: item.state,
                        label: item.translatedState,
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "FECHA",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (item.reviewNotes != null &&
                      item.reviewNotes!.isNotEmpty)
                    InkWell(
                      onTap: () => _showReviewDialog(context, item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: item.reviewAnswer != null
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: item.reviewAnswer != null
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.reviewAnswer != null
                                  ? Icons.check_circle
                                  : Icons.warning_amber_rounded,
                              color: item.reviewAnswer != null
                                  ? Colors.green.shade800
                                  : Colors.orange.shade900,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.reviewAnswer != null
                                  ? "CONTESTADO"
                                  : "PENDIENTE",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: item.reviewAnswer != null
                                    ? Colors.green.shade900
                                    : Colors.orange.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                ],
              ),
            ],
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

void _showReviewDialog(BuildContext context, InspectionRowUI item) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Detalles de Revisión"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nota del Revisor:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(item.reviewNotes ?? "Sin notas"),
          const SizedBox(height: 15),
          const Text(
            "Respuesta del Técnico:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(item.reviewAnswer ?? "Aún sin respuesta"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
      ],
    ),
  );
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