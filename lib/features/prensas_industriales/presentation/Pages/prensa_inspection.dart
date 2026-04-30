import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.DART';
import '../../domain/entities/component_item.dart';
import '../provider/inspeccion_providers.dart';
import '../../../../features/evidence/presentation/providers/evidence_service_provider.dart';
import '../widgets/information_general_equipo.dart';
import '../widgets/table_componentes_press.dart';
import '../widgets/capture_method_selector.dart';
import '../../../dashboard/presentation/widgets/header.dart';

class PrensaInspectionPage extends ConsumerStatefulWidget {
  const PrensaInspectionPage({super.key});

  @override
  ConsumerState<PrensaInspectionPage> createState() => _PrensaInspectionPageState();
}

class _PrensaInspectionPageState extends ConsumerState<PrensaInspectionPage> {
  bool isScanning = false;
  bool isLoading = true;
  List<ComponentItem> templateItems = [];

  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _recibeController = TextEditingController();
  final TextEditingController _observacionesLoanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTemplate();
  }

  @override
  void dispose() {
    _areaController.dispose();
    _recibeController.dispose();
    _observacionesLoanController.dispose();
    super.dispose();
  }

  Future<void> _fetchTemplate() async {
    final repo = ref.read(inspeccionRepositoryProvider);
    final result = await repo.getInspectionTemplate();
    result.fold(
      (failure) => setState(() => isLoading = false),
      (components) => setState(() {
        templateItems = components;
        isLoading = false;
      }),
    );
  }

  void _showPdfPreview(BuildContext context) {
    final state = ref.read(inspeccionProvider);
    final String fechaActual = DateFormat('dd/MM/yyyy').format(state.inspectionDate);

    final Map<String, dynamic> pdfData = {
      "serie": state.selectedPress?.serie ?? "S/N",
      "fecha": fechaActual,
      "area": _areaController.text.trim().isEmpty ? "General" : _areaController.text.trim(),
      "tipo": state.selectedPress?.type ?? "N/A",
      "modelo": state.selectedPress?.model ?? "N/A",
      "volts": state.selectedPress?.voltz ?? "N/A",
      "nombre_recibe": _recibeController.text.isEmpty ? "N/A" : _recibeController.text,
      "obs_prestamo": _observacionesLoanController.text,
      "items": templateItems.map((item) => {
        "quantity": item.quantity ?? 0,
        "measureUnit": item.measureUnit,
        "name": item.name,
        "status": item.status,
        "observation": item.observation,
        "foto_antes_bytes": item.evidenceBefore.isNotEmpty ? item.evidenceBefore.first.bytes : null,
        "foto_despues_bytes": item.evidenceAfter.isNotEmpty ? item.evidenceAfter.first.bytes : null,
      }).toList(),
    };

    Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
      appBar: AppBar(title: const Text("Vista Previa REPROSISA"), backgroundColor: const Color(0xFFC62828)),
      body: PdfPreview(
        build: (format) => PrensaPdfGenerator.generateEsqueleto(pdfData),
        initialPageFormat: PdfPageFormat.letter.landscape,
      ),
    )));
  }

  Future<void> _guardarInspeccion() async {
    final state = ref.read(inspeccionProvider);
    final evidenceService = ref.read(evidenceServiceProvider);

    if (state.selectedPress == null) {
      _showSnack("Por favor, selecciona una prensa primero", Colors.orange);
      return;
    }

    final answeredItems = templateItems.where((item) => item.status.isNotEmpty).toList();
    if (answeredItems.isEmpty) {
      _showSnack("No hay respuestas para enviar", Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final List<Map<String, dynamic>> answers = [];
      for (var item in answeredItems) {
        final List<Map<String, String>> evidenceList = [];
        final List<Map<String, dynamic>> media = [
          ...item.evidenceBefore.map((e) => {'file': e, 'tag': 'ant'}),
          ...item.evidenceAfter.map((e) => {'file': e, 'tag': 'des'}),
        ];

        for (var m in media) {
          final evFile = m['file'] as EvidenceFile;
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/tmp_${item.id}_${m['tag']}.jpg');
          await file.writeAsBytes(evFile.bytes);

          final upload = await evidenceService.uploadEvidence(file: file, basePath: 'inspecciones');
          upload.fold((f) => null, (dto) => evidenceList.add({
            "file_path": dto.filePath,
            "file_type": dto.fileType,
            "mime_type": dto.mimeType,
            "file_size": dto.fileSize,
          }));
        }

        answers.add({
          "component_id": item.id,
          "quantity": item.quantity ?? 0,
          "status": item.status.toLowerCase(),
          "observation": (item.observation.trim().length >= 2) ? item.observation.trim() : null,
          "evidences": evidenceList,
        });
      }

      final reportRequest = {
        "press_id": state.selectedPress!.id,
        "inspection_date": DateTime.now().toIso8601String(),
        "area": _areaController.text.trim().isEmpty ? "General" : _areaController.text.trim(),
        "folio": "F-${DateTime.now().millisecondsSinceEpoch}",
        "answers": answers,
      };

      final result = await ref.read(createPressReportProvider).call(reportRequest);
      result.fold(
        (f) => _showSnack("Error: ${f.message}", Colors.red),
        (r) { _showSnack("¡Reporte guardado!", Colors.green); Navigator.pop(context); }
      );
    } catch (e) {
      _showSnack("Error inesperado", Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnack(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c, behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CustomHeader(title: "Inspección de Prensas", actionIcon: Icons.build_rounded, onActionTap: () => Navigator.pop(context)),
                const SizedBox(height: 32),
                CaptureMethodSelector(onManualFill: () => setState(() => isScanning = false), onScan: () => setState(() => isScanning = true)),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: isScanning 
                    ? Container(height: 400, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)), child: const Center(child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 80)))
                    : _buildFormView(),
                ),
                const SizedBox(height: 40),
                // BOTONES INFERIORES ADAPTABLES
                LayoutBuilder(builder: (context, c) {
                  bool small = c.maxWidth < 600;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _actionButton("VISTA PREVIA PDF", Colors.blueGrey.shade700, Icons.picture_as_pdf, () => _showPdfPreview(context), small),
                      _actionButton("FINALIZAR REPORTE", const Color(0xFFC62828), Icons.check_circle, _guardarInspeccion, small),
                    ],
                  );
                }),
                const SizedBox(height: 60),
              ],
            ),
          ),
    );
  }

  Widget _buildFormView() {
    return Column(
      children: [
        const InformationGeneralEquipo(),
        const SizedBox(height: 32),
        const Row(
          children: [
            Icon(Icons.list_alt_rounded, color: Color(0xFFC62828)),
            SizedBox(width: 12),
            Expanded(child: Text("LISTA DE COMPONENTES A REVISAR", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18))),
          ],
        ),
        const SizedBox(height: 16),
        PrensaInspectionTable(items: templateItems),
        const SizedBox(height: 32),
        _buildLoanSection(),
      ],
    );
  }

  Widget _buildLoanSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Préstamo o Devolución (Opcional)", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 24),
          _buildField("Área o Taller Solicitante", _areaController),
          _buildField("Nombre de quien recibe", _recibeController),
          _buildField("Observaciones del Préstamo", _observacionesLoanController),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Padding(padding: const EdgeInsets.only(bottom: 20), child: TextField(controller: ctrl, decoration: InputDecoration(labelText: label, filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDE1E6))))));
  }

  Widget _actionButton(String label, Color color, IconData icon, VoidCallback onTap, bool small) {
    return ElevatedButton.icon(
      onPressed: onTap, icon: Icon(icon, color: Colors.white, size: 20), label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      style: ElevatedButton.styleFrom(backgroundColor: color, minimumSize: Size(small ? double.infinity : 220, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}