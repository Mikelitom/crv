import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/dashboard_stats.dart';

class CatalogStats extends StatelessWidget {
  const CatalogStats({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;

      // DEFINICIÓN DE COLUMNAS SEGÚN TAMAÑO (Breakpoints)
      int crossAxisCount;
      double aspectRatio;

      if (maxWidth > 1000) {
        // Escritorio: 3 columnas, tarjetas delgadas
        crossAxisCount = 3;
        aspectRatio = 3.2; 
      } else if (maxWidth > 600) {
        // TABLET: 2 columnas, tarjetas compactas
        crossAxisCount = 2;
        aspectRatio = 2.8; 
      } else {
        // Móvil: 1 columna, proporción ajustada para no ser gigante
        crossAxisCount = 1;
        aspectRatio = 3.8;
      }

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: aspectRatio, // Controla que no se vean "gigantes"
        children: const [
          DashboardStatsCard(
            label: "Total Unidades", 
            value: "12", 
            sublabel: "Catálogo", 
            icon: Icons.inventory_2_outlined
          ),
          DashboardStatsCard(
            label: "En Operación", 
            value: "9", 
            sublabel: "Activos", 
            icon: Icons.settings_remote_outlined
          ),
          DashboardStatsCard(
            label: "Disponibles", 
            value: "3", 
            sublabel: "En Patio", 
            icon: Icons.event_available_outlined
          ),
        ],
      );
    });
  }
}