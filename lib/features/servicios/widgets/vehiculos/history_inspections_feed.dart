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
            const Text("Reportes de Inspección", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            _buildDateFilter(),
          ],
        ),
        const SizedBox(height: 24),
        // Los contenedores ahora abarcan el ancho completo del flex asignado
        _buildFullWidthCard(
          status: "CRÍTICO", 
          color: Colors.red, 
          note: "Falla en suspensión trasera reportada. Se requiere atención inmediata en el eje posterior.", 
          user: "Juan Pérez", 
          ref: "INS-102-A", 
          photos: ["p1", "p2"], 
          showButton: true
        ),
        _buildFullWidthCard(
          status: "OPERATIVO", 
          color: Colors.green, 
          note: "Unidad en buen estado tras mantenimiento preventivo.", 
          user: "Sistema", 
          ref: "PRV-001-B", 
          photos: ["p3"], 
          showButton: false
        ),
      ],
    );
  }

  Widget _buildFullWidthCard({
    required String status, 
    required Color color, 
    required String note, 
    required String user, 
    required String ref, 
    required List<String> photos,
    required bool showButton,
  }) {
    return Container(
      width: double.infinity, // Mantiene el contenedor abarcando todo el espacio
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          // HEADER CON BOTÓN COMPACTO A LA DERECHA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05), 
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statusBadge(status, color),
                if (showButton) const _HoverActionButton(), // Botón interactivo
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note, style: const TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 20),
                
                const Text("EVIDENCIA FOTOGRÁFICA", 
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                
                // Mantiene el grid de evidencias sin recortar el container
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: photos.map((p) => _buildPhotoItem()).toList(),
                ),

                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(user, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text("Ref: $ref", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPhotoItem() {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 24),
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

// COMPONENTE DE BOTÓN CON EFECTO HOVER
class _HoverActionButton extends StatefulWidget {
  const _HoverActionButton();

  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<_HoverActionButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          // Inicia blanco con borde rojo, cambia a rojo sólido
          color: isHovered ? const Color(0xFFC62828) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFC62828), width: 1.2),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline_rounded, 
                size: 14, 
                color: isHovered ? Colors.white : const Color(0xFFC62828)
              ),
              const SizedBox(width: 6),
              Text(
                "ORDEN DE SERVICIO",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: isHovered ? Colors.white : const Color(0xFFC62828),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}