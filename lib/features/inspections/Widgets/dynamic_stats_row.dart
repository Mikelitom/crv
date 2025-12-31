import 'package:flutter/material.dart';
class StatModel {
  final String value, label;
  final Color color;
  StatModel({required this.value, required this.label, this.color = Colors.red});
}

class DynamicStatsRow extends StatelessWidget {
  final List<StatModel> stats;
  const DynamicStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        spacing: 12, runSpacing: 12,
        children: stats.map((stat) => SizedBox(
          width: constraints.maxWidth > 600 ? (constraints.maxWidth / stats.length) - 12 : (constraints.maxWidth / 2) - 12,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text(stat.value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text(stat.label, style: TextStyle(color: stat.color, fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          ),
        )).toList(),
      );
    });
  }
}