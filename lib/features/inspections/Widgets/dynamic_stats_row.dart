import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:flutter/material.dart';


class DynamicStatsRow extends StatelessWidget {
  final List<StatsModel> stats;

  const DynamicStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // En PC (ancho > 900) muestra 4 columnas, en tablet 2, en móvil 1.
        double itemWidth = constraints.maxWidth > 900 
            ? (constraints.maxWidth / 4) - 12 
            : constraints.maxWidth > 600 ? (constraints.maxWidth / 2) - 12 : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stats.map((stat) => SizedBox(
            width: itemWidth,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Text(stat.value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(stat.label, style: TextStyle(color: stat.color, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )).toList(),
        );
      },
    );
  }
}