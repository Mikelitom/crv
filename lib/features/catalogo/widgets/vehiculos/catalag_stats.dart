import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/dashboard_stats.dart';

class CatalogStats extends StatelessWidget {
  const CatalogStats({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double spacing = 20.0;
      double cardWidth = (constraints.maxWidth - (spacing * 2)) / 3;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "Total Unidades", value: "12", sublabel: "Catálogo", icon: Icons.inventory_2_outlined)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "En Operación", value: "9", sublabel: "Activos", icon: Icons.settings_remote_outlined)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "Disponibles", value: "3", sublabel: "En Patio", icon: Icons.event_available_outlined)),
        ],
      );
    });
  }
}