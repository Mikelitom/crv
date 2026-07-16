import 'package:flutter/material.dart';

class ReportsSummaryGrid extends StatelessWidget {
  final int total, pending, approved;
  
  const ReportsSummaryGrid({
    super.key, 
    required this.total, 
    required this.pending, 
    required this.approved
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double cardWidth = (constraints.maxWidth - 32) / 3;
      return Wrap(
        spacing: 16, runSpacing: 16,
        children: [
          _StatCard(label: "Totales", value: "$total", icon: Icons.bar_chart, color: const Color(0xFFC62828), width: cardWidth, isRedTheme: true),
          _StatCard(label: "Pendientes", value: "$pending", icon: Icons.pending_actions, color: Colors.orange, width: cardWidth),
          _StatCard(label: "Aprobados", value: "$approved", icon: Icons.check_circle, color: Colors.green, width: cardWidth),
        ],
      );
    });
  }
}

// _StatCard se queda aquí mismo para mantener el orden como en tus activos
class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final double width;
  final bool isRedTheme;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.width, this.isRedTheme = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isRedTheme ? const Color(0xFFC62828) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: isRedTheme ? Colors.white70 : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Icon(icon, color: isRedTheme ? Colors.white : color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isRedTheme ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }
}