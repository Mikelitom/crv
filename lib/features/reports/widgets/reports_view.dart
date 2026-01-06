import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/inspections/Widgets/dynamic_stats_row.dart';
import 'package:crv_reprosisa/features/reports/widgets/Report_filters.dart';
import 'package:crv_reprosisa/features/reports/widgets/Report_table.dart';
import 'package:flutter/material.dart';

class ReportsView extends StatelessWidget {
  final bool isAdmin;

  const ReportsView({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(
              title: isAdmin
                  ? "Reportes Administrativos"
                  : "Mis Reportes",
              actionIcon: Icons.file_download,
            ),

            const SizedBox(height: 24),

            DynamicStatsRow(
              stats: [
                StatsModel(value: isAdmin ? "120" : "15", label: "Total"),
                StatsModel(
                  value: isAdmin ? "100" : "12",
                  label: "Aprobados",
                  color: Colors.green,
                ),
                StatsModel(
                  value: isAdmin ? "20" : "3",
                  label: "Pendientes",
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 32),

            ReportFilters(
              isAdmin: isAdmin,
              onSearch: (v) => print("Buscando: $v"),
              onStatusFilter: (v) => print("Filtrando: $v"),
            ),

            const SizedBox(height: 24),

            ReportTable(
              data: const [
                {
                  "tipo": "Prensa",
                  "titulo": "Reporte de Fallas P-01",
                  "fecha": "2024-05-10",
                  "estado": "Aprobado"
                },
                {
                  "tipo": "Vehículo",
                  "titulo": "Mantenimiento V-02",
                  "fecha": "2024-05-11",
                  "estado": "Pendiente"
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
