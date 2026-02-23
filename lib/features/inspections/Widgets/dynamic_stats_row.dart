import 'package:flutter/material.dart';

class DynamicStatsRow extends StatelessWidget {
  final List<dynamic> stats;
  const DynamicStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // Protección contra errores de carga en laptop
    if (stats.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(color: Color(0xFFC62828))),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      // MODO COMPUTADORA: Una sola fila simétrica
      if (constraints.maxWidth > 900) {
        return Row(
          children: [
            Expanded(child: _StatCard(label: stats[0].label, value: stats[0].value)),
            const SizedBox(width: 20),
            if (stats.length > 1)
              Expanded(child: _StatCard(label: stats[1].label, value: stats[1].value)),
            const SizedBox(width: 20),
            if (stats.length > 2)
              Expanded(child: _StatCard(label: stats[2].label, value: stats[2].value)),
          ],
        );
      }

      // MODO MÓVIL: Lista vertical
      return Column(
        children: stats.map((stat) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _StatCard(label: stat.label, value: stat.value),
        )).toList(),
      );
    });
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.label, 
              style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            FittedBox( // Previene overflow de píxeles
              fit: BoxFit.scaleDown,
              child: Text(widget.value, 
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
            ),
          ],
        ),
      ),
    );
  }
}