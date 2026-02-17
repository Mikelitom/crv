import 'package:flutter/material.dart';

class HistoryTechInfo extends StatelessWidget {
  const HistoryTechInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 15))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_outlined, color: Color(0xFFC62828), size: 22),
              SizedBox(width: 12),
              Text("Datos de Unidad Operativa", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            ],
          ),
          const SizedBox(height: 24),
          _infoTile(Icons.tag_rounded, "Placas ", "SON-123-A"),
          _infoTile(Icons.speed_rounded, "Kilometraje Total", "45,230 KM"),
          _infoTile(Icons.event_available_rounded, "Próximo Preventivo", "15 Mar 2026"),
          _infoTile(Icons.history_toggle_off_rounded, "Última Inspección", "26 Ene 2026"),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: const Color(0xFFC62828)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1C1E))),
            ],
          ),
        ],
      ),
    );
  }
}