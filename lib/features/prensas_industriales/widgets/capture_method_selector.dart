import 'package:flutter/material.dart';

class CaptureMethodSelector extends StatefulWidget {
  final VoidCallback onManualFill;
  final VoidCallback onScan;

  const CaptureMethodSelector({
    super.key,
    required this.onManualFill,
    required this.onScan,
  });

  @override
  State<CaptureMethodSelector> createState() => _CaptureMethodSelectorState();
}

class _CaptureMethodSelectorState extends State<CaptureMethodSelector> {
  int selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Padding reducido para un container más chico
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFFC62828), size: 20),
              const SizedBox(width: 10),
              const Text(
                "Método de Captura de Datos",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16, 
                  color: Color(0xFF1A1C1E) // Texto en negro/gris oscuro para sintonía
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Texto descriptivo en gris suave sintonizado
          const Text(
            "Seleccione el método más conveniente para ingresar la información de la inspección",
            style: TextStyle(
              color: Color(0xFF616161), 
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildCompactButton(0, "Llenado Manual", Icons.edit_note_rounded, widget.onManualFill),
              const SizedBox(width: 16),
              _buildCompactButton(1, "Escanear", Icons.qr_code_2_rounded, widget.onScan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactButton(int index, String label, IconData icon, VoidCallback onTap) {
    bool isSelected = selectedMethod == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => selectedMethod = index);
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFC62828), // Rojo institucional
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 14
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}