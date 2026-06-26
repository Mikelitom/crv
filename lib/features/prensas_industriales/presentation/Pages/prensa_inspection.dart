import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import '../../domain/entities/component_item.dart';
import '../provider/inspeccion_providers.dart';
import '../../../../features/evidence/presentation/providers/evidence_service_provider.dart';
import '../widgets/information_general_equipo.dart';
import '../widgets/table_componentes_press.dart';
import '../widgets/capture_method_selector.dart';
import '../widgets/prestamo_devolucion.dart';
import '../../../dashboard/presentation/widgets/header.dart';

class PrensaInspectionPage extends ConsumerStatefulWidget {
  final bool isReadOnly;
  const PrensaInspectionPage({super.key, this.isReadOnly = false});

  @override
  ConsumerState<PrensaInspectionPage> createState() =>
      _PrensaInspectionPageState();
}

class _PrensaInspectionPageState extends ConsumerState<PrensaInspectionPage> {
  bool isScanning = false;
  bool isLoading = true;
  List<ComponentItem> templateItems = [];

  static const Set<String> excludedComponentIds = {
    "70f9a2a0-ed74-4958-97aa-87a279cdbdd7",
    "97b38d7b-53bf-43bb-9459-cc2db92d89ad",
    "335fcf27-4a9c-4302-bf20-29dd0ad4b8ac",
    "b1c263cd-5882-4153-b48a-04859e79f2ed",
    "7c0bcebc-ce53-4a1e-8cf1-1b83e6782f53",
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(inspeccionProvider, (previous, next) {
        if (previous?.selectedPress?.id != next.selectedPress?.id) {
          _fetchTemplate();
        }
      });
      _fetchTemplate();
    });
  }

  Future<void> _fetchTemplate() async {
    setState(() => isLoading = true);

    final state = ref.read(inspeccionProvider);
    final repo = ref.read(inspeccionRepositoryProvider);

    final result = await repo.getInspectionTemplate();

    final String tipoPrensa =
        state.selectedPress?.type?.toLowerCase() ?? "";

    result.fold(
      (failure) => setState(() => isLoading = false),
      (components) {
        List<ComponentItem> itemsFiltrados = components;

        final bool esNeumaticaOMovil =
            tipoPrensa.contains("neumática") ||
            tipoPrensa.contains("movil") ||
            tipoPrensa.contains("móvil");

        if (esNeumaticaOMovil) {
          itemsFiltrados = components
              .where((c) => !excludedComponentIds.contains(c.id))
              .toList();
        }

        setState(() {
          templateItems = itemsFiltrados;
          isLoading = false;
        });
      },
    );
  }

  void _showPdfPreview(BuildContext context) {
    final state = ref.read(inspeccionProvider);
    final String fechaActual =
        DateFormat('dd/MM/yyyy').format(state.inspectionDate);

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
      "items": templateItems.map((item) {
        return {
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
        };
      }).toList(),
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
            build: (format) =>
                PrensaPdfGenerator.generateEsqueleto(pdfData),
            initialPageFormat: PdfPageFormat.letter.landscape,
          ),
        ),
      ),
    );
  }

Future<void> _showStatusDialog() async {
  // 1. Identificar componentes faltantes
  final componentesFaltantes = templateItems.where((item) => item.status.isEmpty).toList();
  final bool estaCompleto = componentesFaltantes.isEmpty;
  
  final String? result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      // Responsividad: Máximo 90% del ancho de pantalla
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            estaCompleto ? Icons.check_circle : Icons.warning_amber_rounded, 
            color: estaCompleto ? Colors.green : Colors.orange.shade800
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              estaCompleto ? "Reporte Listo" : "Reporte Incompleto",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: Text(
        estaCompleto 
            ? "¿Deseas finalizar y enviar el reporte como COMPLETADO?" 
            : "Faltan ${componentesFaltantes.length} componentes por inspeccionar. Se guardará como EN PROCESO.",
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      // Usamos Wrap para que los botones no causen overflow en móviles
      actions: [
        Wrap(
          spacing: 8.0, 
          runSpacing: 8.0,
          alignment: WrapAlignment.end,
          children: [
            // CANCELAR
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text("CANCELAR", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            
            // EN PROCESO
            OutlinedButton(
              onPressed: () => Navigator.pop(context, "IN_PROGRESS"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("EN PROCESO"),
            ),
            
            // COMPLETAR
            if (estaCompleto)
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "COMPLETED"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("COMPLETAR"),
              ),
          ],
        ),
      ],
    ),
  );

  // 2. Ejecutar la acción
  if (result != null) {
    ref.read(inspeccionProvider.notifier).updateState(result);
    await _guardarInspeccion();
  }
}
  Future<void> _guardarInspeccion() async {
    final state = ref.read(inspeccionProvider);
    final notifier = ref.read(inspeccionProvider.notifier);
    final evidenceService = ref.read(evidenceServiceProvider);

    if (state.selectedPress == null) {
      _showSnack("Selecciona una prensa primero", Colors.orange);
      return;
    }

    final bool hasLoanData =
        state.selectedLoanArea != null || state.solicitantsName.isNotEmpty;

    final String currentStatus = state.status.toUpperCase();

    if (currentStatus == 'LOANED' && !hasLoanData) {
      _showSnack(
        "La prensa está prestada. Debe llenar los campos de devolución para continuar.",
        Colors.red,
      );
      return;
    }

    final answeredItems =
        templateItems.where((item) => item.status.isNotEmpty).toList();

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
          "observation":
              item.observation.isEmpty ? null : item.observation,
          "evidences": evidenceList,
        });
      }

      final reportRequest = {
        "press_id": state.selectedPress!.id,
        "inspection_date": DateTime.now().toIso8601String(),
        "area": state.area.isEmpty ? "General" : state.area,
        "state": state.state, 
        "folio": "F-${DateTime.now().millisecondsSinceEpoch}",
        "answers": answers,
        "loan": hasLoanData
            ? {
                "area_id": state.selectedLoanArea?.id,
                "loan_date": DateTime.now().toIso8601String(),
                "solicitants_name": state.solicitantsName,
                "observations": state.observations,
              }
            : null
      };

      final result = await ref
          .read(createPressReportProvider)
          .call(reportRequest);

      result.fold(
        (f) => _showSnack("Error: ${f.message}", Colors.red),
        (r) {
          String successMessage = "¡Inspección guardada con éxito!";

          if (currentStatus == 'LOANED') {
            successMessage = "¡Devolución exitosa!";
          } else if (currentStatus == 'AVAILABLE' && hasLoanData) {
            successMessage = "¡Préstamo exitoso!";
          }

          _showSnack(successMessage, Colors.green);

          notifier.reset();
          Navigator.pop(context);
        },
      );
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
              child: CircularProgressIndicator(
                color: Color(0xFFC62828),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomHeader(
                    title: "Inspección de Prensas",
                    actionIcon: Icons.arrow_back_ios_new_rounded,
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
                              PrensaInspectionTable(
                                items: templateItems,
                              ),
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
    "FINALIZAR",
    const Color(0xFFC62828),
    Icons.check_circle,
    _showStatusDialog, // <--- LLAMA AL DIÁLOGO, NO A _finalizar DIRECTO
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

  Widget _actionBtn(
    String l,
    Color c,
    IconData i,
    VoidCallback t,
  ) =>
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