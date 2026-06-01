import 'package:crv_reprosisa/features/vehiculos/data/services/vehicle_sync_service.dart';
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
  // Definición del parámetro para evitar el error 'isReadOnly isn't defined'
  final bool isReadOnly;

  const VehicleInspectionPage({super.key, this.isReadOnly = false});

  @override
  ConsumerState<VehicleInspectionPage> createState() =>
      _VehicleInspectionPageState();
}

class _VehicleInspectionPageState extends ConsumerState<VehicleInspectionPage> {
  // Controlador para el campo de Notas
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(vehicleInspectionProvider);
    _notesController = TextEditingController(text: state.generalNotes);
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
    final resultId = await ref
        .read(vehicleInspectionProvider.notifier)
        .finalizarInspeccion();
    if (resultId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Inspección guardada con éxito!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al guardar el reporte"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleInspectionProvider);
    final notifier = ref.read(vehicleInspectionProvider.notifier);

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
                    title: "Inspección de Unidades",
                    actionIcon: Icons.directions_car,
                    onActionTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 24),
                  CaptureMethodSelector(
                    onManualFill: () => notifier.setScanning(false),
                    onScan: () => notifier.setScanning(true),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: state.isScanning
                        ? const SizedBox(
                            height: 300,
                            child: Center(
                              child: Icon(
                                Icons.qr_code_scanner,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              const GeneralVehicleInfo(),
                              const SizedBox(height: 24),
                              ...state.templateSections.map((section) {
                                final List<ComponentVehicleModel> sectionItems =
                                    (section['components'] as List).map((c) {
                                      final existing = state.items.where(
                                        (i) => i.id == c['id'],
                                      );
                                      if (existing.isNotEmpty) {
                                        return existing.first;
                                      } else {
                                        return ComponentVehicleModel(
                                          id: c['id'],
                                          description: c['name'],
                                        );
                                      }
                                    }).toList();
                                return VehicleInspectionSection(
                                  title: section['name'],
                                  items: sectionItems,
                                );
                              }).toList(),
                              const VehicleServiceRequired(),

                              // CAMPO DE NOTAS AGREGADO AQUÍ
                              const SizedBox(height: 24),
                              TextField(
                                controller: _notesController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: "NOTAS:",
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onChanged: (value) =>
                                    notifier.setGeneralNotes(value),
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
                          _finalizar,
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
