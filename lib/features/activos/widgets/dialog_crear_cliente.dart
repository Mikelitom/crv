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
        _buildField("Teléfono", "+52..."),
        _buildField("Email", "contacto@empresa.com"),
        _buildField("Dirección / Minas", "Mina Santa Fe, Mina Norte", maxLines: 3),
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
        _buildField("Marca", "Toyota"),
        _buildField("Modelo", "Hilux"),
        Row(
          children: [
            Expanded(child: _buildField("Año", "2024")), // Se mapea a 'anio' en el modelo
            const SizedBox(width: 12),
            Expanded(child: _buildField("Placa", "ABC-123")),
          ],
        ),
        _buildField("ID Cliente Dueño", "ID-001"),
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
        _buildField("Marca", "Hydraulic S.A."),
        _buildField("Modelo", "HS-500"),
        _buildField("Número de Serie", "SN-2024-X"),
        _buildField("Capacidad", "500 Ton"),
      ],
    );
  }
}

// --- WIDGETS BASE (Estilo unificado) ---
class _BaseAssetDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _BaseAssetDialog({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(title, 
        style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 450, 
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: children)
        )
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Cancelar", style: TextStyle(color: Colors.grey))
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          ),
          child: const Text("Registrar", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// Campo de texto con diseño sin amarillo y foco rojo
Widget _buildField(String label, String hint, {int maxLines = 1}) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: TextField(
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label, 
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      // Cambia el color del borde cuando haces clic en el campo
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2)
      ),
    ),
  ),
);