import 'package:crv_reprosisa/features/inspections/presentation/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../provider/vehicle_inspection_provider.dart';
import '../../../../core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';
import '../widgets/General_vehicle_info.dart';
import '../widgets/Vehicle_inspection_section.dart';
import '../widgets/Service_Vehicle_required.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../../prensas_industriales/presentation/widgets/capture_method_selector.dart';
import '../../data/models/component_vehicle_model.dart';

class VehicleInspectionPage extends ConsumerStatefulWidget {
  final bool isReadOnly;
  final InspectionRowUI? itemToEdit;

  const VehicleInspectionPage({
    super.key, 
    this.isReadOnly = false, 
    this.itemToEdit,
  });

  @override
  ConsumerState<VehicleInspectionPage> createState() =>
      _VehicleInspectionPageState();
}

class _VehicleInspectionPageState extends ConsumerState<VehicleInspectionPage> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      Future.microtask(() {
        ref.read(vehicleInspectionProvider.notifier)
           .loadReportDetail(widget.itemToEdit!.versionId);
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showPdfPreview(BuildContext context) {
    final state = ref.read(vehicleInspectionProvider);
    if (state.selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona un vehículo primero"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final pdfData = VehiculoPdfGenerator.mapStateToPdfData(state);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Vista Previa REPROSISA"),
            backgroundColor: const Color(0xFFC62828),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: PdfPreview(
            build: (format) => VehiculoPdfGenerator.generateEsqueleto(pdfData),
            initialPageFormat: PdfPageFormat.letter,
          ),
        ),
      ),
    );
  }

  Future<void> _finalizar() async {
    final bool esEdicion = widget.itemToEdit != null;
    
    final resultId = await ref
        .read(vehicleInspectionProvider.notifier)
        .finalizarInspeccion();

    if (mounted) {
      if (resultId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              esEdicion 
                  ? "¡Inspección actualizada con éxito!" 
                  : "¡Inspección guardada con éxito!"
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              esEdicion 
                  ? "Error al actualizar el reporte" 
                  : "Error al guardar el reporte"
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleInspectionProvider);
    final notifier = ref.read(vehicleInspectionProvider.notifier);

    ref.listen(vehicleInspectionProvider.select((s) => s.generalNotes), (prev, next) {
      if (_notesController.text != next) {
        _notesController.text = next;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Pantalla de carga general institucional
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFC62828)),
                  SizedBox(height: 16),
                  Text("Procesando información, por favor espere...", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomHeader(
                    title: widget.itemToEdit != null ? "Editar Inspección" : "Inspección de Unidades",
                    actionIcon: Icons.arrow_back_ios_new_rounded,
                    onActionTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 24),
                  CaptureMethodSelector(
                    onManualFill: () => notifier.setScanning(false),
                    onImageCaptured: (image) {
                      if (image != null) {
                        notifier.setScanning(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("¡Imagen capturada con éxito!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: state.isScanning
                        ? const SizedBox(
                            height: 300,
                            child: Center(
                              child: Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey),
                            ),
                          )
                        : Column(
                            key: const ValueKey('form_column'),
                            children: [
                              const GeneralVehicleInfo(),
                              const SizedBox(height: 24),
                              
                              ...state.templateSections.map((section) {
                                final List<ComponentVehicleModel> sectionItems =
                                    (section['components'] as List).map((c) {
                                      final index = state.items.indexWhere((i) => i.id == c['id']);
                                      return index != -1 
                                          ? state.items[index] 
                                          : ComponentVehicleModel(id: c['id'], description: c['name']);
                                    }).toList();
                                
                                return VehicleInspectionSection(
                                  title: section['name'],
                                  items: sectionItems,
                                );
                              }).toList(),
                              
                              const VehicleServiceRequired(),
                              const SizedBox(height: 24),
                              
                              // Nuevo diseño para las Notas Generales (Fondo blanco, contenedor estilizado sin bordes toscos)
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFEAECEF), width: 1.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.note_alt_outlined, size: 18, color: Color(0xFFC62828)),
                                        SizedBox(width: 8),
                                        Text(
                                          "OBSERVACIONES / NOTAS GENERALES",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF1A1C1E),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _notesController,
                                      maxLines: 4,
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF1A1C1E), fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        hintText: "Escribe aquí cualquier observación relevante sobre la unidad...",
                                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                                        filled: true,
                                        fillColor: Colors.white,
                                        isDense: true,
                                        contentPadding: const EdgeInsets.all(14),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5),
                                        ),
                                      ),
                                      onChanged: (value) => notifier.setGeneralNotes(value),
                                    ),
                                  ],
                                ),
                              ),
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
                          _showStatusDialog,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Future<void> _showStatusDialog() async {
    final state = ref.read(vehicleInspectionProvider);
    
    final componentesFaltantes = state.items.where((item) => item.selectedOptionId == null).toList();
    final bool estaCompleto = componentesFaltantes.isEmpty;
    
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
                estaCompleto ? "Reporte Listo" : "Componentes Faltantes",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                estaCompleto 
                    ? "¿Deseas finalizar y enviar el reporte como COMPLETADO?" 
                    : "Faltan ${componentesFaltantes.length} componentes por marcar:",
                style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
              ),
              if (!estaCompleto) ...[
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: componentesFaltantes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            "• ${componentesFaltantes[index].description}",
                            style: const TextStyle(fontSize: 12, color: Color(0xFFC62828), fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Se guardará automáticamente como EN PROCESO si continúas.",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ]
            ],
          ),
        ),
        actions: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: Colors.grey.shade700),
                child: const Text("CANCELAR", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, "IN_PROGRESS"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFC62828),
                  side: const BorderSide(color: Color(0xFFC62828)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("GUARDAR EN PROCESO"),
              ),
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

    if (result != null) {
      ref.read(vehicleInspectionProvider.notifier).updateReportState(result);
      await _finalizar();
    }
  }

  Widget _actionBtn(String l, Color c, IconData i, VoidCallback t) => SizedBox(
    height: 55,
    child: ElevatedButton.icon(
      onPressed: t,
      icon: Icon(i, color: Colors.white),
      label: Text(
        l,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: c,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}