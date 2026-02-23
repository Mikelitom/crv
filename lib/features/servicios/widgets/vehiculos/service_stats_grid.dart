import 'package:flutter/material.dart';

class ServiceStatsGrid extends StatelessWidget {
  const ServiceStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      // En móvil las ponemos una debajo de otra; en laptop seguidas
      bool isMobile = width < 700;

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildStatCard("Operativos", "0", "En Uso (OK)", Icons.check_circle_outline, width, isMobile),
          _buildStatCard("En Reparación", "0", "En Taller", Icons.build_circle_outlined, width, isMobile),
          _buildStatCard("Paro Total", "0", "Críticos", Icons.error_outline, width, isMobile),
        ],
      );
    });
  }

  Widget _buildStatCard(String label, String value, String sub, IconData icon, double totalWidth, bool isMobile) {
    return Container(
      // Cálculo dinámico del ancho para que siempre quepan
      width: isMobile ? totalWidth : (totalWidth - 32) / 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Evita Bottom Overflow
              children: [
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Color(0xFFC62828), fontSize: 12, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Icon(icon, color: const Color(0xFFC62828).withOpacity(0.2), size: 32),
        ],
      ),
    );
  }
}