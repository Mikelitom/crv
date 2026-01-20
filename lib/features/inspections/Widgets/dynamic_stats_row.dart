import 'package:flutter/material.dart';

class DynamicStatsRow extends StatelessWidget {
  final List<dynamic> stats;
  const DynamicStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      // 4 columnas en PC para que aparezcan seguidas
      int crossAxisCount = width > 1200 ? 3 : (width > 800 ? 2 : 1);
      double spacing = 20.0;
      double itemWidth = (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: stats.map((stat) => _StatCard(
          label: stat.label, 
          value: stat.value, 
          width: itemWidth
        )).toList(),
      );
    });
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final double width;
  const _StatCard({required this.label, required this.value, required this.width});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.08 : 0.04),
              blurRadius: isHovered ? 20 : 12,
              offset: Offset(0, isHovered ? 10 : 6),
            )
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, 
                  style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(widget.value, 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
              ],
            ),
            const Spacer(),
            // Icono interactivo que cambia de color
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.analytics_outlined, 
                color: isHovered ? Colors.white : const Color(0xFFC62828), size: 26),
            )
          ],
        ),
      ),
    );
  }
}