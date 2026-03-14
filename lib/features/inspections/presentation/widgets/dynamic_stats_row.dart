import 'package:flutter/material.dart';

class DynamicStatsRow extends StatelessWidget {
  final List<dynamic> stats;
  const DynamicStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(color: Color(0xFFC62828))),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final bool isWide = constraints.maxWidth > 750;

      return Center(
        child: Wrap(
          spacing: 12, // Espacio entre tarjetas para que se vean seguidas
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: stats.asMap().entries.map((entry) {
            int idx = entry.key;
            var stat = entry.value;

            // Iconos acordes a cada estadística
            IconData getIcon() {
              if (stat.label.toLowerCase().contains('total')) return Icons.analytics_rounded;
              if (stat.label.toLowerCase().contains('pendiente')) return Icons.pending_actions_rounded;
              if (stat.label.toLowerCase().contains('completa')) return Icons.check_circle_rounded;
              return Icons.bar_chart_rounded;
            }

            return SizedBox(
              // Ocupa todo el espacio disponible dividiendo entre 3
              width: isWide 
                ? (constraints.maxWidth - 32) / 3 
                : constraints.maxWidth,
              child: _StatCard(
                label: stat.label, 
                value: stat.value.toString(),
                icon: getIcon(),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white, // Fondo siempre blanco
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.06 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Corregido: propiedad de Column
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize: 30, // Tamaño acorde a la importancia
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Solo el círculo del icono cambia de color en hover
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Cambia de fondo tenue a rojo sólido
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                // Cambia el icono de rojo a blanco
                color: isHovered ? Colors.white : const Color(0xFFC62828),
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}