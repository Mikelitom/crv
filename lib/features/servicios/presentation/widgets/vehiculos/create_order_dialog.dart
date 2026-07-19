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

  final Color _red = const Color(0xFFC62828);

  // Decoración para campos de texto con fondo blanco y estilo institucional
  InputDecoration _inputDecor(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _red, width: 2),
        ),
      );

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
          SnackBar(content: Text("Error: ${next.error}"), backgroundColor: _red),
        );
      }
    });

    return Dialog(
      backgroundColor: Colors.white, // Fondo blanco puro para todo el diálogo
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Iniciar orden de servicio", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: pendingState.data.length,
                itemBuilder: (context, index) {
                  final item = pendingState.data[index];
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.componentName, style: const TextStyle(fontSize: 14)),
                    value: _selectedItems.contains(item.id),
                    activeColor: _red,
                    onChanged: (val) => setState(() => val! ? _selectedItems.add(item.id) : _selectedItems.remove(item.id)),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _descController, decoration: _inputDecor("Descripción")),
            const SizedBox(height: 16),
            TextField(controller: _obsController, decoration: _inputDecor("Observación")),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
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
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Text("Iniciar", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}