import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_component_provider_v.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartServiceDialog extends ConsumerStatefulWidget {
  final ServiceOrderModel order;
  final String vehicleId;

  const StartServiceDialog({
    super.key,
    required this.order,
    required this.vehicleId,
  });

  @override
  ConsumerState<StartServiceDialog> createState() => _StartServiceDialogState();
}

class _StartServiceDialogState extends ConsumerState<StartServiceDialog> {
  late final TextEditingController _locationController;
  late final TextEditingController _mileageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _mileageController = TextEditingController();
  }

  @override
  void dispose() {
    ref.read(startServiceNotifierProvider.notifier).reset();
    _locationController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  Future<void> _refreshAllData() async {
    final vehicleId = widget.vehicleId;
    await ref.read(serviceListNotifierProvider.notifier).loadServices(vehicleId);
    await ref.read(vehicleHistoryProvider.notifier).loadHistory(vehicleId);
    await ref.read(pendingComponentNotifierProvider.notifier).loadPendingComponents(vehicleId);
    await ref.read(incidenceNotifierProvider.notifier).loadIncidences(vehicleId);
  }

  Future<void> _startService() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(startServiceNotifierProvider.notifier);
    await notifier.startService(
      widget.order.id,
      _locationController.text.trim(),
      int.parse(_mileageController.text),
    );
    final state = ref.read(startServiceNotifierProvider);
    if (!mounted) return;
    if (state.status == Status.success) {
      await _refreshAllData();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(startServiceNotifierProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Iniciar orden de servicio",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Ubicación",
                  hintText: "Ej. Taller Hermosillo",
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFFC62828)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
                  ),
                ),
                validator: (value) => (value == null || value.trim().isEmpty) ? "Ingrese una ubicación" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mileageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Kilometraje",
                  hintText: "Ej. 152340",
                  prefixIcon: const Icon(Icons.speed, color: Color(0xFFC62828)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Ingrese el kilometraje";
                  if (int.tryParse(value) == null) return "Kilometraje inválido";
                  return null;
                },
              ),
              if (state.status == Status.error) ...[
                const SizedBox(height: 16),
                Text(state.error ?? "Ocurrió un error", style: const TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: state.status == Status.loading ? null : () => Navigator.pop(context),
                    child: const Text("Cancelar", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: state.status == Status.loading ? null : _startService,
                    child: state.status == Status.loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Iniciar", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}