import 'package:flutter/material.dart';

class LoanAndInspectorSection extends StatelessWidget {
  const LoanAndInspectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sección Préstamo o Devolución
        _buildSectionCard("Préstamo o Devolución", [
          "Área o Taller Solicitante",
          "Nombre de quien recibe la prensa",
          "Observaciones del Préstamo"
        ]),
        const SizedBox(height: 16),
        // Sección Inspector
        _buildSectionCard("Inspector Responsable", ["Nombre del Inspector"]),
        const SizedBox(height: 24),
        // Botones de Acción
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
              child: const Text("Vista Previa PDF", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Guardar Inspección", style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSectionCard(String title, List<String> fields) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ...fields.map((f) => Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextField(decoration: InputDecoration(labelText: f, border: const OutlineInputBorder())),
          )),
        ],
      ),
    );
  }
}