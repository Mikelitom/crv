import 'package:flutter/material.dart';
import 'quick_report_card.dart';
import '../widgets/report_table.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../models/report_row_ui.dart'; // Importante para los datos estáticos

class ReportsView extends StatelessWidget {
  final bool isAdmin;
  const ReportsView({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    // 1. DATOS ESTÁTICOS PARA LA DEMOSTRACIÓN
    final List<ReportRowUI> _reportesEstaticos = [
      ReportRowUI(
        titulo: "Reporte B-1024",
        tipo: "Banda Transportadora",
        fecha: "20/02/2026",
      ),
      ReportRowUI(
        titulo: "Reporte P-8821",
        tipo: "Prensa Industrial",
        fecha: "19/02/2026",
      ),
      ReportRowUI(
        titulo: "Reporte V-3305",
        tipo: "Vehículo Utilitario",
        fecha: "18/02/2026",
      ),
      ReportRowUI(
        titulo: "Reporte B-1025",
        tipo: "Banda Transportadora",
        fecha: "17/02/2026",
      ),
      ReportRowUI(
        titulo: "Reporte P-8822",
        tipo: "Prensa Industrial",
        fecha: "16/02/2026",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CustomHeader(
              title: "Reportes Aprobados",
              actionIcon: Icons.description_rounded,
            ),
            const SizedBox(height: 24),

            // Sección de Tarjetas Superiores (Tu lógica original)
            

            const SizedBox(height: 32),

            // Tabla con los datos estáticos inyectados
            ReportTable(items: _reportesEstaticos),
          ],
        ),
      ),
    );
  }
}

