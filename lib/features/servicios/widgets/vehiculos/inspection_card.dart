import 'package:flutter/material.dart';

class InspectionCard extends StatelessWidget {
  final String date;
  final String status;
  final Color statusColor;
  final String comment;
  final String auditor;
  final String scId;
  final List<String> evidencePhotos; // Lista de rutas de imágenes
  final int index;

  const InspectionCard({
    super.key,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.comment,
    required this.auditor,
    required this.scId,
    required this.evidencePhotos,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        // Sombreado gris profundo para resaltar sobre el fondo
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 12),
          )
        ],
        border: Border.all(color: statusColor.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          // Cabecera con el Estatus (CRÍTICO, OPERATIVO, etc.)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                Text(date, style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment, style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF2D3133))),
                const SizedBox(height: 20),
                
                // --- SECCIÓN DE EVIDENCIA FOTOGRÁFICA ---
                const Text("EVIDENCIA FOTOGRÁFICA", 
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: evidencePhotos.length,
                    itemBuilder: (context, i) {
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF1F3F5)),
                          image: const DecorationImage(
                            image: AssetImage('assets/img/placeholder_car.jpg'), // Cambiar por tu lógica de carga
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: const Icon(Icons.zoom_in_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const Divider(height: 40),
                
                // Pie de tarjeta con Auditor y Referencia
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(Icons.person_outline, auditor),
                    _buildInfoItem(Icons.tag, "Ref: $scId"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFFC62828)), // Icono rojo vivo
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      ],
    );
  }
}