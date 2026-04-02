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
              if (year == null) return; // 🔥 protección extra

              final vehicle = CreateVehicleParams(
                typeId: selectedTypeId!,
                brand: brandController.text.trim(),
                model: modelController.text.trim(),
                year: year,
                licensePlate: licensePlateController.text.trim(),
              );

              await ref.read(createVehicleProvider.notifier).create(vehicle);
            },
      isLoading:
          (state.status == Status.loading ||
              typeState.status == Status.loading) &&
          !_success,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _success ? _buildSuccessState() : _buildForm(typeState, vehicleState),
        ),
      ],
    );
  }

  /// FORM
  Widget _buildForm(TypeListState typeState, VehicleListState vehicleState) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey("form"),
        children: [
          /// 🔽 DROPDOWN (CORREGIDO)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: DropdownButtonFormField<String>(
              value: selectedTypeId,
              validator: (value) {
                if (value == null) {
                  return "Seleccione un tipo de vehículo";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Seleccionar tipo",
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                contentPadding: const EdgeInsets.all(18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              items: typeState.types
                  .map<DropdownMenuItem<String>>(
                    (type) => DropdownMenuItem<String>(
                      value: type.id.toString(), // 🔥 importante
                      child: Text(type.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTypeId = value;
                });
              },
            ),
          ),

          buildField(
            brandController,
            "Marca",
            "Toyota",
            validator: (value) => value == null || value.trim().isEmpty
                ? "Marca obligatoria"
                : null,
          ),

          buildField(
            modelController,
            "Modelo",
            "Corolla",
            validator: (value) => value == null || value.trim().isEmpty
                ? "Modelo obligatorio"
                : null,
          ),

          Row(
            children: [
              Expanded(
                child: buildField(
                  yearController,
                  "Año",
                  "2026",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Año obligatorio";
                    }

                    final year = int.tryParse(value);
                    if (year == null) {
                      return "Debe ser un número";
                    }

                    if (year < 1900 || year > DateTime.now().year + 1) {
                      return "Año inválido";
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: buildField(
                  licensePlateController,
                  "Placas",
                  "ABC-123",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Placas obligatorias";
                    }

                    final exists = vehicleState.vehicles.any(
                      (v) =>
                          v.licensePlate == licensePlateController.text.trim(),
                    );

                    if (exists) {
                      return "Placas ya registradas";
                    }

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

  /// SUCCESS UI
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
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Vehículo registrado",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
