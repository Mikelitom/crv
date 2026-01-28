import 'package:flutter/material.dart';

class DashboardStatsCard extends StatefulWidget {
  final String label;
  final String value;
  final String sublabel;
  final IconData icon;

  const DashboardStatsCard({
    super.key, 
    required this.label, 
    required this.value, 
    required this.sublabel, 
    required this.icon
  });

  @override
  State<DashboardStatsCard> createState() => _DashboardStatsCardState();
}

class _DashboardStatsCardState extends State<DashboardStatsCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.08 : 0.04),
              blurRadius: isHovered ? 20 : 12,
              offset: Offset(0, isHovered ? 10 : 6),
            )
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    // Texto pequeño en rojo (ej: "Este mes" o "+12%")
                    Text(widget.sublabel, style: const TextStyle(color: Color(0xFFC62828), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            const Spacer(),
            // Círculo del icono que cambia de color en hover
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: isHovered ? Colors.white : const Color(0xFFC62828), size: 24),
            )
          ],
        ),
      ),
    );
  }
}