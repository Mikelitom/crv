import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/dashboard_stats.dart';

class ServiceStatsGrid extends StatelessWidget {
  const ServiceStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        int crossAxisCount;
        double aspectRatio;

        // Configuramos 3 estados de tamaño para evitar errores
        if (maxWidth > 1200) {
          // Escritorio: 3 columnas muy delgadas
          crossAxisCount = 3;
          aspectRatio = 3.5; 
        } else if (maxWidth > 750) {
          // Tablet: 3 columnas con un poco más de altura
          crossAxisCount = 3;
          aspectRatio = 2.4; 
        } else if (maxWidth > 500) {
          // Móvil Grande: 2 columnas para que el texto respire
          crossAxisCount = 2;
          aspectRatio = 2.0; 
        } else {
          // Móvil Pequeño: 1 columna, pero muy bajita
          crossAxisCount = 1;
          aspectRatio = 4.0; 
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio, // <--- Este valor evita el Bottom Overflow
          children: const [
            DashboardStatsCard(
              label: "En Uso (OK)", 
              value: "12", 
              sublabel: "Operativos", 
              icon: Icons.check_circle_outline_rounded
            ),
            DashboardStatsCard(
              label: "En Taller", 
              value: "5", 
              sublabel: "En Reparación", 
              icon: Icons.build_circle_outlined
            ),
            DashboardStatsCard(
              label: "Críticos", 
              value: "2", 
              sublabel: "Paro Total", 
              icon: Icons.error_outline_rounded
            ),
          ],
        );
      },
    );
  }
}