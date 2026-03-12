import 'package:crv_reprosisa/features/activos/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/type_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/create_vehicle_notifier_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:crv_reprosisa/features/activos/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateVehicleDialog extends ConsumerStatefulWidget {
  const CreateVehicleDialog({super.key});

  @override
  ConsumerState<CreateVehicleDialog> createState() =>
      _CreateVehicleDialogState();
}

class _CreateVehicleDialogState extends ConsumerState<CreateVehicleDialog> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(typeListProvider.notifier).loadTypes();
    });
  }

  String? selectedTypeId;
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final licensePlateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createVehicleProvider);
    final typeState = ref.watch(typeListProvider);

    return BaseAssetDialog(
      title: "Registrar nuevo vehiculo",
      onConfirm: () async {
        if (selectedTypeId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Seleccione un tipo de vehículo")),
          );
          return;
        }

        final vehicle = CreateVehicleParams(
          typeId: selectedTypeId!,
          brand: brandController.text,
          model: modelController.text,
          year: int.parse(yearController.text),
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

        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  "Tipo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF454B4E),
                  ),
                ),
              ),
              if (typeState.status == Status.loading)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<String>(
                  initialValue: selectedTypeId,
                  decoration: InputDecoration(
                    hintText: "Seleccionar tipo",
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    contentPadding: const EdgeInsets.all(18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFD32F2F),
                        width: 2,
                      ),
                    ),
                  ),
                  items: typeState.types
                      .map<DropdownMenuItem<String>>(
                        (type) => DropdownMenuItem<String>(
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
            ],
          ),
        ),
        buildField(brandController, "Marca", "Toyota"),
        buildField(modelController, "Modelo", "Corolla"),
        Row(
          children: [
            Expanded(child: buildField(yearController, "Año", "2026")),
            const SizedBox(width: 16),
            Expanded(
              child: buildField(licensePlateController, "Placas", "ABC-123"),
            ),
          ],
        ),
      ],
    );
  }
}
