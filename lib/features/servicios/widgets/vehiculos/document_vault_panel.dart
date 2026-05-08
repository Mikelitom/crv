import 'package:flutter/material.dart';

class HistoryDocumentsPanel extends StatelessWidget {
  const HistoryDocumentsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Expediente Documental", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFFC62828)), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 20),
          _buildInspectionFolder("Manual de Operación", "PDF • 12 MB", 1),
          _buildInspectionFolder("Facturas de Taller", "Ene 2026 - May 2026", 5),
          _buildInspectionFolder("Pólizas de Seguro", "Vigente: 2027", 2),
        ],
      ),
    );
  }

  Widget _buildInspectionFolder(String title, String subtitle, int fileCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.folder_open_rounded, color: Colors.amber, size: 28),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Text("$fileCount", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}