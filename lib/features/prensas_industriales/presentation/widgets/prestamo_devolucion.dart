import 'package:flutter/material.dart';

class LoanAndInspectorSection extends StatelessWidget {
  const LoanAndInspectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
            "Préstamo o Devolución",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1A1C1E)),
          ),
          const SizedBox(height: 4),
          const Text(
            "En caso de préstamo o devolución de prensa (móvil) llenar este campo",
            style: TextStyle(color: Color(0xFF757575), fontSize: 13),
          ),
          const SizedBox(height: 24),
          _buildField("Área o Taller Solicitante"),
          _buildField("Nombre de quien recibe la prensa"),
          _buildField("Observaciones del Préstamo"),
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
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1C1E)),
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