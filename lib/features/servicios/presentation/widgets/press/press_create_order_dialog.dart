// lib/features/servicios/presentation/widgets/press/press_create_order_dialog.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_create_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressCreateOrderDialog extends ConsumerStatefulWidget {
  final String pressId;
  const PressCreateOrderDialog({super.key, required this.pressId});

  @override
  ConsumerState<PressCreateOrderDialog> createState() => _PressCreateOrderDialogState();
}

class _PressCreateOrderDialogState extends ConsumerState<PressCreateOrderDialog> {
  final _descController = TextEditingController();
  final _obsController = TextEditingController();
  final Set<String> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    // Escucha el estado de los componentes pendientes y el estado de creación
    final pendingState = ref.watch(pressItemNotifierProvider);
    final createServiceState = ref.watch(pressCreateOrderNotifierProvider);

    ref.listen(pressCreateOrderNotifierProvider, (previous, next) {
      if (next.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Orden ${next.orderNumber ?? ''} creada con éxito!"), 
            backgroundColor: Colors.green
          ),
        );
        Navigator.pop(context, true); // Devuelve true para recargar la lista en la vista padre
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
              child: pendingState.status == Status.loading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828), 
                foregroundColor: Colors.white, 
                minimumSize: const Size(double.infinity, 50)
              ),
              onPressed: createServiceState.status == Status.loading ? null : () {
                if (_selectedItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecciona un componente"), backgroundColor: Colors.orange));
                  return;
                }
                ref.read(pressCreateOrderNotifierProvider.notifier).createOrder(
                  PressCreateOrderEntity(
                    pressId: widget.pressId,
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