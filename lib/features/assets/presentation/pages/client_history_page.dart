import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:printing/printing.dart';

import 'package:crv_reprosisa/features/assets/presentation/providers/conveyor_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/client_history_card.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/client_history.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/conveyor_report_detail.dart' hide Roller;
import 'package:crv_reprosisa/features/assets/presentation/providers/conveyor_report_detail_provider.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/domain/entities/banda_template.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/domain/entities/roller.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart'; 
import 'client_pdf_viewer_page.dart'; 

class ClientHistoryPage extends ConsumerStatefulWidget {
  final String clientId;
  const ClientHistoryPage({super.key, required this.clientId});

  @override
  ConsumerState<ClientHistoryPage> createState() => _ClientHistoryPageState();
}

class _ClientHistoryPageState extends ConsumerState<ClientHistoryPage> {
  String _query = "";
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(clientHistoryProvider.notifier).loadHistory(widget.clientId));
  }

  Map<String, List<ClientHistory>> _groupData(List<ClientHistory> history) {
    Map<String, List<ClientHistory>> grouped = {};
    for (var item in history) {
      if (!grouped.containsKey(item.folio)) grouped[item.folio] = [];
      grouped[item.folio]!.add(item);
    }
    return grouped;
  }

Future<List<BandaSection>> _mapAnswersToSections(List<Answer> answers) async {
    final Map<String, List<BandaComponent>> sectionsMap = {};
    
    for (var a in answers) {
      if (!sectionsMap.containsKey(a.section.name)) {
        sectionsMap[a.section.name] = [];
      }

      // --- DEBUG ESTRATÉGICO ---
      // Esto te dirá en la consola si el dato viene vacío desde el servidor
      debugPrint("Procesando: ${a.accessory.name} | Observación recibida: '${a.recommendedAction}'");

      final List<EvidenceFile> evFiles = [];
      for (var ev in a.evidences) {
        if (ev.signedUrl.isNotEmpty) {
          try {
            final dio = Dio();
            final response = await dio.get<Uint8List>(
              ev.signedUrl,
              options: Options(responseType: ResponseType.bytes),
            );
            if (response.statusCode == 200) {
              evFiles.add(EvidenceFile(
                bytes: response.data!,
                type: ev.fileType,
                mimeType: ev.mimeType,
              ));
            }
          } catch (e) {
            debugPrint("Error descargando evidencia histórica: $e");
          }
        }
      }
      
      sectionsMap[a.section.name]!.add(BandaComponent(
        id: a.answerId, 
        name: a.accessory.name,
        observation: (a.recommendedAction.isNotEmpty) ? a.recommendedAction : "N/A",      
        options: [],
selectedOptionIds: [a.option.id.toString(), a.option.label.toString()],
        dimentions: a.dimentions > 0 ? a.dimentions.toString() : '',
        evidenceBefore: evFiles,
        evidenceAfter: [],
      ));
    }

    return sectionsMap.entries.map((e) => BandaSection(
      id: e.key.hashCode.toString(), 
      name: e.key, 
      components: e.value
    )).toList();
  }

Future<Uint8List?> _generatePdf(String versionId) async {
    try {
      final reportDetail = await ref
          .read(conveyorReportDetailProvider.notifier)
          .fetchDetail(versionId);

      if (reportDetail == null) return null;

      final String seccionGeneral =
          reportDetail.report['section']?.toString() ?? "";

      final Map<String, dynamic> datosNormalizados = {
        'planta': reportDetail.conveyor['mine'] ?? "",
        'area': reportDetail.conveyor['area'] ?? "",
        'responsable':
            reportDetail.report['conveyor_responsible'] ?? "",
        'seccion': seccionGeneral,
        'transportador':
            reportDetail.conveyor['name'] ?? "",
        'banda':
            reportDetail.report['recommended_belt'] ?? "",
        'material':
            "${reportDetail.report['material'] ?? ''} / ${reportDetail.report['granulometry'] ?? ''}",
        'elaboro':
            reportDetail.inspector['name'] ?? "",
        'presentar':
            reportDetail.report['present_to'] ?? "",
        'comentarios':
            reportDetail.report['comentarios'] ?? "",
      };

      final sections = await _mapAnswersToSections(reportDetail.answers);

      final List<dynamic> rawRodillos = reportDetail.rollers;
      final List<Roller> rodillos = rawRodillos.map((r) => Roller(
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
      )).toList();

      return await BandaPdfGenerator.generateReport(
        datosNormalizados,
        sections,
        rodillos, 
      );
    } catch (e) {
      debugPrint("Error generando PDF: $e");
      return null;
    }
  }
Future<void> _downloadReport(String versionId, String folio) async {
    try {
      final reportDetail = await ref
          .read(conveyorReportDetailProvider.notifier)
          .fetchDetail(versionId);

      if (reportDetail == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al generar PDF")),
        );
        return;
      }

      final String seccionGeneral =
          reportDetail.report['section']?.toString() ?? "";

      final Map<String, dynamic> datosNormalizados = {
        'planta': reportDetail.conveyor['mine'] ?? "",
        'area': reportDetail.conveyor['area'] ?? "",
        'responsable':
            reportDetail.report['conveyor_responsible'] ?? "",
        'seccion': seccionGeneral,
        'transportador':
            reportDetail.conveyor['name'] ?? "",
        'banda':
            reportDetail.report['recommended_belt'] ?? "",
        'material':
            "${reportDetail.report['material'] ?? ''} / ${reportDetail.report['granulometry'] ?? ''}",
        'elaboro':
            reportDetail.inspector['name'] ?? "",
        'presentar':
            reportDetail.report['present_to'] ?? "",
        'comentarios':
            reportDetail.report['comentarios'] ?? "",
      };

      final sections = await _mapAnswersToSections(reportDetail.answers);

      // CORRECCIÓN: Convertimos los rodillos que vienen del API
      // al tipo 'Roller' que espera el generador, evitando conflictos de tipos.
      final List<Roller> rodillos = reportDetail.rollers.map((r) => Roller(
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
      )).toList();

      // Generación pasando los 3 argumentos requeridos
      final pdfBytes = await BandaPdfGenerator.generateReport(
        datosNormalizados,
        sections,
        rodillos, 
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'Reporte_$folio.pdf',
      );
    } catch (e) {
      debugPrint("Error descargando PDF: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al descargar PDF: $e")),
        );
      }
    }
  }

@override
  Widget build(BuildContext context) {
    final state = ref.watch(clientHistoryProvider);
    final filtered = state.history.where((h) => 
        h.folio.toLowerCase().contains(_query.toLowerCase()) &&
        (_start == null || h.inspectionDate.isAfter(_start!))
    ).toList();
    final grouped = _groupData(filtered);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text("Expediente Digital", style: TextStyle(fontWeight: FontWeight.w900)), 
        backgroundColor: Colors.white, 
        elevation: 0.5
      ),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Expanded(child: TextField(
            onChanged: (v) => setState(() => _query = v), 
            decoration: InputDecoration(
              hintText: "Buscar por folio...", 
              prefixIcon: const Icon(Icons.search, color: Colors.redAccent), 
              filled: true, 
              fillColor: Colors.white, 
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)
            )
          )),
          const SizedBox(width: 15),
          _dateBtn("Desde", _start, () => _pickDate(true)),
          const SizedBox(width: 15),
          _dateBtn("Hasta", _end, () => _pickDate(false)),
        ])),
        Expanded(child: state.status == Status.loading 
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent)) 
          : ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: grouped.entries.map((e) => ClientHistoryCard(
            versions: e.value,
            onPdfView: (versionId) async {
              final reportDetail = await ref.read(conveyorReportDetailProvider.notifier).fetchDetail(versionId);
              
              if (reportDetail != null && mounted) {
                final String seccionGeneral = reportDetail.report['section']?.toString() ?? "";

                final Map<String, dynamic> datosNormalizados = {
                  'planta': reportDetail.conveyor['mine'] ?? "", 
                  'area': reportDetail.conveyor['area'] ?? "",
                  'responsable': reportDetail.report['conveyor_responsible'] ?? "",
                  'seccion': seccionGeneral,               
                  'transportador': reportDetail.conveyor['name'] ?? "", 
                  'banda': reportDetail.report['recommended_belt'] ?? "",
                  'material': "${reportDetail.report['material'] ?? ''} / ${reportDetail.report['granulometry'] ?? ''}",
                  'elaboro': reportDetail.inspector['name'] ?? "",
                  'presentar': reportDetail.report['present_to'] ?? "",
                  'comentarios': reportDetail.report['comentarios'] ?? "",
                };

                final sections = await _mapAnswersToSections(reportDetail.answers);
                
                if (mounted) {
                  // Mapeamos los rodillos del modelo al tipo esperado por el generador
                  final List<Roller> rodillos = reportDetail.rollers.map((r) => Roller(
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
                  )).toList();

                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ClientPdfViewerPage(
                      folio: e.key,
                      pdfGenerator: () => BandaPdfGenerator.generateReport(
                        datosNormalizados, 
                        sections, 
                        rodillos // Tercer argumento añadido
                      ), 
                    ),
                  ));
                }
              }
            },
            onDownload: (id) => _downloadReport(id, e.key),
            onPrint: (id) async {
              final pdfBytes = await _generatePdf(id);
              if (pdfBytes == null) return;

              await Printing.layoutPdf(
                onLayout: (_) async => pdfBytes,
              );
            },
          )).toList(),
        ))
      ]),
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final d = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2025), 
      lastDate: DateTime.now()
    );
    if (d != null) setState(() => isStart ? _start = d : _end = d);
  }

  Widget _dateBtn(String label, DateTime? date, VoidCallback onTap) => InkWell(onTap: onTap, child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
    child: Row(children: [Text(date == null ? label : DateFormat('dd/MM/yy').format(date), style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(width: 10), const Icon(Icons.calendar_today, size: 14, color: Colors.redAccent)]),
  ));
}