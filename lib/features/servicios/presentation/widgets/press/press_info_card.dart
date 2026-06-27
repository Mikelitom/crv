import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:flutter/material.dart';

class PressInfoCard extends StatelessWidget {
  final Press press;

  const PressInfoCard({super.key, required this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // COLUMNA IZQUIERDA: Info detallada
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${press.model} - ${press.serie}", 
                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _infoBadge(Icons.speed, "9,800 km"),
                    _infoBadge(Icons.calendar_today, "Última: 15/06/2026"),
                    _infoBadge(Icons.build, "Último servicio: 5,000 km"),
                  ],
                ),
              ],
            ),
          ),
          // COLUMNA DERECHA: KPIs Grandes
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _kpiItem("3", "Hallazgos Activos", Colors.red, Icons.warning_amber_rounded),
                _kpiItem("1", "Orden Abierta", Colors.orange, Icons.calendar_month),
                _kpiItem("5", "Servicios", Colors.blue, Icons.check_circle_outline),
                _kpiItem("12", "Inspecciones", Colors.green, Icons.fact_check_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // En VehicleInfoCard, dentro de _buildKpiSummary:
  Widget _kpiItem(String val, String label, Color color, IconData icon) {
    return Expanded( // El Expanded asegura que todos tengan el mismo ancho
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8), // Espaciado simétrico
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08), 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2))
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}