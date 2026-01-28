import 'package:flutter/material.dart';

class HistoryPaymentVault extends StatelessWidget {
  const HistoryPaymentVault({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Comprobantes y Pagos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildSearchField(),
          const SizedBox(height: 24),
          _docItem("Factura_Amortiguadores.pdf", "Ref: INS-102-A", "26/01/2026"),
          _docItem("Checklist_Mensual.pdf", "Mensual", "01/01/2026"),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Buscar documento...",
        prefixIcon: const Icon(Icons.search, color: Color(0xFFC62828)),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _docItem(String name, String ref, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F3F5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Color(0xFFC62828), size: 24),
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("$date • $ref", style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )),
          IconButton(icon: const Icon(Icons.visibility_outlined, size: 18), onPressed: () {}),
          IconButton(icon: const Icon(Icons.file_download_outlined, color: Color(0xFFC62828), size: 18), onPressed: () {}),
        ],
      ),
    );
  }
}