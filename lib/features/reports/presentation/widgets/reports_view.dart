import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reports_summary_grid.dart';
import 'vehicle_report_table.dart';
import 'press_report_table.dart';
import 'conveyor_report_table.dart';
import '../../../dashboard/presentation/widgets/header.dart';

class ReportsView extends ConsumerStatefulWidget {
  final bool isAdmin;

  const ReportsView({super.key, required this.isAdmin});

  @override
  ConsumerState<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends ConsumerState<ReportsView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(reportsNotifierProvider.notifier).loadAllReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportsNotifierProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: CustomHeader(
                title: "Historial de Reportes",
                actionIcon: Icons.description_rounded,
              ),
            ),

            // Pestañas con estilo profesional e iconos
            TabBar(
              onTap: (index) =>
                  ref.read(reportsNotifierProvider.notifier).changeTab(index),
              labelColor: const Color(0xFFC62828),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFFC62828), width: 3),
                insets: EdgeInsets.symmetric(horizontal: 16),
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.layers_outlined, size: 18),
                      SizedBox(width: 8),
                      Text("Bandas"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car_outlined, size: 18),
                      SizedBox(width: 8),
                      Text("Vehículos"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.factory_outlined, size: 18),
                      SizedBox(width: 8),
                      Text("Prensas"),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC62828),
                      ),
                    )
                  : TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildTableForType(state.filteredReports, 0),
                        _buildTableForType(state.filteredReports, 1),
                        _buildTableForType(state.filteredReports, 2),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableForType(List<dynamic> items, int typeIndex) {
    // Lógica de cálculo de estados para los contadores
    final total = items.length;
    final pending = items
        .where((r) => (r.state ?? "").toUpperCase() == "PENDING")
        .length;
    final approved = items
        .where((r) => (r.state ?? "").toUpperCase() == "APPROVED")
        .length;
    final returned = items
        .where(
          (r) =>
              ["REJECTED", "RETURNED"].contains((r.state ?? "").toUpperCase()),
        )
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Grid de contadores con animaciones (asumiendo que ya implementaste el widget anterior)
          ReportsSummaryGrid(
            total: total,
            pending: pending,
            approved: approved,
            returned: returned,
          ),
          const SizedBox(height: 32),

          // Renderizado de la tabla correspondiente
          if (typeIndex == 0)
            ConveyorReportTable(reports: items, isAdmin: widget.isAdmin)
          else if (typeIndex == 1)
            VehicleReportTable(reports: items, isAdmin: widget.isAdmin)
          else
            PressReportTable(reports: items, isAdmin: widget.isAdmin),
        ],
      ),
    );
  }
}