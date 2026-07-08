import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class PressDistributionChart extends ConsumerStatefulWidget {
  const PressDistributionChart({super.key});

  @override
  ConsumerState<PressDistributionChart> createState() => _PressDistributionChartState();
}

class _PressDistributionChartState extends ConsumerState<PressDistributionChart> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pressListProvider);
    final pressList = state.press;

    if (state.status == Status.loading) {
      return const SizedBox(height: 380, child: Center(child: CircularProgressIndicator()));
    }

    int countState(String stateName) {
      return pressList.where((p) {
        final s = p.operationState.trim().toUpperCase();
        if (stateName == "AVAILABLE" && (s == "AVAILABLE" || s == "DISPONIBLE")) return true;
        if (stateName == "OCCUPIED" && (s == "OCCUPIED" || s == "OCUPADA" || s == "EN USO")) return true;
        if (stateName == "WORKSHOP" && (s == "WORKSHOP" || s == "TALLER")) return true;
        return s == stateName;
      }).length;
    }

    final occupied = countState("OCCUPIED");
    final available = countState("AVAILABLE");
    final workshop = countState("WORKSHOP");
    final total = pressList.length;

    const ocColor = Color(0xFFC62828);
    const avColor = Color(0xFF424242);
    const woColor = Color(0xFF757575);

    String getPercent(int value) => total > 0 ? "${((value / total) * 100).toInt()}%" : "0%";

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 380, // ALTURA FIJA PARA ALINEAR CON OTROS WIDGETS
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: isHovered 
                  ? Colors.black.withOpacity(0.12) 
                  : Colors.black.withOpacity(0.05),
              blurRadius: isHovered ? 30 : 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Distribución de Prensas", 
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1A1A1A))),
            Container(height: 4, width: 40, margin: const EdgeInsets.only(top: 6), color: ocColor),
            const SizedBox(height: 32),
            
            // Layout Responsivo: se apila si el ancho es muy pequeño
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                bool isCompact = constraints.maxWidth < 220;
                return isCompact
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChart(occupied, available, workshop, total, ocColor, avColor, woColor),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(flex: 2, child: _buildChart(occupied, available, workshop, total, ocColor, avColor, woColor)),
                          const SizedBox(width: 20),
                          Expanded(flex: 3, child: _buildLegend(occupied, available, workshop, getPercent, ocColor, avColor, woColor)),
                        ],
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(int oc, int av, int wo, int total, Color ocC, Color avC, Color woC) {
    final List<PieChartSectionData> sections = [
      if (oc > 0) PieChartSectionData(value: oc.toDouble(), color: ocC, showTitle: false, radius: 25),
      if (av > 0) PieChartSectionData(value: av.toDouble(), color: avC, showTitle: false, radius: 25),
      if (wo > 0) PieChartSectionData(value: wo.toDouble(), color: woC, showTitle: false, radius: 25),
      if (total == 0) PieChartSectionData(value: 1, color: Colors.grey.shade200, showTitle: false, radius: 25),
    ];

    return SizedBox(
      height: 150,
      child: Stack(alignment: Alignment.center, children: [
        PieChart(PieChartData(sectionsSpace: 6, centerSpaceRadius: 40, sections: sections)),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("$total", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
          const Text("Total", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        ])
      ]),
    );
  }

  Widget _buildLegend(int oc, int av, int wo, Function getP, Color ocC, Color avC, Color woC) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem("Ocupadas", "$oc", getP(oc), ocC),
        _legendItem("Disponibles", "$av", getP(av), avC),
        _legendItem("Taller", "$wo", getP(wo), woC),
      ],
    );
  }

  Widget _legendItem(String label, String count, String percent, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 10),
      Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text("$count ($percent)", style: const TextStyle(fontWeight: FontWeight.w800)),
      ]))
    ]),
  );
}