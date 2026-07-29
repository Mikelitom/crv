import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class PressDistributionChart extends ConsumerStatefulWidget {
  const PressDistributionChart({super.key});

  @override
  ConsumerState<PressDistributionChart> createState() =>
      _PressDistributionChartState();
}

class _PressDistributionChartState
    extends ConsumerState<PressDistributionChart> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pressListProvider);
    final pressList = state.press;

    if (state.status == Status.loading) {
      return const SizedBox(
        height: 380,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    int countState(String stateName) {
      return pressList.where((p) {
        final s = p.operationState
            .trim(); // Ya viene traducido del modelo en español

        if (stateName == "DISPONIBLE") {
          return s == "Disponible";
        }
        if (stateName == "PRESTAMO") {
          return s == "En Préstamo" ||
              s == "En Operación"; // O las categorías que agrupes como ocupadas
        }
        if (stateName == "MANTENIMIENTO") {
          return s == "En Mantenimiento";
        }
        return s == stateName;
      }).length;
    }

    final data = {
      "PRESTAMO": countState("PRESTAMO"),
      "DISPONIBLE": countState("DISPONIBLE"),
      "MANTENIMIENTO": countState("MANTENIMIENTO"),
    };

    final total = pressList.length;

    const ocColor = Color(0xFFC62828);
    const avColor = Color(0xFF424242);
    const woColor = Color(0xFF757575);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 380,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.12 : 0.05),
              blurRadius: isHovered ? 30 : 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Distribución de Prensas",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(top: 6),
              color: ocColor,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isMobile = constraints.maxWidth < 450;

                  final chart = _buildChart(
                    data,
                    total,
                    ocColor,
                    avColor,
                    woColor,
                  );
                  final legend = _buildLegend(
                    data,
                    total,
                    ocColor,
                    avColor,
                    woColor,
                  );

                  return isMobile
                      ? Column(
                          children: [
                            Expanded(child: chart),
                            legend,
                          ],
                        )
                      : Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Centrado total
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: chart,
                            ),
                            const SizedBox(width: 40),
                            Expanded(child: legend),
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(
    Map<String, int> data,
    int total,
    Color oc,
    Color av,
    Color wo,
  ) {
    final sections = total == 0
        ? [
            PieChartSectionData(
              value: 1,
              color: Colors.grey.shade300,
              showTitle: false,
              radius: 20,
            ),
          ]
        : [
            PieChartSectionData(
              value: data["PRESTAMO"]!.toDouble(),
              color: oc,
              showTitle: false,
              radius: 20,
            ),
            PieChartSectionData(
              value: data["DISPONIBLE"]!.toDouble(),
              color: av,
              showTitle: false,
              radius: 20,
            ),
            PieChartSectionData(
              value: data["MANTENIMIENTO"]!.toDouble(),
              color: wo,
              showTitle: false,
              radius: 20,
            ),
          ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, val, child) => Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(enabled: false),
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: sections,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(total * val).toInt()}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(
    Map<String, int> data,
    int total,
    Color oc,
    Color av,
    Color wo,
  ) {
    String getP(int val) =>
        total > 0 ? "${((val / total) * 100).toInt()}%" : "0%";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(
          "En Préstamo",
          data["PRESTAMO"]!,
          getP(data["PRESTAMO"]!),
          oc,
        ),
        _legendItem(
          "Disponibles",
          data["DISPONIBLE"]!,
          getP(data["DISPONIBLE"]!),
          av,
        ),
        _legendItem(
          "Mantenimiento",
          data["MANTENIMIENTO"]!,
          getP(data["MANTENIMIENTO"]!),
          wo,
        ),
      ],
    );
  }

  Widget _legendItem(String label, int count, String percent, Color color) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  Text(
                    "$count ($percent)",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
