import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/create_service_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/create_service_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_component_provider_v.dart';

class CreateOrderDialog extends ConsumerStatefulWidget {
  final String vehicleId;
  const CreateOrderDialog({super.key, required this.vehicleId});

  @override
  ConsumerState<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends ConsumerState<CreateOrderDialog> {
  final _descController = TextEditingController();
  final _obsController = TextEditingController();
  final Set<String> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    final pendingState = ref.watch(pendingComponentNotifierProvider);
    final createServiceState = ref.watch(createServiceNotifierProvider);

    ref.listen(createServiceNotifierProvider, (previous, next) {
      if (next.status == Status.success) {
        // Mostramos el éxito con el número de orden
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Orden ${next.orderNumber ?? ''} creada con éxito!"), 
            backgroundColor: Colors.green
          ),
        );
        Navigator.pop(context); // Esto cierra el diálogo y dispara el .then() de ServiceDetailView
      } else if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${next.error}"), backgroundColor: Colors.red),
        );
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Nueva Orden de Servicio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: pendingState.data.length,
                itemBuilder: (context, index) {
                  final item = pendingState.data[index];
                  return CheckboxListTile(
                    title: Text(item.componentName, style: const TextStyle(fontSize: 13)),
                    value: _selectedItems.contains(item.id),
                    activeColor: const Color(0xFFC62828),
                    onChanged: (val) => setState(() => val! ? _selectedItems.add(item.id) : _selectedItems.remove(item.id)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: "Descripción", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _obsController, decoration: const InputDecoration(labelText: "Observación", border: OutlineInputBorder())),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: createServiceState.status == Status.loading ? null : () {
                if (_selectedItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecciona un componente"), backgroundColor: Colors.orange));
                  return;
                }
                ref.read(createServiceNotifierProvider.notifier).createOrder(
                  CreateServiceOrderEntity(
                    vehicleId: widget.vehicleId,
                    description: _descController.text,
                    observation: _obsController.text,
                    serviceItems: _selectedItems.toList(),
                  ),
                );
              },
              child: createServiceState.status == Status.loading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("CREAR ORDEN"),
            ),
          ],
        ),
      ),
    );
  }
}