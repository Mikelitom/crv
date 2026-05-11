import 'package:flutter/material.dart';

class InspectorAndActionsFooter extends StatelessWidget {
  // SOLUCIÓN: Definimos el parámetro onSave para recibir la función de la Page
  final VoidCallback onSave;

  const InspectorAndActionsFooter({
    super.key, 
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Inspector Responsable", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 20),
              const Text("Nombre del Inspector", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDE1E6))),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {}, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E0E0), 
                foregroundColor: Colors.black, 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: const Text("Vista Previa PDF"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onSave, // Se dispara la función al presionar
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828), 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: const Text("Guardar Inspección"),
            ),
          ],
        ),
      ],
    );
  }
}