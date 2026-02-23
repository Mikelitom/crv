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
          mainAxisSize: MainAxisSize.min, // Ajuste para evitar overflow vertical
          children: [
            Flexible( // Permite que el contenido se ajuste al ancho disponible
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FittedBox( // Escala el texto si es muy grande
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.value, 
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.sublabel, 
                        style: const TextStyle(color: Color(0xFFC62828), fontSize: 12, fontWeight: FontWeight.w600)
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label, 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Círculo del icono
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