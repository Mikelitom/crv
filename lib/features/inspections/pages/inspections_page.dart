import 'package:crv_reprosisa/features/inspections/Widgets/dynamic_stats_row.dart';
import 'package:crv_reprosisa/features/inspections/Widgets/table_inspector.dart';
import 'package:flutter/material.dart';

import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import '../../../core/models/inspection_models.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../../dashboard/presentation/widgets/quick_action_card.dart';

class InspectionPage extends StatelessWidget {
  final List<StatsModel> stats;
  final List<ActionCardModel> actions;
  final List<InspectionRowUI> inspections;

  const InspectionPage({
    super.key,
    required this.stats,
    required this.actions,
    required this.inspections,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          const CustomHeader(
            title: 'Inspecciones',
            actionIcon: Icons.print_rounded,
          ),

          const SizedBox(height: 24),

          // ================= STATS =================
          DynamicStatsRow(stats: stats),

          const SizedBox(height: 32),

          // ================= ACTIONS =================
          const Text(
            'Realizar una inspección',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.6,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return QuickActionCard(
                title: action.title,
                description: action.description,
                onTap: action.onTap,
              );
            },
          ),

          const SizedBox(height: 32),

          // ================= TABLE =================
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
