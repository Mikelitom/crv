import 'package:flutter/material.dart';

class GeneralEquipmentInfo extends StatelessWidget {
  final Map<String, dynamic> equipmentData;

  const GeneralEquipmentInfo({super.key, required this.equipmentData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Definimos si es móvil según el ancho de la pantalla
      bool isMobile = constraints.maxWidth < 600;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 20 : 32),
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
              "Informacion General del Equipo",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Complete los datos tecnicos de la prensa a inspeccionar",
              style: TextStyle(color: Color(0xFF757575), fontSize: 13),
            ),
            const SizedBox(height: 24),
            
            // Lógica de disposición: Row para PC, Column para Móvil
            if (isMobile)
              Column(
                children: [
                  _buildFormFields(constraints.maxWidth), // Formulario primero
                  const SizedBox(height: 32),
                  _buildImageSection(), // Imagen hasta abajo
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildFormFields(constraints.maxWidth)),
                  const SizedBox(width: 40),
                  Expanded(flex: 2, child: _buildImageSection()),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFormFields(double maxWidth) {
    bool isMobile = maxWidth < 600;
    // Si es móvil, el ancho es el total; si es PC, se divide entre 2 menos el espacio
    double fieldWidth = isMobile ? maxWidth : (maxWidth / 2) - 80;

    return Wrap(
      spacing: 24,
      runSpacing: 20,
      children: [
        _buildField("Fecha de Inspeccion", fieldWidth),
        _buildField("Modelo", fieldWidth),
        _buildField("VOLTS", fieldWidth),
        _buildField("Área", fieldWidth),
        _buildField("Tipo", fieldWidth),
        _buildField("Serie", fieldWidth),
      ],
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Image.asset(
        'assets/images/prensa_industrial.png',
        height: 220,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildField(String label, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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