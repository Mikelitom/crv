import 'package:flutter/material.dart';

class MaintenancePendingCard extends StatefulWidget {
  final int pendingCount;
  final int progressCount;
  final String? lastOrderNumber;
  final VoidCallback? onNavigate;

  const MaintenancePendingCard({
    super.key,
    required this.pendingCount,
    required this.progressCount,
    this.lastOrderNumber,
    this.onNavigate,
  });

  @override
  State<MaintenancePendingCard> createState() => _MaintenancePendingCardState();
}

class _MaintenancePendingCardState extends State<MaintenancePendingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 450,
        height: 380,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? Colors.black.withOpacity(0.12) : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 30 : 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Text("Mantenimiento", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1A1A1A))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text("ACTUALIZADO", style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Contenido: Contador circular y métricas
            Row(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: widget.pendingCount.toDouble()),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => Container(
                    width: 80, // Ligeramente más chico
                    height: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFC62828).withOpacity(0.06)),
                    child: Center(child: Text("${value.toInt()}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFFC62828)))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildMetricRow("Pendientes", "${widget.pendingCount}", const Color(0xFFC62828)),
                      const Divider(height: 20),
                      _buildMetricRow("En Proceso", "${widget.progressCount}", Colors.blueAccent),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Tarjeta prioritaria
            InkWell(
              onTap: widget.onNavigate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFC62828).withOpacity(0.2))),
                child: Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Orden Prioritaria", style: TextStyle(color: Color(0xFFC62828), fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(widget.lastOrderNumber ?? "N/A", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    ])),
                    const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFC62828)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String title, String value, Color color) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)), // Letra un poco más chica
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)), // Letra un poco más chica
        ],
      );
}