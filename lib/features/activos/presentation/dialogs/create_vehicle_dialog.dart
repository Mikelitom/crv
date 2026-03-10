import 'package:crv_reprosisa/features/activos/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/create_vehicle_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:crv_reprosisa/features/activos/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateVehicleDialog extends ConsumerStatefulWidget {
  const CreateVehicleDialog({super.key});

  @override
  ConsumerState<CreateVehicleDialog> createState() => _CreateVehicleDialogState();
}

class _CreateVehicleDialogState extends ConsumerState<CreateVehicleDialog> {
  final typeIdController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final licensePlateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createVehicleProvider);

    return BaseAssetDialog(
      title: "Registrar nuevo vehiculo",
      onConfirm: () async {
        final vehicle = CreateVehicleParams(
          typeId: typeIdController.text,
          brand: brandController.text,
          model: modelController.text,
          year: yearController.text,
          licensePlate: licensePlateController.text,
        );

        await ref.read(createVehicleProvider.notifier).create(vehicle);

        final result = ref.read(createVehicleProvider);

        if (result.status == Status.success) {
          ref.invalidate(vehicleListProvider);
          Navigator.pop(context);
        }
      },
      isLoading: state.status == Status.loading,
      children: [
        if (state.status == Status.success)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Vehiculo registrado correctamente",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        buildField(typeIdController, "1", "Ej. Pickup"),
        buildField(brandController, "Marca", "Toyota"),
        buildField(modelController, "Modelo", "Corolla"),
        buildField(yearController, "Año", "2025"),
        buildField(licensePlateController,
          "Matricula",
          "123456g",
          maxLines: 2,
        ),
      ],
    );
  }
}
