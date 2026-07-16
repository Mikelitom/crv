import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reports_summary_grid.dart';
import 'vehicle_report_table.dart';
import 'press_report_table.dart';
import 'conveyor_report_table.dart';
import '../../../dashboard/presentation/widgets/header.dart';

class ReportsView extends ConsumerWidget {
  final bool isAdmin;

  const ReportsView({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsNotifierProvider);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.allReports.isEmpty && !state.isLoading) {
        ref.read(reportsNotifierProvider.notifier).loadAllReports();
      }
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: CustomHeader(title: "Historial de Reportes", actionIcon: Icons.description_rounded),
            ),
            
            TabBar(
              onTap: (index) => ref.read(reportsNotifierProvider.notifier).changeTab(index),
              labelColor: const Color(0xFFC62828),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFC62828),
              tabs: const [
                Tab(text: "Bandas"),
                Tab(text: "Vehículos"),
                Tab(text: "Prensas"),
              ],
            ),

            Expanded(
              child: state.isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)))
                : TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildTableForType(state.filteredReports, 0), // Bandas
                      _buildTableForType(state.filteredReports, 1), // Vehículos
                      _buildTableForType(state.filteredReports, 2), // Prensas
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableForType(List<dynamic> items, int typeIndex) {
    final total = items.length;
    final pending = items.where((r) => r.state == "PENDING").length;
    final approved = items.where((r) => r.state == "APPROVED").length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ReportsSummaryGrid(total: total, pending: pending, approved: approved),
          const SizedBox(height: 32),
          
          // Renderizado condicional según el índice de la pestaña
          if (typeIndex == 0)
            ConveyorReportTable(reports: items, isAdmin: isAdmin)
          else if (typeIndex == 1)
            VehicleReportTable(reports: items, isAdmin: isAdmin)
          else
            PressReportTable(reports: items, isAdmin: isAdmin),
        ],
      ),
    );
  }
}