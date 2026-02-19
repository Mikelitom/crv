import 'package:flutter/material.dart';

class GeneralBandaInfo extends StatelessWidget {
  const GeneralBandaInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Determinamos si es modo móvil según el ancho disponible
      bool isMobile = constraints.maxWidth < 800;

      return Container(
        width: double.infinity, // Abarca todo el ancho
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
              "Información General del Reporte",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Complete los datos",
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
            ),
            const SizedBox(height: 24),
            
            // Lógica responsiva: Column para móvil, Wrap para Laptop
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildField("PLANTA", isMobile, constraints.maxWidth),
                _buildField("AREA", isMobile, constraints.maxWidth),
                _buildField("RESPONSABLE", isMobile, constraints.maxWidth),
                _buildField("SECCION", isMobile, constraints.maxWidth),
                _buildField("FECHA", isMobile, constraints.maxWidth),
                _buildField("TRANSPORTADOR", isMobile, constraints.maxWidth),
                _buildField("BANDA RECOMENDADA", isMobile, constraints.maxWidth),
                _buildField("MATERIAL Y GRANULOMETRIA", isMobile, constraints.maxWidth),
                _buildField("ELABORO", isMobile, constraints.maxWidth),
                _buildField("PRESENTAR", isMobile, constraints.maxWidth),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildField(String label, bool isMobile, double maxWidth) {
    // En laptop dividimos el ancho entre 2 menos el espacio del 'spacing'
    double fieldWidth = isMobile ? maxWidth : (maxWidth / 2) - 52;

    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDDE1E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}