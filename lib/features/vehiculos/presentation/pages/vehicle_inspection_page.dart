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
    // Determinamos si estamos editando para mostrar un mensaje más preciso
    final bool esEdicion = widget.itemToEdit != null;
    
    // Llamamos al método que ya configuramos en el Notifier
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

    // Sincroniza el controlador cuando los datos llegan de la API (modo edición)
    ref.listen(vehicleInspectionProvider.select((s) => s.generalNotes), (prev, next) {
      if (_notesController.text != next) {
        _notesController.text = next;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(vehicleSyncServiceProvider).syncPendingReports();
        },
        child: const Icon(Icons.sync),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
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
                                      // Buscamos en state.items (donde vive la data cargada de la API)
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
                              
                              TextField(
                                controller: _notesController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: "NOTAS:",
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onChanged: (value) => notifier.setGeneralNotes(value),
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
  // 1. Obtén el estado actual desde el ref
  final state = ref.read(vehicleInspectionProvider);
  
  // 2. Validar si está completo
  final bool estaCompleto = state.items.every((item) => item.selectedOptionId != null);
  
  final String? result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      // Responsividad: Limitamos el ancho al 90% de la pantalla para evitar desbordes
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            estaCompleto ? Icons.check_circle : Icons.warning_amber_rounded, 
            color: estaCompleto ? Colors.green : Colors.orange
          ),
          const SizedBox(width: 10),
          Expanded( // Expanded evita que un título largo rompa el diseño
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
            : "Faltan componentes por inspeccionar. El reporte se guardará automáticamente como EN PROCESO.",
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      // Usamos Wrap para que los botones se acomoden en filas si no caben en una
      actions: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.end,
          children: [
            // BOTÓN CANCELAR
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text("CANCELAR", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            
            // BOTÓN EN PROCESO
            OutlinedButton(
              onPressed: () => Navigator.pop(context, "IN_PROGRESS"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("EN PROCESO"),
            ),
            
            // BOTÓN COMPLETAR
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

  // 3. Ejecutar acción si hubo una selección
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
