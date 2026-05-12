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
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 600;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFFC62828), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Método de Captura de Datos",
                    style: TextStyle(
                      fontWeight: FontWeight.w900, 
                      fontSize: isMobile ? 15 : 17, 
                      color: const Color(0xFF1A1C1E)
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Seleccione el método para ingresar la información",
              style: TextStyle(
                color: const Color(0xFF616161), 
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            const SizedBox(height: 20),
            Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              children: [
                _buildCompactButton(0, "Llenado Manual", Icons.edit_note_rounded, widget.onManualFill, isMobile),
                if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 16),
                _buildCompactButton(1, "Escanear QR/Serie", Icons.qr_code_2_rounded, widget.onScan, isMobile),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCompactButton(int index, String label, IconData icon, VoidCallback onTap, bool isMobile) {
    bool isSelected = selectedMethod == index;
    return Expanded(
      flex: isMobile ? 0 : 1,
      child: InkWell(
        onTap: () {
          setState(() => selectedMethod = index);
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isMobile ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC62828) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFC62828) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : const Color(0xFF616161), size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF1A1C1E), 
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