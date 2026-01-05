import 'package:flutter/material.dart';
class CaptureMethodSelector extends StatelessWidget {
  final VoidCallback onManualFill;
  final VoidCallback onScan;

  const CaptureMethodSelector({super.key, required this.onManualFill, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.camera_alt_outlined, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text("Método de Captura de Datos", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildButton("Llenado Manual", Icons.edit_note, onManualFill)),
              const SizedBox(width: 12),
              Expanded(child: _buildButton("Escanear", Icons.qr_code_scanner, onScan)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC62828),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}