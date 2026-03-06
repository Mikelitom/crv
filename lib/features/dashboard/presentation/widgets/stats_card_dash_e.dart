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
        // --- ALTURA REDUCIDA: Padding vertical casi nulo para quitar el blanco ---
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.04 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Evita que la fila se estire hacia arriba o abajo
          mainAxisSize: MainAxisSize.min, 
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Fuerza a la columna a usar el alto mínimo del texto
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.value,
                        style: const TextStyle(
                          fontSize: 20, // Fuente ajustada para no estirar el alto
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.sublabel,
                        style: const TextStyle(
                          color: Color(0xFFC62828),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Quitamos espacio intermedio aquí para que sea más bajo
                  Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10, // Letra compacta
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // ICONO COMPACTO: El círculo pequeño impide que la tarjeta crezca
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6), 
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: isHovered ? Colors.white : const Color(0xFFC62828),
                size: 16, // Icono pequeño para mantener la tarjeta bajita
              ),
            ),
          ],
        ),
      ),
    );
  }
}