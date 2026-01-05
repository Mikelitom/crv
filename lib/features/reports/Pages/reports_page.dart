import 'package:flutter/material.dart';
import '../widgets/Report_filters.dart';
import '../widgets/Report_table.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../../inspections/Widgets/dynamic_stats_row.dart';
class ReportsPage extends StatelessWidget {
  final bool isAdmin; // Se recibe al navegar a la página

  const ReportsPage({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER (Reutilizado)
            CustomHeader(
              title: isAdmin ? "Reportes Administrativos" : "Mis Reportes",
              actionIcon: Icons.file_download,
            ),

            const SizedBox(height: 24),

            // 2. COUNTS (Estadísticas Dinámicas)
            DynamicStatsRow(
              stats: [
                StatModel(value: isAdmin ? "120" : "15", label: "Total"),
                StatModel(value: isAdmin ? "100" : "12", label: "Aprobados", color: Colors.green),
                StatModel(value: isAdmin ? "20" : "3", label: "Pendientes", color: Colors.orange),
              ],
            ),

            const SizedBox(height: 32),

            // 3. FILTROS (Nuevo componente)
            ReportFilters(
              isAdmin: isAdmin,
              onSearch: (v) => print("Buscando: $v"),
              onStatusFilter: (v) => print("Filtrando: $v"),
            ),

            const SizedBox(height: 24),

            // 4. TABLA DE REPORTES
            ReportTable(
              data: [
                {"tipo": "Prensa", "titulo": "Reporte de Fallas P-01", "fecha": "2024-05-10", "estado": "Aprobado"},
                {"tipo": "Vehículo", "titulo": "Mantenimiento V-02", "fecha": "2024-05-11", "estado": "Pendiente"},
              ],
            ),
          ],
        ),
      ),
    );
  }
}