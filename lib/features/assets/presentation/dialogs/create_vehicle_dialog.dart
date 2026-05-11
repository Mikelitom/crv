import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/type_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/create_vehicle_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/type_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateVehicleDialog extends ConsumerStatefulWidget {
  const CreateVehicleDialog({super.key});

  @override
  ConsumerState<CreateVehicleDialog> createState() =>
      _CreateVehicleDialogState();
}

class _CreateVehicleDialogState extends ConsumerState<CreateVehicleDialog> {
  final _formKey = GlobalKey<FormState>();

  String? selectedTypeId;
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final licensePlateController = TextEditingController();
  final unitController = TextEditingController(); // Controlador para Unidad

  bool _success = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual(createVehicleProvider, (previous, next) async {
      if (!mounted) return;

      if (next.status == Status.success) {
        setState(() => _success = true);
        ref.read(vehicleListProvider.notifier).loadVehicles();
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pop(context, true);
      }

      if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error ?? "Error al registrar vehículo"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    licensePlateController.dispose();
    unitController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createVehicleProvider);
    final typeState = ref.watch(typeListProvider);
    final vehicleState = ref.read(vehicleListProvider);

    return BaseAssetDialog(
      title: _success ? "" : "Registrar nuevo vehículo",
      onConfirm: _success
          ? null
          : () async {
              if (!_formKey.currentState!.validate()) return;
              if (selectedTypeId == null) return;

              final year = int.tryParse(yearController.text.trim());
              final unit = int.tryParse(unitController.text.trim()); // Parseo de unidad
              
              if (year == null || unit == null) return;

              final vehicle = CreateVehicleParams(
                typeId: selectedTypeId!,
                brand: brandController.text.trim(),
                model: modelController.text.trim(),
                unit: unit, // Asignación de unidad
                year: year,
                plate: licensePlateController.text.trim(),
              );

              await ref.read(createVehicleProvider.notifier).create(vehicle);
            },
      isLoading: (state.status == Status.loading || typeState.status == Status.loading) && !_success,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _success ? _buildSuccessState() : _buildForm(typeState, vehicleState),
        ),
      ],
    );
  }

  Widget _buildForm(TypeListState typeState, VehicleListState vehicleState) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey("form"),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: DropdownButtonFormField<String>(
              value: selectedTypeId,
              validator: (value) => value == null ? "Seleccione un tipo de vehículo" : null,
              decoration: InputDecoration(
                hintText: "Seleccionar tipo",
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                contentPadding: const EdgeInsets.all(18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              items: typeState.types.map<DropdownMenuItem<String>>((type) => 
                DropdownMenuItem<String>(
                  value: type.id.toString(),
                  child: Text(type.name),
                )).toList(),
              onChanged: (value) => setState(() => selectedTypeId = value),
            ),
          ),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: _customBuildField(
                  brandController,
                  "Marca",
                  "Toyota",
                  validator: (value) => value == null || value.trim().isEmpty ? "Marca obligatoria" : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _customBuildField(
                  unitController,
                  "Unidad",
                  "101",
                  keyboardType: TextInputType.number, // Teclado numérico para unidad
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Obligatorio";
                    if (int.tryParse(value) == null) return "Número inválido";
                    return null;
                  },
                ),
              ),
            ],
          ),

          _customBuildField(
            modelController,
            "Modelo",
            "Corolla",
            validator: (value) => value == null || value.trim().isEmpty ? "Modelo obligatorio" : null,
          ),

          Row(
            children: [
              Expanded(
                child: _customBuildField(
                  yearController,
                  "Año",
                  "2026",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Año obligatorio";
                    final year = int.tryParse(value);
                    if (year == null) return "Número inválido";
                    if (year < 1900 || year > DateTime.now().year + 1) return "Año inválido";
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _customBuildField(
                  licensePlateController,
                  "Placas",
                  "ABC-123",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Placas obligatorias";
                    final exists = vehicleState.vehicles.any((v) => v.plate.toUpperCase() == value.trim().toUpperCase());
                    if (exists) return "Ya registrada";
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return SizedBox(
      key: const ValueKey("success"),
      height: 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _success ? 1 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 60, color: Colors.green.shade600),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Vehículo registrado", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Función auxiliar corregida con keyboardType
  Widget _customBuildField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType, // Se aplica el tipo de teclado
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.all(18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}