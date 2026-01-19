import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';

import '../Widgets/dynamic_stats_row.dart';
import '../Widgets/table_inspector.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../../dashboard/presentation/widgets/quick_action_card.dart';
import '../../../core/models/inspection_models.dart';

class InspectionPage extends StatelessWidget {
  final List<StatsModel> stats;
  final List<ActionCardModel> actions;
  final List<InspectionRowUI> inspections;

  const InspectionPage({
    super.key,
    required this.stats,
    required this.actions,
    required this.inspections
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const CustomHeader(
            title: 'Inspecciones',
            actionIcon: Icons.print_rounded,
          ),

          const SizedBox(height: 24),

          // Estadísticas
          DynamicStatsRow(stats: stats),

          const SizedBox(height: 32),

          // Acciones
          const Text(
            'Realizar una inspección',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: actions
                  .map(
                    (action) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: QuickActionCard(
                        title: action.title,
                        description: action.description,
                        onTap: action.onTap,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 32),

          // Tabla
          const Text(
            'Mis inspecciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TableInspector(
            items: inspections,
            onSearch: (value) {
              debugPrint('Buscar: $value');
            },
          ),
        ],
      ),
    );
  }
}
