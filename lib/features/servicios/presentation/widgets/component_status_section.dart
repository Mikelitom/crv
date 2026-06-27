import 'package:flutter/material.dart';

class ComponentStatusSection extends StatelessWidget {
  const ComponentStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Estado de Componentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _compRow("MOTOR", ["Aceite", "Filtro", "Banda"]),
          _compRow("CHASIS", ["Suspensión", "Llanta Aux"]),
        ],
      ),
    );
  }

  Widget _compRow(String title, List<String> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Wrap(spacing: 10, children: items.map((i) => Chip(label: Text(i))).toList()),
      const SizedBox(height: 20),
    ],
  );
}