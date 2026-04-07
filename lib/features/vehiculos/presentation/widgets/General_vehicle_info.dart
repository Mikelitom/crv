import 'package:flutter/material.dart';

class GeneralVehicleInfo extends StatelessWidget {
  const GeneralVehicleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Determinamos si es modo móvil o laptop/desktop
      bool isMobile = constraints.maxWidth < 800;

      return Container(
        // El contenedor ahora ocupa todo el ancho disponible
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Información General la Unidad Móvil",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Complete los datos técnicos de la unidad móvil",
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
            ),
            const SizedBox(height: 24),
            
            // Usamos un Row para Laptop (una sola fila) y un Column para Móvil
            if (isMobile)
              Column(
                children: [
                  _buildField("Unidad", double.infinity),
                  const SizedBox(height: 16),
                  _buildField("Placas", double.infinity),
                  const SizedBox(height: 16),
                  _buildField("Fecha", double.infinity),
                  const SizedBox(height: 16),
                  _buildField("Kilometraje", double.infinity),
                ],
              )
            else
              Row(
                children: [
                  // Cada campo se expande proporcionalmente para llenar la fila
                  Expanded(child: _buildField("Unidad", double.infinity)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField("Placas", double.infinity)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField("Fecha", double.infinity)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField("Kilometraje", double.infinity)),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildField(String label, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta arriba del input como en la imagen de referencia
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA), // Gris sutil para el fondo
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDE1E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5), // Borde rojo al seleccionar
              ),
            ),
          ),
        ],
      ),
    );
  }
}