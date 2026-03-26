import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/type_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/create_vehicle_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
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

  @override
  Widget build(BuildContext context) {
    ref.listen(createVehicleProvider, (previous, next) {
      if (next.status == Status.success) {
        ref.invalidate(vehicleListProvider);
        Navigator.pop(context);
      }

      if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? "Error al registrar vehiculo")),
        );
      }
    });


    final state = ref.watch(createVehicleProvider);
    final typeState = ref.watch(typeListProvider);

    return BaseAssetDialog(
      title: "Registrar nuevo vehiculo",
      onConfirm: () async {
        if (!_formKey.currentState!.validate()) return;

        final vehicle = CreateVehicleParams(
          typeId: selectedTypeId!,
          brand: brandController.text.trim(),
          model: modelController.text.trim(),
          year: int.parse(yearController.text.trim()),
          licensePlate: licensePlateController.text.trim(),
        );

        await ref.read(createVehicleProvider.notifier).create(vehicle);
      },
      isLoading: state.status == Status.loading || typeState.status == Status.loading,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔽 Tipo (Dropdown con validación)
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
                      .map(
                        (type) => DropdownMenuItem(
                          value: type.id,
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
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "Marca obligatoria"
                        : null,
              ),

              buildField(
                modelController,
                "Modelo",
                "Corolla",
                validator: (value) =>
                    value == null || value.trim().isEmpty
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
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
