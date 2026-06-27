import 'package:flutter/material.dart';
import '../../../../dashboard/presentation/widgets/dashboard_stats.dart';

class VehicleStatsGrid extends StatelessWidget {
  const VehicleStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Ajuste dinámico de columnas según el ancho disponible
      double spacing = 20.0;
      int columns = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
      double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          SizedBox(
            width: cardWidth, 
            child: const DashboardStatsCard(
              label: "Unidades Activas", 
              value: "24", 
              sublabel: "En ruta / Operación", 
              icon: Icons.check_circle_rounded
            )
          ),
          SizedBox(
            width: cardWidth, 
            child: const DashboardStatsCard(
              label: "Inspecciones Hoy", 
              value: "08", 
              sublabel: "4 pendientes de revisión", 
              icon: Icons.fact_check_outlined
            )
          ),
          SizedBox(
            width: cardWidth, 
            child: const DashboardStatsCard(
              label: "Baja Temporal", 
              value: "03", 
              sublabel: "Correctivos en curso", 
              icon: Icons.warning_amber_rounded
            )
          ),
        ],
      );
    });
  }
}