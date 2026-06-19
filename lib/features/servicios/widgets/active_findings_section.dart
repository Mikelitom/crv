import 'package:flutter/material.dart';

class ActiveFindingsSection extends StatelessWidget {
  const ActiveFindingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hallazgos Activos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildItem("Filtro de aceite", "Reposición", "3 inspecciones seguidas"),
          _buildItem("Llanta auxiliar", "Reparación", "2 inspecciones seguidas"),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String status, String note) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(note, style: const TextStyle(fontSize: 12)),
    trailing: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
    ),
  );
}