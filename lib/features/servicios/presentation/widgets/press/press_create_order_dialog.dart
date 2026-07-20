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
  void dispose() {
    _descController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        Navigator.pop(context, true);
      } else if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${next.error}"), backgroundColor: Colors.red),
        );
      }
    });

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Iniciar orden de servicio",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Lista de componentes seleccionables estilo tarjeta
            SizedBox(
              height: 180,
              child: pendingState.status == Status.loading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)))
                : pendingState.data.isEmpty
                    ? const Center(child: Text("Sin componentes pendientes", style: TextStyle(color: Colors.grey, fontSize: 13)))
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: pendingState.data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = pendingState.data[index];
                          final isSelected = _selectedItems.contains(item.id);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedItems.remove(item.id);
                                } else {
                                  _selectedItems.add(item.id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFFC62828).withValues(alpha: 0.08) 
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFC62828) : Colors.grey.shade300,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                                    color: isSelected ? const Color(0xFFC62828) : Colors.grey.shade400,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.componentName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? const Color(0xFFC62828) : Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 16),

            // Campos de texto estilizados con bordes redondeados
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "Descripción",
                hintText: "Descripción del servicio",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _obsController,
              decoration: InputDecoration(
                labelText: "Observación",
                hintText: "Observaciones adicionales",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botones de acción inferiores
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: createServiceState.status == Status.loading ? null : () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: createServiceState.status == Status.loading 
                    ? null 
                    : () {
                        if (_selectedItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Selecciona al menos un componente"), backgroundColor: Colors.orange),
                          );
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
                    ? const SizedBox(
                        height: 18, 
                        width: 18, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      ) 
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