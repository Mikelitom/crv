import 'package:flutter/material.dart';

class HistoryPaymentVault extends StatelessWidget {
  const HistoryPaymentVault({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bóveda de Documentos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // EJEMPLO: Una Orden de Servicio con múltiples archivos dentro
          _buildDocumentFolder(
            title: "Orden de Servicio #8821",
            date: "26 May 2026",
            files: [
              {'name': 'Factura_Repuesto.pdf', 'type': 'pdf'},
              {'name': 'Evidencia_Motor.jpg', 'type': 'img'},
              {'name': 'Comprobante_Pago.pdf', 'type': 'pdf'},
            ],
          ),
          
          const SizedBox(height: 16),

          _buildDocumentFolder(
            title: "Checklist Preventivo Mensual",
            date: "01 May 2026",
            files: [
              {'name': 'Reporte_Final.pdf', 'type': 'pdf'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentFolder({required String title, required String date, required List<Map<String, String>> files}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.folder_zip_rounded, color: Colors.amber, size: 28),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text("$date • ${files.length} archivos", style: const TextStyle(fontSize: 11)),
        children: files.map((file) => _buildFileItem(file['name']!, file['type']!)).toList(),
      ),
    );
  }

  Widget _buildFileItem(String name, String type) {
    return ListTile(
      leading: Icon(
        type == 'pdf' ? Icons.picture_as_pdf : Icons.image,
        color: type == 'pdf' ? Colors.red : Colors.blue,
        size: 18,
      ),
      title: Text(name, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.download_rounded, size: 16, color: Colors.grey),
      dense: true,
    );
  }
}