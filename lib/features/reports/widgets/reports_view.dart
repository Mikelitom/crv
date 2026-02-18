import 'package:flutter/material.dart';
import 'quick_report_card.dart';
import '../widgets/Report_table.dart';
import '../../dashboard/presentation/widgets/header.dart';

class ReportsView extends StatelessWidget {
  final bool isAdmin;
  const ReportsView({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CustomHeader(
              title: "Reportes Aprobados", 
              actionIcon: Icons.description_rounded
            ),
            const SizedBox(height: 24),

            // Sección de Tarjetas Superiores
            LayoutBuilder(builder: (context, constraints) {
              double width = constraints.maxWidth;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _responsiveBox(width, "Mis Reportes", "24 reportes", Icons.article_outlined),
                  _responsiveBox(width, "Reportes Generales", "156 reportes", Icons.people_outline),
                  _responsiveBox(width, "Estadísticas", "12 gráficos", Icons.bar_chart_rounded),
                ],
              );
            }),

            const SizedBox(height: 32),
            
            // Tabla y Filtros Combinados (Sin filtro de empleado)
            const ReportTable(items: [],),
          ],
        ),
      ),
    );
  }

  Widget _responsiveBox(double w, String t, String c, IconData i) {
    // Ajuste dinámico de columnas (3 en PC, 1 en Móvil)
    double cardWidth = w > 900 ? (w / 3) - 14 : w;
    return SizedBox(
      width: cardWidth,
      child: QuickReportCard(
        title: t,
        subtitle: "Visualiza la información detallada",
        countText: c,
        icon: i,
        onTap: () {},
      ),
    );
  }
}