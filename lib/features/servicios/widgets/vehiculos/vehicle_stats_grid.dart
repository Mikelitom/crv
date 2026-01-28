import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/dashboard_stats.dart';

class VehicleStatsGrid extends StatelessWidget {
  const VehicleStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double cardWidth = (constraints.maxWidth - 40) / 3;
      return Wrap(
        spacing: 20,
        children: [
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "Vehículos OK", value: "10", sublabel: "Estatus OK", icon: Icons.check_circle_rounded)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "En Inspección", value: "3", sublabel: "Pendientes", icon: Icons.fact_check_outlined)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(
            label: "Fuera de Servicio", value: "2", sublabel: "Taller/Falla", icon: Icons.warning_amber_rounded)),
        ],
      );
    });
  }
}