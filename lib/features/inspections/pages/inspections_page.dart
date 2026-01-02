import 'package:flutter/material.dart';
// Rutas según tu estructura
import '../Widgets/dynamic_stats_row.dart';
import '../Widgets/table_inspectior.dart';
import '../../../core/models/inspection_models.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../../dashboard/presentation/widgets/quick_action_card.dart';

class InspectionPage extends StatelessWidget {
  final List<StatModel> stats;
  final List<ActionCardModel> actions;
  final List<String> tableHeaders;
  final List<List<String>> tableData;

  const InspectionPage({
    super.key,
    required this.stats,
    required this.actions,
    required this.tableHeaders,
    required this.tableData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(title: "Inspecciones", actionIcon: Icons.print_rounded),
            const SizedBox(height: 24),
            
            // Stats dinámicos
            DynamicStatsRow(stats: stats),
            
            const SizedBox(height: 32),
            const Text("Realizar Una Inspección", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Acciones dinámicas
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: actions.map((action) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: QuickActionCard(
                    title: action.title,
                    description: action.description,
                    onTap: action.onTap, // Aquí pasas la función del modelo
                  ),
                )).toList(),
              ),
            ),

            const SizedBox(height: 32),
            const Text("Mis Inspecciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Tabla dinámica
            TableInspector(
              columnHeaders: tableHeaders,
              rows: tableData,
              onSearch: (val) => print("Buscando: $val"),
            ),
          ],
        ),
      ),
    );
  }
}
