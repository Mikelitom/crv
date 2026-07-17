import 'package:flutter/material.dart';

class ServiceStatsGrid extends StatelessWidget {
  const ServiceStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double spacing = 16.0;
      // Responsividad: 4 columnas en desktop, 2 en tablets, 1 en móviles
      int columns = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
      double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

      return Wrap(
        spacing: spacing, 
        runSpacing: spacing,
        children: [
          // Adaptando al diseño de la imagen:
          _StatCard("Alertas", "3", Icons.notifications_none, const Color(0xFFC62828), "requieren atención", cardWidth),
          _StatCard("Abiertas", "0", Icons.error_outline, Colors.orange, "sin asignar", cardWidth),
          _StatCard("Total", "13", Icons.calendar_today_outlined, Colors.blue, "inspecciones", cardWidth),
          _StatCard("Completadas", "12", Icons.check_circle_outline, Colors.green, "este mes", cardWidth),
        ],
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, subLabel;
  final IconData icon;
  final Color color;
  final double width;

  const _StatCard(this.label, this.value, this.icon, this.color, this.subLabel, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          // Icono con fondo circular suave
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          // Texto: Valor grande + Título/Subtítulo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subLabel,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}