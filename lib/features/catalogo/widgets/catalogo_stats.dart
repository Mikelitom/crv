import 'package:flutter/material.dart';

class CatalogStats extends StatelessWidget {
  const CatalogStats({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;
      int columns = maxWidth > 1100 ? 3 : (maxWidth > 700 ? 2 : 1);

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 100, // Altura fija controlada para evitar desbordamiento
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          final labels = ["Catálogo", "Activos", "En Patio"];
          final icons = [Icons.inventory_2_outlined, Icons.settings_remote_outlined, Icons.event_available_outlined];
          return _buildStatCard(labels[index], "0", icons[index]);
        },
      );
    });
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Text(label, 
                  maxLines: 1,
                  style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(icon, color: const Color(0xFFD32F2F).withOpacity(0.2), size: 30),
        ],
      ),
    );
  }
}