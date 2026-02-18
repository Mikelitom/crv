import 'package:flutter/material.dart';

class LoanAndInspectorSection extends StatelessWidget {
  const LoanAndInspectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SECCIÓN PRÉSTAMO O DEVOLUCIÓN
        _buildMainCard(
          title: "Préstamo o Devolución",
          subtitle: "En caso de préstamo o devolución de prensa (móvil) llenar este campo",
          fields: [
            "Área o Taller Solicitante",
            "Nombre de quien recibe la prensa",
            "Observaciones del Préstamo"
          ],
        ),
        const SizedBox(height: 20),
        
        // SECCIÓN INSPECTOR
        _buildMainCard(
          title: "Inspector Responsable",
          subtitle: "Persona encargada de realizar la validación de los puntos anteriores",
          fields: ["Nombre del Inspector"],
        ),
        const SizedBox(height: 32),

        // BOTONES DE ACCIÓN RESPONSIVOS
        LayoutBuilder(builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.end,
            children: [
              _buildActionButton(
                label: "Vista Previa PDF",
                color: const Color(0xFFE0E0E0),
                textColor: Colors.black,
                onPressed: () {},
              ),
              _buildActionButton(
                label: "Guardar Inspección",
                color: const Color(0xFFC62828), // Rojo institucional
                textColor: Colors.white,
                onPressed: () {},
              ),
            ],
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMainCard({required String title, required String subtitle, required List<String> fields}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1A1C1E))),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF757575), fontSize: 13)),
          const SizedBox(height: 24),
          ...fields.map((f) => _buildField(f)).toList(),
        ],
      ),
    );
  }

  Widget _buildField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label arriba del input como en la foto
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1C1E)),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA), // Gris claro de tus fotos
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

  Widget _buildActionButton({required String label, required Color color, required Color textColor, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}