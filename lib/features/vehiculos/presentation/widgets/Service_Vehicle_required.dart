import 'package:flutter/material.dart';

class VehicleServiceRequired extends StatefulWidget {
  const VehicleServiceRequired({super.key});

  @override
  State<VehicleServiceRequired> createState() => _VehicleServiceRequiredState();
}

class _VehicleServiceRequiredState extends State<VehicleServiceRequired> {
  bool? requiresService;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Servicio", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const Text("Condiciones del servicio requerido", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          const Text("Requiere Servicio", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildOption("Si", true),
              const SizedBox(width: 25),
              _buildOption("No", false),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Observaciones", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              hintText: "Escribir notas adicionales...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDE1E6))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, bool value) {
    bool selected = requiresService == value;
    return InkWell(
      onTap: () => setState(() => requiresService = value),
      child: Row(
        children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFC62828) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: selected ? const Color(0xFFC62828) : Colors.grey),
            ),
            child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}