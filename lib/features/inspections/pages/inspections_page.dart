import 'package:flutter/material.dart';
// Rutas según tu estructura
import '../Widgets/dynamic_stats_row.dart';
import '../Widgets/table_inspectior.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../../dashboard/presentation/widgets/quick_action_card.dart';

class InspectionPage extends StatelessWidget {
  const InspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Dinámico (Sin nombre, solo título)
            const CustomHeader(title: "Inspecciones", actionIcon: Icons.print_rounded),

            const SizedBox(height: 24),

            // 2. Fila de Contadores Dinámica
            DynamicStatsRow(stats: [
              StatModel(value: "15", label: "Total"),
              StatModel(value: "10", label: "Aprobados"),
              StatModel(value: "3", label: "Pendientes"),
              StatModel(value: "2", label: "Con observaciones"),
            ]),

            const SizedBox(height: 32),
            const Text("Realizar Una Inspección", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 3. QuickActions (Tarjetas de Inicio)
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                QuickActionCard(title: "Inspección de Prensas", description: "Realizar checklist", onTap: ),
                SizedBox(width: 16),
                QuickActionCard(title: "Inspección de Vehículos", description: "Realizar checklist", onTap: null),
                SizedBox(width: 16),
                QuickActionCard(title: "Inspección de Bandas", description: "Realizar checklist", onTap: null),
              ]),
            ),

            const SizedBox(height: 32),
            const Text("Mis Inspecciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 4. Tabla Inspector
            const TableInspector(data: [
              {"inspeccion": "Edit Column 1", "nombre": "Edit Column 2", "acciones": "Edit Column 3"},
            ]),
          ],
        ),
      ),
    );
  }
}