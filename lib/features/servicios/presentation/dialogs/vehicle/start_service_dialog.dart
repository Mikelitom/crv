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

    await ref
        .read(serviceListNotifierProvider.notifier)
        .loadServices(vehicleId);

    await ref.read(vehicleHistoryProvider.notifier).loadHistory(vehicleId);

    await ref
        .read(pendingComponentNotifierProvider.notifier)
        .loadPendingComponents(vehicleId);

    await ref
        .read(incidenceNotifierProvider.notifier)
        .loadIncidences(vehicleId);
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

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(startServiceNotifierProvider);

    return AlertDialog(
      title: const Text("Iniciar orden de servicio"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Ubicación",
                  hintText: "Ej. Taller Hermosillo",
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese una ubicación";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _mileageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Kilometraje",
                  hintText: "Ej. 152340",
                  prefixIcon: Icon(Icons.speed),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese el kilometraje";
                  }

                  if (int.tryParse(value) == null) {
                    return "Kilometraje inválido";
                  }

                  return null;
                },
              ),

              if (state.status == Status.error) ...[
                const SizedBox(height: 12),
                Text(
                  state.error ?? "Ocurrió un error",
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.status == Status.loading
              ? null
              : () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        FilledButton(
          onPressed: state.status == Status.loading ? null : _startService,
          child: state.status == Status.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Iniciar"),
        ),
      ],
    );
  }
}
