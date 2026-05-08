import 'package:flutter/material.dart';

class HistoryInspectionsFeed extends StatelessWidget {
  const HistoryInspectionsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Historial de Reportes e Inspecciones",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
        ),
        const SizedBox(height: 32),
        
        // Reporte Crítico con botón de Orden de Servicio
        _buildTimelineItem(
          status: "CRÍTICO",
          color: Colors.red,
          date: "26 May 2026",
          user: "Ing. Miguel Fajardo",
          note: "Falla en motor principal. Sobrecalentamiento detectado.",
          showServiceOrder: true, // Esto activa el botón
        ),

        _buildTimelineItem(
          status: "OPERATIVO",
          color: Colors.green,
          date: "15 May 2026",
          user: "Sistema Central",
          note: "Mantenimiento preventivo mensual completado con éxito.",
          showServiceOrder: false,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String status,
    required Color color,
    required String date,
    required String user,
    required String note,
    required bool showServiceOrder,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicador lateral (Línea de tiempo)
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Container(width: 2, height: 220, color: const Color(0xFFECEFF1)),
          ],
        ),
        const SizedBox(width: 20),
        
        // Contenedor del reporte (El "Documento")
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F3F5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusBadge(status, color),
                    Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(note, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 20),
                
                // Evidencia (Imágenes)
                const Text("EVIDENCIA FOTOGRÁFICA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _photoPlaceholder(),
                    const SizedBox(width: 8),
                    _photoPlaceholder(),
                  ],
                ),
                
                const Divider(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Auditor: $user", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    
                    // BOTÓN GENERAR ORDEN (Solo si es crítico)
                    if (showServiceOrder)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          print("Generando Orden de Servicio...");
                        },
                        icon: const Icon(Icons.add_task, size: 16),
                        label: const Text("GENERAR ORDEN", style: TextStyle(fontSize: 11)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFECEFF1))),
      child: const Icon(Icons.image, color: Colors.grey, size: 20),
    );
  }
}