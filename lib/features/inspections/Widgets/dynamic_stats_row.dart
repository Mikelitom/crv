import 'package:flutter/material.dart';

class DynamicStatsRow extends StatelessWidget {
  final List<dynamic> stats;
  const DynamicStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // Validación para evitar el error de RangeError en laptop
    if (stats.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(color: Color(0xFFC62828))),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      // Modo Computadora: Las 3 estadísticas seguidas una al lado de la otra
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

      // Modo Móvil: Lista vertical
      return Column(
        children: stats.map((stat) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _StatCard(label: stat.label, value: stat.value),
        )).toList(),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, 
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          // FittedBox previene los errores de píxeles rojos (Overflow)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, 
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
          ),
        ],
      ),
    );
  }
}