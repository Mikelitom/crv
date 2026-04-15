import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.DART';
import '../../domain/entities/component_item.dart';
import '../provider/inspeccion_providers.dart';
import '../../../../features/evidence/presentation/providers/evidence_service_provider.dart';
import '../widgets/information_general_equipo.dart';
import '../widgets/table_componentes_press.dart';
import '../widgets/capture_method_selector.dart';
import '../widgets/prestamo_devolucion.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchTemplate();
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
    final String fechaActual = DateTime.now().toIso8601String().split('T').first;

    final Map<String, dynamic> pdfData = {
      "serie": state.selectedPress?.serie ?? "S/N",
      "fecha": fechaActual,
      "area": state.area ?? "N/A",
      "tipo": state.selectedPress?.type ?? "N/A",
      "modelo": state.selectedPress?.model ?? "N/A",
      "volts": state.selectedPress?.voltz ?? "N/A",
      "area_solicita": "Taller Solicitante",
      "observaciones_footer": "Ninguna",
      "items": templateItems.map((item) => {
        "quantity": item.quantity,
        "measureUnit": item.measureUnit,
        "name": item.name,
        "status": item.status, 
        "observation": item.observation,
        "foto_antes_bytes": item.evidenceBefore.isNotEmpty ? item.evidenceBefore.first.bytes : null,
        "foto_despues_bytes": item.evidenceAfter.isNotEmpty ? item.evidenceAfter.first.bytes : null,
      }).toList(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Vista Previa REPROSISA"),
            backgroundColor: const Color(0xFFC62828),
            foregroundColor: Colors.white,
          ),
          body: PdfPreview(
            build: (format) => PrensaPdfGenerator.generateEsqueleto(pdfData),
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            initialPageFormat: PdfPageFormat.letter.landscape,
          ),
        ),
      ),
    );
  }

  Future<void> _guardarInspeccion() async {
    final state = ref.read(inspeccionProvider);
    final evidenceService = ref.read(evidenceServiceProvider);
    if (state.selectedPress == null) {
      _showSnack("Por favor, selecciona una prensa primero", Colors.orange);
      return;
    }
    setState(() => isLoading = true);
    try {
      final List<Map<String, dynamic>> answers = [];
      final String pressId = state.selectedPress?.id ?? "unknown";
      final String basePath = 'prensas/$pressId/inspecciones/${DateTime.now().millisecondsSinceEpoch}';
      for (var item in templateItems) {
        final List<Map<String, String>> evidenceList = [];
        final List<Map<String, dynamic>> mediaToProcess = [
          ...item.evidenceBefore.map((e) => {'file': e, 'tag': 'antes'}),
          ...item.evidenceAfter.map((e) => {'file': e, 'tag': 'despues'}),
        ];
        for (var media in mediaToProcess) {
          final evidenceFile = media['file'] as EvidenceFile;
          final tempDir = await getTemporaryDirectory();
          final ext = evidenceFile.type == 'video' ? 'mp4' : 'jpg';
          final tempFile = File('${tempDir.path}/temp_${item.id}_${media['tag']}.$ext');
          await tempFile.writeAsBytes(evidenceFile.bytes);
          final uploadResult = await evidenceService.uploadEvidence(file: tempFile, basePath: basePath);
          uploadResult.fold(
            (failure) => print("Error subiendo archivo: ${failure.message}"),
            (dto) => evidenceList.add({
              "file_url": dto.filePath,
              "file_type": dto.fileType,
              "mime_type": dto.mimeType,
              "file_size": dto.fileSize,
            }),
          );
          if (await tempFile.exists()) await tempFile.delete();
        }
        answers.add({
          "component_id": item.id,
          "quantity": item.quantity ?? 0,
          "status": item.status,
          "observation": item.observation,
          "evidences": evidenceList
        });
      }
      final Map<String, dynamic> reportRequest = {
        "press_id": pressId,
        "responsible_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6", 
        "inspection_date": DateTime.now().toIso8601String(),
        "area": state.area ?? "N/A",
        "folio": "F-${DateTime.now().millisecondsSinceEpoch}",
        "answers": answers
      };
      final result = await ref.read(createPressReportProvider)(reportRequest);
      result.fold(
        (f) => _showSnack("Error: ${f.message}", Colors.red),
        (_) {
          _showSnack("¡Inspección finalizada con éxito!", Colors.green);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      _showSnack("Error inesperado: $e", Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnack(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Column(
                  children: [
                    CustomHeader(title: "Inspección de Prensas", actionIcon: Icons.build_rounded, onActionTap: () => Navigator.pop(context)),
                    const SizedBox(height: 32),
                    CaptureMethodSelector(
                      onManualFill: () => setState(() => isScanning = false),
                      onScan: () => setState(() => isScanning = true),
                    ),
                    const SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: isScanning 
                        ? _buildScannerView(const ValueKey("scan")) 
                        : _buildFormView(const ValueKey("form"), templateItems),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _actionButton("VISTA PREVIA PDF", Colors.blueGrey.shade700, Icons.picture_as_pdf, () => _showPdfPreview(context)),
                        const SizedBox(width: 20),
                        _actionButton("FINALIZAR REPORTE", const Color(0xFFC62828), Icons.check_circle, _guardarInspeccion),
                      ],
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _actionButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(backgroundColor: color, minimumSize: const Size(220, 65), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  Widget _buildScannerView(Key key) => Container(key: key, height: 400, width: double.infinity, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)), child: const Center(child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 80)));

  Widget _buildFormView(Key key, List<ComponentItem> data) {
    return Column(
      key: key,
      children: [
        const InformationGeneralEquipo(),
        const SizedBox(height: 24),
        PrensaInspectionTable(items: data),
        const SizedBox(height: 32),
        const LoanAndInspectorSection(),
      ],
    );
  }
}