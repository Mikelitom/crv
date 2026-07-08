import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/vehicle_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

enum DateRange { sevenDays, fifteenDays, oneMonth, threeMonths }

class UsageTrendChart extends ConsumerStatefulWidget {
  const UsageTrendChart({super.key});

  @override
  ConsumerState<UsageTrendChart> createState() => _UsageTrendChartState();
}

class _UsageTrendChartState extends ConsumerState<UsageTrendChart> {
  DateRange _selectedRange = DateRange.sevenDays;
  bool _isHovered = false;

  List<FlSpot> _calculateSpots(List<dynamic> data, DateRange range) {
    int days = _rangeToDays(range);
    DateTime now = DateTime.now();
    List<FlSpot> spots = [];
    int totalFleet = data.map((v) => v.id).toSet().length;
    if (totalFleet == 0) totalFleet = 1;

    for (int i = 0; i < days; i++) {
      DateTime day = now.subtract(Duration(days: days - 1 - i));
      int activeCount = data.where((v) {
        DateTime end = v.checkIn ?? DateTime.now();
        return v.checkOut.isBefore(day) && end.isAfter(day);
      }).length;
      
      double percentage = (activeCount / totalFleet) * 100;
      spots.add(FlSpot(i.toDouble(), percentage));
    }
    return spots;
  }

  int _rangeToDays(DateRange r) {
    switch (r) {
      case DateRange.sevenDays: return 7;
      case DateRange.fifteenDays: return 15;
      case DateRange.oneMonth: return 30;
      case DateRange.threeMonths: return 90;
    }
  }

  String _rangeToSpanish(DateRange r) {
    switch (r) {
      case DateRange.sevenDays: return "Últimos 7 días";
      case DateRange.fifteenDays: return "Últimos 15 días";
      case DateRange.oneMonth: return "Último mes";
      case DateRange.threeMonths: return "Últimos 3 meses";
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(vehicleStateProvider);

    // LayoutBuilder permite que el widget se adapte al espacio que le asigne el padre
    return LayoutBuilder(builder: (context, constraints) {
      bool isCompact = constraints.maxWidth < 400;

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
          width: double.infinity, // Responsivo: ocupa todo el ancho disponible
          constraints: const BoxConstraints(minHeight: 300),
          padding: EdgeInsets.all(isCompact ? 16 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(_isHovered ? 0.3 : 0.15),
                blurRadius: _isHovered ? 25 : 15,
                offset: Offset(0, _isHovered ? 10 : 5),
              ),
            ],
          ),
          child: asyncData.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC62828))),
            error: (err, _) => Center(child: Text("Error: $err")),
            data: (vehicleData) {
              int days = _rangeToDays(_selectedRange);
              List<FlSpot> spots = _calculateSpots(vehicleData, _selectedRange);

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Uso Activo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isCompact ? 18 : 22)),
                          Container(height: 4, width: 40, color: const Color(0xFFC62828)),
                        ],
                      ),
                      PopupMenuButton<DateRange>(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
                          child: Row(children: [
                            Text(_rangeToSpanish(_selectedRange), style: TextStyle(fontSize: isCompact ? 12 : 14)), 
                            const Icon(Icons.arrow_drop_down, size: 16)
                          ]),
                        ),
                        onSelected: (val) => setState(() => _selectedRange = val),
                        itemBuilder: (context) => DateRange.values.map((r) => PopupMenuItem(value: r, child: Text(_rangeToSpanish(r)))).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 100,
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  "${spot.y.toStringAsFixed(1)}%",
                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[200], strokeWidth: 1),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(sideTitles: SideTitles(
                            showTitles: true, reservedSize: 32,
                            // Si es compacto, mostramos menos etiquetas para evitar solapamientos
                            interval: isCompact ? 3 : 2, 
                            getTitlesWidget: (v, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('d MMM').format(DateTime.now().subtract(Duration(days: days - 1 - v.toInt()))),
                                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                                ),
                              );
                            },
                          )),
                          leftTitles: AxisTitles(sideTitles: SideTitles(
                            showTitles: true, reservedSize: 30, interval: 25,
                            getTitlesWidget: (v, _) => Text("${v.toInt()}%", style: const TextStyle(fontSize: 9, color: Colors.grey)),
                          )),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: false,
                            color: const Color(0xFFC62828),
                            barWidth: 3,
                            dotData: FlDotData(show: !isCompact), // Ocultamos puntos en modo compacto para limpiar la vista
                            belowBarData: BarAreaData(show: true, color: const Color(0xFFC62828).withOpacity(0.08)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}