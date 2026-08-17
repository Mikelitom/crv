import 'package:crv_reprosisa/features/inspections/presentation/models/inspector_row_ui.dart';
import 'package:crv_reprosisa/features/ocr/domain/entities/report_type.dart';
// import 'package:crv_reprosisa/features/ocr/presentation/pages/ocr_debug_page.dart';
import 'package:crv_reprosisa/features/ocr/presentation/providers/image_processor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import '../provider/inspeccion_providers.dart';
import '../widgets/information_general_equipo.dart';
import '../widgets/table_componentes_press.dart';
import '../widgets/capture_method_selector.dart';
import '../widgets/prestamo_devolucion.dart';
import '../../../dashboard/presentation/widgets/header.dart';

class PrensaInspectionPage extends ConsumerStatefulWidget {
  final bool isReadOnly;
  final InspectionRowUI? itemToEdit;

  const PrensaInspectionPage({
    super.key,
    this.isReadOnly = false,
    this.itemToEdit,
  });

  @override
  ConsumerState<PrensaInspectionPage> createState() =>
      _PrensaInspectionPageState();
}

class _PrensaInspectionPageState extends ConsumerState<PrensaInspectionPage> {
  bool isScanning = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(inspeccionProvider.notifier);
      if (widget.itemToEdit != null) {
        await notifier.loadReportDetail(widget.itemToEdit!.versionId);
      } else {
        notifier.reset();
        await notifier.loadTemplate();
      }
    });
  }

  void _showPdfPreview(BuildContext context) {
    final state = ref.read(inspeccionProvider);

    final String fechaActual = DateFormat(
      'dd/MM/yyyy',
    ).format(state.inspectionDate);

    final String areaReal = state.area.trim().isNotEmpty ? state.area : "N/A";

    final Map<String, dynamic> pdfData = {
      "serie": state.selectedPress?.serie ?? "S/N",
      "fecha": fechaActual,
      "area": areaReal,
      "tipo": state.selectedPress?.type ?? "N/A",
      "modelo": state.selectedPress?.model ?? "N/A",
      "volts": state.selectedPress?.voltz ?? "N/A",
      "nombre_recibe": state.solicitantsName,
      "area_solicita": state.selectedLoanArea?.name ?? "N/A",
      "observaciones_footer": state.observations,

      "items": state.templateItems.map((item) {
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
            build: (format) => PrensaPdfGenerator.generateEsqueleto(pdfData),
            initialPageFormat: PdfPageFormat.letter.landscape,
          ),
        ),
      ),
    );
  }

  Future<void> _showStatusDialog() async {
    final state = ref.read(inspeccionProvider);

    // Validación estricta: Un componente está incompleto si su status está vacío o no es válido
    final componentesFaltantes = state.templateItems.where((item) {
      final s = item.status.trim().toUpperCase();
      return s.isEmpty || (s != 'GOOD' && s != 'BAD');
    }).toList();

    final bool estaCompleto = componentesFaltantes.isEmpty;

    final String? result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        title: Row(
          children: [
            Icon(
              estaCompleto ? Icons.check_circle : Icons.warning_amber_rounded,
              color: estaCompleto ? Colors.green : Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                estaCompleto ? "Reporte Listo" : "Componentes Faltantes",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1C1E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                estaCompleto
                    ? "¿Deseas finalizar y enviar el reporte como COMPLETADO?"
                    : "Faltan ${componentesFaltantes.length} componentes por marcar:",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444444),
                ),
              ),
              if (!estaCompleto) ...[
                const SizedBox(height: 14),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: componentesFaltantes
                            .map(
                              (c) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.5,
                                ),
                                child: Text(
                                  "• ${c.name}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(
                                      0xFFC62828,
                                    ), // Rojo institucional Reprosisa
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Se guardará automáticamente como EN PROCESO si continúas.",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF444444),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "CANCELAR",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              if (estaCompleto)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, "COMPLETED"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "COMPLETAR",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, "IN_PROGRESS"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFC62828),
                    side: const BorderSide(
                      color: Color(0xFFC62828),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "GUARDAR EN PROCESO",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (result != null) {
      ref.read(inspeccionProvider.notifier).updateState(result);
      await _guardarInspeccion();
    }
  }

  Future<void> _guardarInspeccion() async {
    final state = ref.read(inspeccionProvider);
    final notifier = ref.read(inspeccionProvider.notifier);

    if (state.selectedPress == null) {
      _showSnack("Selecciona una prensa primero", Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final String? resultId = await notifier.finalizarInspeccion();

      if (resultId != null) {
        _showSnack(
          notifier.isEditing
              ? "¡Inspección actualizada!"
              : "¡Guardada con éxito (${state.state})!",
          Colors.green,
        );
        notifier.reset();
        Navigator.pop(context);
      } else {
        _showSnack("Error al guardar en el servidor", Colors.red);
      }
    } catch (e) {
      _showSnack("Error inesperado: $e", Colors.red);
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
    final state = ref.watch(inspeccionProvider);
    final itemsToShow = state.templateItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomHeader(
                    title: widget.itemToEdit != null
                        ? "Editar Inspección de Prensa"
                        : "Inspección de Prensas",
                    actionIcon: Icons.arrow_back_ios_new_rounded,
                    onActionTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 32),
                  
                  // 1. Información general del equipo
                  const InformationGeneralEquipo(),
                  
                  const SizedBox(height: 32),
                  
                  // 2. Método de captura / OCR
                  CaptureMethodSelector(
                    onManualFill: () => setState(() => isScanning = false),
                  
                    onImageCaptured: (XFile? image) async {
                      if (image == null) return;
                  
                      final ocrNotifier = ref.read(
                        imageProcessingProvider.notifier,
                      );
                  
                      await ocrNotifier.processImage(
                        image.path,
                        ReportType.press,
                      );
                  
                      if (!mounted) return;
                  
                      final ocrState = ref.read(imageProcessingProvider);
                  
                      if (ocrState.errorMessage != null) {
                        _showSnack(
                          ocrState.errorMessage!,
                          Colors.red,
                        );
                        return;
                      }
                  
                      final result = ocrState.pressInspection;
                  
                      if (result == null) {
                        _showSnack(
                          'No se obtuvo resultado del OCR',
                          Colors.orange,
                        );
                        return;
                      }
                  
                      final inspeccionNotifier = ref.read(
                        inspeccionProvider.notifier,
                      );
                  
                      inspeccionNotifier.applyOCRResult(result);
                  
                      _showSnack(
                        'Inspección analizada correctamente',
                        Colors.green,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 3. Tabla de componentes
                  PrensaInspectionTable(items: itemsToShow),
                  
                  const SizedBox(height: 32),
                  
                  // 4. Préstamo / devolución
                  const LoanAndInspectorSection(),
                  
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
                          _showStatusDialog,
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
