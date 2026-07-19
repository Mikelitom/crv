import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_usage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingMaintenanceWidget extends ConsumerStatefulWidget {
  final Function(String pressId) onNavigateToPress;

  const PendingMaintenanceWidget({super.key, required this.onNavigateToPress});

  @override
  ConsumerState<PendingMaintenanceWidget> createState() => _PendingMaintenanceWidgetState();
}

class _PendingMaintenanceWidgetState extends ConsumerState<PendingMaintenanceWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(globalPendingMaintenanceProvider);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 380,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: isHovered ? Colors.black.withOpacity(0.12) : Colors.black.withOpacity(0.05),
              blurRadius: isHovered ? 30 : 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return pendingAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC62828))),
            error: (err, _) => Center(child: Text("Error: $err")),
            data: (orders) {
              final pendingOrders = orders.where((o) => o['status'] == 'PENDING').toList();
              final progressCount = orders.where((o) => o['status'] == 'IN_PROGRESS').length;
              final pendingCount = pendingOrders.length;
              final lastOrder = pendingOrders.isNotEmpty ? pendingOrders.first : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado responsivo con Wrap
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      const Text("Mantenimiento", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1A1A1A))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text("ACTUALIZADO", style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: pendingCount.toDouble()),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) => Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFC62828).withOpacity(0.06)),
                          child: Center(child: Text("${value.toInt()}", style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFFC62828)))),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            _buildMetricRow("Pendientes", "$pendingCount", const Color(0xFFC62828)),
                            const Divider(height: 24),
                            _buildMetricRow("En Proceso", "$progressCount", Colors.blueAccent),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: lastOrder != null
                        ? InkWell(
                            key: const ValueKey('order'),
                            onTap: () => widget.onNavigateToPress(lastOrder['press_id']),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFC62828).withOpacity(0.2))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Orden Prioritaria", style: TextStyle(color: Color(0xFFC62828), fontSize: 11, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text("#${lastOrder['order_number']}", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFC62828)),
                                ],
                              ),
                            ),
                          )
                        : const Center(key: ValueKey('empty'), child: Text("No hay órdenes pendientes", style: TextStyle(color: Colors.grey))),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildMetricRow(String title, String value, Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        ],
      );
}