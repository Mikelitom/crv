import 'package:flutter/material.dart';

class MaintenancePendingCard extends StatefulWidget {
  final int pendingCount;

  const MaintenancePendingCard({super.key, required this.pendingCount});

  @override
  State<MaintenancePendingCard> createState() => _MaintenancePendingCardState();
}

class _MaintenancePendingCardState extends State<MaintenancePendingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isDone = widget.pendingCount == 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        width: 450, // Ajustado para que 3 quepan en 1400-1500px
        height: 400,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(_isHovered ? 0.3 : 0.15),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mantenimientos Pendientes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            Container(height: 4, width: 40, color: const Color(0xFFC62828)),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFFFBE9E7), shape: BoxShape.circle),
                    child: const Icon(Icons.build, size: 50, color: Color(0xFFC62828)),
                  ),
                  const SizedBox(height: 16),
                  Text("${widget.pendingCount}", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFFC62828))),
                  Text(isDone ? "¡Todo al día!" : "Pendientes de atención", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
            const Spacer(),
            if (isDone)
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.check_circle, color: Colors.green),
                ),
              )
          ],
        ),
      ),
    );
  }
}