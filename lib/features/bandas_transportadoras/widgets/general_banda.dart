import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/client_mine.dart';
import '../presentation/provider/banda_inspection_providers.dart';

class GeneralBandaInfo extends ConsumerStatefulWidget {
  const GeneralBandaInfo({super.key});

  @override
  ConsumerState<GeneralBandaInfo> createState() => _GeneralBandaInfoState();
}

class _GeneralBandaInfoState extends ConsumerState<GeneralBandaInfo> {
  late final TextEditingController _areaController;
  late final TextEditingController _responsableController;
  late final TextEditingController _seccionController;
  late final TextEditingController _fechaController;
  late final TextEditingController _transportadorController;
  late final TextEditingController _bandaController;
  late final TextEditingController _materialController;
  late final TextEditingController _granulometryController;
  late final TextEditingController _elaboroController;
  late final TextEditingController _presentarController;

  @override
  void initState() {
    super.initState();
    _areaController = TextEditingController();
    _responsableController = TextEditingController();
    _seccionController = TextEditingController();
    _fechaController = TextEditingController();
    _transportadorController = TextEditingController();
    _bandaController = TextEditingController();
    _materialController = TextEditingController();
    _granulometryController = TextEditingController();
    _elaboroController = TextEditingController();
    _presentarController = TextEditingController();
  }

  @override
  void dispose() {
    _areaController.dispose();
    _responsableController.dispose();
    _seccionController.dispose();
    _fechaController.dispose();
    _transportadorController.dispose();
    _bandaController.dispose();
    _materialController.dispose();
    _granulometryController.dispose();
    _elaboroController.dispose();
    _presentarController.dispose();
    super.dispose();
  }

  void _updateControllerIfNeeded(TextEditingController controller, String value) {
    if (controller.text != value) {
      final int offset = controller.selection.base.offset;
      controller.text = value;
      if (offset <= controller.text.length) {
        controller.selection = TextSelection.fromPosition(TextPosition(offset: offset));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bandaInspectionProvider);

    _updateControllerIfNeeded(_areaController, state.area);
    _updateControllerIfNeeded(_responsableController, state.conveyorResponsible);
    _updateControllerIfNeeded(_seccionController, state.seccion);
    _updateControllerIfNeeded(_fechaController, state.inspectionDate.toString().split(' ')[0]);
    _updateControllerIfNeeded(_transportadorController, state.conveyor);
    _updateControllerIfNeeded(_bandaController, state.recommendedBelt);
    _updateControllerIfNeeded(_materialController, state.material);
    _updateControllerIfNeeded(_granulometryController, state.granulometry);
    _updateControllerIfNeeded(_elaboroController, state.elaboro);
    _updateControllerIfNeeded(_presentarController, state.presentTo);
    
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 800;
      
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Información General del Reporte", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildDropdownMine(constraints.maxWidth, isMobile, state, ref),
                _buildField("ÁREA", _areaController, constraints.maxWidth, isMobile, 
                    (val) => ref.read(bandaInspectionProvider.notifier).updateArea(val)),
                _buildField("RESPONSABLE", _responsableController, constraints.maxWidth, isMobile, 
                    (val) => ref.read(bandaInspectionProvider.notifier).updateConveyorResponsible(val)),
                _buildField("SECCIÓN", _seccionController, constraints.maxWidth, isMobile, 
                    (val) => ref.read(bandaInspectionProvider.notifier).updateSeccion(val)),
                _buildField("FECHA", _fechaController, constraints.maxWidth, isMobile, null),
                _buildField("TRANSPORTADOR", _transportadorController, constraints.maxWidth, isMobile, 
                    (val) => ref.read(bandaInspectionProvider.notifier).updateConveyor(val)),
                _buildField("BANDA RECOMENDADA", _bandaController, constraints.maxWidth, isMobile, 
                    (val) => ref.read(bandaInspectionProvider.notifier).updateRecommendedBelt(val)),
                
                // --- CONTENEDOR DIVIDIDO EN FILA PARA MATERIAL Y GRANULOMETRÍA ---
                _buildMaterialAndGranulometryFields(constraints.maxWidth, isMobile),
                
                _buildField("ELABORÓ", _elaboroController, constraints.maxWidth, isMobile, 
                    (val) => ref.read(bandaInspectionProvider.notifier).updateElaboro(val)),                
                _buildField("PRESENTAR A", _presentarController, constraints.maxWidth, isMobile, 
                    (val) => ref.read(bandaInspectionProvider.notifier).updatePresentTo(val)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMaterialAndGranulometryFields(double maxWidth, bool isMobile) {
    double fieldWidth = isMobile ? maxWidth : (maxWidth / 2) - 52;
    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("MATERIAL Y GRANULOMETRÍA", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _materialController,
                  onChanged: (val) => ref.read(bandaInspectionProvider.notifier).updateMaterial(val),
                  decoration: _inputDecoration().copyWith(hintText: "Material"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _granulometryController,
                  onChanged: (val) => ref.read(bandaInspectionProvider.notifier).updateGranulometry(val),
                  decoration: _inputDecoration().copyWith(hintText: "Granulometría"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownMine(double width, bool isMobile, dynamic state, WidgetRef ref) {
    double fieldWidth = isMobile ? width : (width / 2) - 52;
    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("PLANTA (MINA)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(),
            value: state.selectedMine?.id,
            items: state.filteredMines.map<DropdownMenuItem<String>>((Mine mine) {
              return DropdownMenuItem<String>(value: mine.id, child: Text(mine.name));
            }).toList(),
            onChanged: (id) {
              if (id != null) {
                final mine = state.filteredMines.firstWhere((m) => m.id == id);
                ref.read(bandaInspectionProvider.notifier).selectMine(mine);
              }
            },
            hint: const Text("Seleccione Planta"),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, double maxWidth, bool isMobile, Function(String)? onChanged) {
    double fieldWidth = isMobile ? maxWidth : (maxWidth / 2) - 52;
    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF8F9FA),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDE1E6))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5)),
  );
}