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
              const Text("Gestión de Evidencias", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.create_new_folder_outlined, color: Color(0xFFC62828)), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 20),
          _buildInspectionFolder("Inspección INS-102-A", "26 Ene 2026", 4),
          _buildInspectionFolder("Mantenimiento PRV-001-B", "15 Ene 2026", 2),
        ],
      ),
    );
  }

  Widget _buildInspectionFolder(String title, String date, int fileCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: const Icon(Icons.folder_copy_rounded, color: Colors.amber, size: 28),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text("$date • $fileCount archivos", style: const TextStyle(fontSize: 11, color: Colors.grey)),
        children: [
          _buildFileItem("Comprobante_Pago.pdf", Icons.receipt_long_rounded, Colors.green),
          _buildFileItem("Factura_Taller.pdf", Icons.picture_as_pdf_rounded, Colors.red),
          Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file_rounded, size: 16),
              label: const Text("SUBIR ARCHIVO", style: TextStyle(fontSize: 11)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFC62828),
                side: const BorderSide(color: Color(0xFFC62828)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFileItem(String name, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 18),
      title: Text(name, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.download_rounded, size: 16, color: Colors.grey),
      dense: true,
    );
  }
}