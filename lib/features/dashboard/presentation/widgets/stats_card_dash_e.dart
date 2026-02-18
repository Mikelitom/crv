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
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // Se redujo un poco el padding para ganar espacio interno
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            mainAxisSize: MainAxisSize.min, // Ajusta al contenido
            children: [
              // Expanded permite que el contenido de texto no empuje el icono fuera de la vista
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap permite que el sublabel baje de línea si el valor es muy grande
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.value, 
                          style: const TextStyle(
                            fontSize: 22, // Tamaño ligeramente reducido para prevenir overflow
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF1A1C1E)
                          )
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.sublabel, 
                          style: const TextStyle(
                            color: Color(0xFFC62828), 
                            fontSize: 11, 
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.label, 
                      maxLines: 1, // Limita a una línea
                      overflow: TextOverflow.ellipsis, // Pone "..." si no cabe
                      style: const TextStyle(
                        color: Colors.grey, 
                        fontSize: 13, 
                        fontWeight: FontWeight.w500
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Icono con tamaño fijo para que no se deforme
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon, 
                  color: isHovered ? Colors.white : const Color(0xFFC62828), 
                  size: 20 // Tamaño ajustado
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}