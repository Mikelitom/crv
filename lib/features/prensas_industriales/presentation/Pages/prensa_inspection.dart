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
import '../widgets/prestamo_devolucion.dart';
import '../../../dashboard/presentation/widgets/header.dart';

class PrensaInspectionPage extends ConsumerStatefulWidget {
  const PrensaInspectionPage({super.key});

  @override
  ConsumerState<PrensaInspectionPage> createState() =>
      _PrensaInspectionPageState();
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
    final String fechaActual = DateFormat(
      'dd/MM/yyyy',
    ).format(state.inspectionDate);

    final Map<String, dynamic> pdfData = {
      "serie": state.selectedPress?.serie ?? "S/N",
      "fecha": fechaActual,
      "area": state.area.isEmpty ? "General" : state.area,
      "tipo": state.selectedPress?.type ?? "N/A",
      "modelo": state.selectedPress?.model ?? "N/A",
      "volts": state.selectedPress?.voltz ?? "N/A",
      "nombre_recibe": state.solicitantsName,
      "area_solicita": state.selectedLoanArea?.name ?? "N/A",
      "observaciones_footer": state.observations,
      "items": templateItems
          .map(
            (item) => {
              "quantity": item.quantity ?? 0,
              "measureUnit": item.measureUnit,
              "name": item.name,
              "status": item.status.toUpperCase(),
              "observation": item.observation,
              "foto_antes_bytes": item.evidenceBefore.isNotEmpty
                  ? item.evidenceBefore.first.bytes
                  : null,
              "foto_despues_bytes": item.evidenceAfter.isNotEmpty
                  ? item.evidenceAfter.first.bytes
                  : null,
            },
          )
          .toList(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Vista Previa REPROSISA"),
            backgroundColor: const Color(0xFFC62828),
          ),
          body: PdfPreview(
            build: (format) => PrensaPdfGenerator.generateEsqueleto(pdfData),
            initialPageFormat: PdfPageFormat.letter.landscape,
          ),
        ),
      ),
    );
  }

  Future<void> _guardarInspeccion() async {
    final state = ref.read(inspeccionProvider);
    final notifier = ref.read(inspeccionProvider.notifier);
    final evidenceService = ref.read(evidenceServiceProvider);

    if (state.selectedPress == null) {
      _showSnack("Selecciona una prensa primero", Colors.orange);
      return;
    }

    // --- VALIDACIÓN DE CAMPOS DE PRÉSTAMO/DEVOLUCIÓN ---
    final bool hasLoanData = state.selectedLoanArea != null || state.solicitantsName.isNotEmpty;
    final String currentStatus = state.status.toUpperCase();

    // Si la prensa está prestada, ES OBLIGATORIO llenar los campos para la devolución
    if (currentStatus == 'LOANED' && !hasLoanData) {
      _showSnack("La prensa está prestada. Debe llenar los campos de devolución para continuar.", Colors.red);
      return;
    }

    final answeredItems = templateItems
        .where((item) => item.status.isNotEmpty)
        .toList();
    setState(() => isLoading = true);

    try {
      final List<Map<String, dynamic>> answers = [];

      for (var item in answeredItems) {
        final List<Map<String, String>> evidenceList = [];
        final allEvidenceFiles = [
          ...item.evidenceBefore,
          ...item.evidenceAfter,
        ];

        for (var evFile in allEvidenceFiles) {
          final tempDir = await getTemporaryDirectory();
          final file = File(
            '${tempDir.path}/img_${DateTime.now().microsecondsSinceEpoch}.jpg',
          );
          await file.writeAsBytes(evFile.bytes);

          final uploadResult = await evidenceService.uploadEvidence(
            file: file,
            basePath: 'inspecciones/prensas',
          );

          uploadResult.fold(
            (failure) => print("Error al subir imagen: ${failure.message}"),
            (evidenceDto) {
              evidenceList.add({
                "file_path": evidenceDto.filePath,
                "file_type": evidenceDto.fileType,
                "mime_type": evidenceDto.mimeType,
                "file_size": evidenceDto.fileSize.toString(),
              });
            },
          );
        }

        answers.add({
          "component_id": item.id,
          "quantity": item.quantity ?? 0,
          "status": item.status.toUpperCase(),
          "observation": item.observation.isEmpty ? null : item.observation,
          "evidences": evidenceList,
        });
      }

      final reportRequest = {
        "press_id": state.selectedPress!.id,
        "inspection_date": DateTime.now().toIso8601String(),
        "area": state.area.isEmpty ? "General" : state.area,
        "folio": "F-${DateTime.now().millisecondsSinceEpoch}",
        "answers": answers,
        "loan": hasLoanData ? {
          "area_id": state.selectedLoanArea?.id,
          "loan_date": DateTime.now().toIso8601String(),
          "solicitants_name": state.solicitantsName,
          "observations": state.observations,
        } : null
      };

      final result = await ref
          .read(createPressReportProvider)
          .call(reportRequest);

      result.fold((f) => _showSnack("Error: ${f.message}", Colors.red), (r) {
        
        // --- DETERMINAR MENSAJE DE ÉXITO DINÁMICO ---
        String successMessage = "¡Reporte guardado!";
        
        if (currentStatus == 'LOANED') {
          successMessage = "¡Devolución exitosa!";
        } else if (currentStatus == 'AVAILABLE' && hasLoanData) {
          successMessage = "¡Préstamo exitoso!";
        } else {
          successMessage = "¡Inspección guardada con éxito!";
        }

        _showSnack(successMessage, Colors.green);

        notifier.reset();
        Navigator.pop(context);
      });
    } catch (e) {
      _showSnack("Error inesperado al guardar", Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnack(String m, Color c) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(m),
          backgroundColor: c,
          behavior: SnackBarBehavior.floating,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomHeader(
                    title: "Inspección de Prensas",
                    actionIcon: Icons.build_rounded,
                    onActionTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 32),
                  CaptureMethodSelector(
                    onManualFill: () => setState(() => isScanning = false),
                    onScan: () => setState(() => isScanning = true),
                  ),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isScanning
                        ? Container(
                            height: 400,
                            color: Colors.black,
                            child: const Center(
                              child: Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              const InformationGeneralEquipo(),
                              const SizedBox(height: 32),
                              PrensaInspectionTable(items: templateItems),
                              const SizedBox(height: 32),
                              const LoanAndInspectorSection(),
                            ],
                          ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: _actionBtn(
                          "VISTA PREVIA PDF",
                          Colors.blueGrey,
                          Icons.picture_as_pdf,
                          () => _showPdfPreview(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _actionBtn(
                          "FINALIZAR REPORTE",
                          const Color(0xFFC62828),
                          Icons.check_circle,
                          _guardarInspeccion,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
    );
  }

  Widget _actionBtn(String l, Color c, IconData i, VoidCallback t) =>
      ElevatedButton.icon(
        onPressed: t,
        icon: Icon(i, color: Colors.white, size: 20),
        label: Text(
          l,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: c,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
}