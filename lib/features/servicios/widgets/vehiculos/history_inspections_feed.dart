import 'package:flutter/material.dart';

class HistoryInspectionsFeed extends StatelessWidget {
  const HistoryInspectionsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Reportes de Inspección", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            _buildDateFilter(),
          ],
        ),
        const SizedBox(height: 24),
        // Se agregaron listas de fotos de ejemplo para las tarjetas
        _buildAnimatedCard(0, "CRÍTICO", Colors.red, "Falla en suspensión trasera reportada.", "Juan Pérez", "INS-102-A", ["p1", "p2"]),
        _buildAnimatedCard(1, "OPERATIVO", Colors.green, "Unidad en buen estado tras mantenimiento.", "Sistema", "PRV-001-B", ["p3", "p4", "p5"]),
      ],
    );
  }

  // Se agregó el parámetro List<String> photos
  Widget _buildAnimatedCard(int index, String status, Color color, String note, String user, String ref, List<String> photos) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 200)),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          // Sombreado gris para dar profundidad
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                  const Text("26 Ene 2026", style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note, style: const TextStyle(fontSize: 14, height: 1.5)),
                  
                  // --- SECCIÓN NUEVA: EVIDENCIA FOTOGRÁFICA ---
                  const SizedBox(height: 16),
                  const Text("EVIDENCIA FOTOGRÁFICA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, i) {
                        return Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF1F3F5)),
                            // Aquí iría tu imagen real
                            image: const DecorationImage(
                              image: NetworkImage('https://via.placeholder.com/150'), 
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.zoom_in, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // --------------------------------------------

                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icono rojo vibrante solicitado
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14, color: Color(0xFFC62828)),
                          const SizedBox(width: 6),
                          Text(user, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text("Ref: $ref", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(12)),
      child: const Row(children: [Icon(Icons.calendar_month, color: Colors.white, size: 16), SizedBox(width: 8), Text("Filtrar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
    );
  }
}