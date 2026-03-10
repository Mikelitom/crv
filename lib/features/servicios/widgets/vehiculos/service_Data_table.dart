import 'package:flutter/material.dart';

class ServiceDataTable extends StatelessWidget {
  final bool isVehiculo;

  // Constructor sin 'const' obligatorio para evitar conflictos
  ServiceDataTable({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: Column(
        children: [
          // Encabezado de la tabla estilo "Inspecciones"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                _buildHeaderCell(isVehiculo ? 'UNIDAD' : 'PRENSA'),
                _buildHeaderCell('FOLIO'),
                _buildHeaderCell('ESTADO'),
              ],
            ),
          ),
          // Cuerpo de la tabla con estado vacío
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Column(
              children: [
                Icon(
                  isVehiculo ? Icons.directions_car : Icons.precision_manufacturing,
                  size: 48,
                  color: const Color(0xFFFDECEA),
                ),
                const SizedBox(height: 16),
                Text(
                  "No hay servicios registrados",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Color(0xFF455A64),
        ),
      ),
    );
  }
}