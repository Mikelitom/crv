import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

            // Pestañas mejoradas para evitar desbordamientos con texto flexible e iconos adaptados
            TabBar(
              onTap: (index) =>
                  ref.read(reportsNotifierProvider.notifier).changeTab(index),
              labelColor: const Color(0xFFC62828),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: false,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFFC62828), width: 3),
                insets: EdgeInsets.symmetric(horizontal: 8),
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.layers_outlined, size: 16),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "Bandas",
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car_outlined, size: 16),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "Vehículos",
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.factory_outlined, size: 16),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "Prensas",
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
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