import 'package:flutter/material.dart';

// --- DIÁLOGO CLIENTE ---
class DialogCrearCliente extends StatelessWidget {
  const DialogCrearCliente({super.key});
  @override
  Widget build(BuildContext context) {
    return _BaseAssetDialog(
      title: "Registrar Nuevo Cliente",
      children: [
        _buildField("Nombre Completo", "Ej. Juan Pérez"),
        _buildField("Empresa", "Minera del Norte"),
        _buildField("Teléfono", "+52 444..."),
        _buildField("Email", "contacto@reprosisa.com"),
        _buildField("Dirección / Minas", "Mina Santa Fe, Mina Norte", maxLines: 2),
      ],
    );
  }
}

// --- DIÁLOGO VEHÍCULO ---
class DialogCrearVehiculo extends StatelessWidget {
  const DialogCrearVehiculo({super.key});
  @override
  Widget build(BuildContext context) {
    return _BaseAssetDialog(
      title: "Registrar Vehículo",
      children: [
        _buildField("Tipo", "Pickup / Camión / Sedán"),
        _buildField("Marca", "Toyota"),
        _buildField("Modelo", "Hilux"),
        Row(
          children: [
            Expanded(child: _buildField("Año", "2026")),
            const SizedBox(width: 16),
            Expanded(child: _buildField("Placa", "ABC-123")),
          ],
        ),
      ],
    );
  }
}

// --- DIÁLOGO PRENSA ---
class DialogCrearPrensa extends StatelessWidget {
  const DialogCrearPrensa({super.key});
  @override
  Widget build(BuildContext context) {
    return _BaseAssetDialog(
      title: "Registrar Prensa Industrial",
      children: [
        _buildField("Tipo", "Hidráulica / Mecánica"),
        _buildField("Modelo", "HS-500"),
        _buildField("Volts", "220V"),
        _buildField("Número de Serie", "SN-2026-X"),
        _buildField("Tamaño", "5 Tons"),
      ],
    );
  }
}

// --- WIDGET BASE (DISEÑO MEJORADO) ---
class _BaseAssetDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _BaseAssetDialog({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        decoration: BoxDecoration(
          // Fondo institucional tenue al 4%
          color: const Color(0xFFD32F2F).withOpacity(0.04), 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFD32F2F), size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1A1C1E),
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 480, 
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", 
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        // Botón con sombra proyectada (BoxShadow)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD32F2F).withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Registrar", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

// COMPONENTE DE CAMPO (INPUT) CON DISEÑO "SOFT"
Widget _buildField(String label, String hint, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF454B4E),
            ),
          ),
        ),
        TextField(
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            // Fondo gris muy claro para evitar saturación
            fillColor: const Color(0xFFF8F9FA), 
            contentPadding: const EdgeInsets.all(18),
            // Bordes redondeados a 16px
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
          ),
        ),
      ],
    ),
  );
}