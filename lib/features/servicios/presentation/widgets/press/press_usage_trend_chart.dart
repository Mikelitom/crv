import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum DateRange { sevenDays, fifteenDays, oneMonth, threeMonths }

class PressUsageTrendChart extends ConsumerStatefulWidget {
  final List<dynamic> data;
  const PressUsageTrendChart({super.key, required this.data});

  @override
  ConsumerState<PressUsageTrendChart> createState() => _PressUsageTrendChartState();
}

class _PressUsageTrendChartState extends ConsumerState<PressUsageTrendChart> {
  DateRange _selectedRange = DateRange.sevenDays;
  bool isHovered = false;

  List<FlSpot> _calculateSpots(List<dynamic> data, DateRange range) {
    int days = _rangeToDays(range);
    DateTime now = DateTime.now();
    List<FlSpot> spots = [];
    
    for (int i = 0; i < days; i++) {
      DateTime day = now.subtract(Duration(days: days - 1 - i));
      int activeCount = data.where((p) {
        DateTime start = DateTime.parse(p['loan_date']);
        DateTime end = DateTime.parse(p['return_date']);
        return day.isAfter(start) && day.isBefore(end);
      }).length;
      
      double percentage = data.isNotEmpty ? (activeCount / data.length) * 100 : 0;
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
    final spots = _calculateSpots(widget.data, _selectedRange);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 380, // ALTURA FIJA PARA ALINEACIÓN
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: isHovered ? Colors.black.withOpacity(0.12) : Colors.black.withOpacity(0.05),
              blurRadius: isHovered ? 30 : 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Uso Activo", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1A1A1A))),
                    Container(height: 4, width: 40, margin: const EdgeInsets.only(top: 6), color: const Color(0xFFC62828)),
                  ],
                ),
                _buildDropdown(),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: 0, maxY: 100,
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 25, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey[100])),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 25, getTitlesWidget: (v, _) => Text("${v.toInt()}%", style: const TextStyle(fontSize: 10, color: Colors.grey)))),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 2, getTitlesWidget: (v, _) => Text(DateFormat('d MMM').format(DateTime.now().subtract(Duration(days: _rangeToDays(_selectedRange) - 1 - v.toInt()))), style: const TextStyle(fontSize: 10, color: Colors.grey)))),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      color: const Color(0xFFC62828),
                      barWidth: 3,
                      isCurved: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: true, color: const Color(0xFFC62828).withOpacity(0.05)),
                    )
                  ],
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() => PopupMenuButton<DateRange>(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(10)),
          child: Row(children: [Text(_rangeToSpanish(_selectedRange), style: const TextStyle(fontSize: 12)), const Icon(Icons.arrow_drop_down, size: 16)]),
        ),
        onSelected: (val) => setState(() => _selectedRange = val),
        itemBuilder: (context) => DateRange.values.map((r) => PopupMenuItem(value: r, child: Text(_rangeToSpanish(r)))).toList(),
      );
}