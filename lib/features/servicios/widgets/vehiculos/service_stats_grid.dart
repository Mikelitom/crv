import 'package:flutter/material.dart';

class ServiceStatsGrid extends StatelessWidget {
  final bool isVehiculo;
  const ServiceStatsGrid({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double spacing = 16.0;
      int columns = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
      double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

      return Wrap(
        spacing: spacing, runSpacing: spacing,
        children: [
          _StatCard("Vehículos Totales", "120", Icons.directions_car, Colors.blue, cardWidth),
          _StatCard("Con Alertas", "8", Icons.warning_amber_rounded, Colors.orange, cardWidth),
          _StatCard("Próximos a Servicio", "5", Icons.build_circle_rounded, Colors.teal, cardWidth),
          _StatCard("En Taller", "2", Icons.local_shipping, Colors.red, cardWidth),
        ],
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final double width;
  const _StatCard(this.label, this.value, this.icon, this.color, this.width);

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
    child: Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
        ]),
      ],
    ),
  );
}