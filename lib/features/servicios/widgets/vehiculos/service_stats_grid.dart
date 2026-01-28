import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/dashboard_stats.dart';
class ServiceStatsGrid extends StatelessWidget {
  const ServiceStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double cardWidth = (constraints.maxWidth - 40) / 3;
      return Wrap(
        spacing: 20,
        children: [
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "En Uso (OK)", value: "12", sublabel: "Operativos", icon: Icons.check_circle_outline_rounded)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "En Taller", value: "5", sublabel: "En Reparación", icon: Icons.build_circle_outlined)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "Críticos", value: "2", sublabel: "Paro Total", icon: Icons.error_outline_rounded)),
        ],
      );
    });
  }
}