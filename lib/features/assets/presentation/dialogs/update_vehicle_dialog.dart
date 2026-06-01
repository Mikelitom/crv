import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateVehicleDialog extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  const UpdateVehicleDialog({super.key, required this.vehicle});

  @override
  ConsumerState<UpdateVehicleDialog> createState() => _UpdateVehicleDialogState();
}

class _UpdateVehicleDialogState extends ConsumerState<UpdateVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController unitController;
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController yearController;

  @override
  void initState() {
    super.initState();
    unitController = TextEditingController(text: widget.vehicle.unit.toString());
    brandController = TextEditingController(text: widget.vehicle.brand);
    modelController = TextEditingController(text: widget.vehicle.model);
    yearController = TextEditingController(text: widget.vehicle.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BaseAssetDialog(
      title: "Actualizar Vehículo",
      onConfirm: () async {
        if (!_formKey.currentState!.validate()) return;
        
        final params = CreateVehicleParams(
          typeId: widget.vehicle.type,
          brand: brandController.text,
          model: modelController.text,
          unit: int.tryParse(unitController.text) ?? 0,
          year: int.tryParse(yearController.text) ?? DateTime.now().year,
          plate: widget.vehicle.plate, 
        );

        // Actualizamos
        await ref.read(vehicleListProvider.notifier).updateVehicle(widget.vehicle.vehicleId, params);
        
        if (mounted) {
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text("Vehículo actualizado con éxito"),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context);
        }
      },
      children: [
        // Tarjeta contenedora con sombra suave para mejorar el diseño
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildModernField(label: "Placa", initialValue: widget.vehicle.plate, icon: Icons.badge, enabled: false),
                const SizedBox(height: 8),
                _buildModernField(label: "Unidad", controller: unitController, icon: Icons.numbers, type: TextInputType.number),
                _buildModernField(label: "Marca", controller: brandController, icon: Icons.branding_watermark),
                _buildModernField(label: "Modelo", controller: modelController, icon: Icons.directions_car),
                _buildModernField(label: "Año", controller: yearController, icon: Icons.calendar_today, type: TextInputType.number),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernField({
    TextEditingController? controller,
    String? initialValue,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        enabled: enabled,
        keyboardType: type,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: enabled ? Colors.grey.shade700 : Colors.grey.shade400),
          prefixIcon: Icon(icon, color: const Color(0xFFC62828), size: 22),
          filled: true,
          fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5),
          ),
        ),
      ),
    );
  }
}