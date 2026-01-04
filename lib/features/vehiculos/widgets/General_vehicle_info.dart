import 'package:flutter/material.dart';
class GeneralVehicleInfo extends StatelessWidget {
  const GeneralVehicleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informacion General la Unidad Móvil", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            double fieldWidth = constraints.maxWidth > 800 ? (constraints.maxWidth / 4) - 12 : (constraints.maxWidth / 2) - 12;
            return Wrap(
              spacing: 12,
              runSpacing: 16,
              children: [
                _buildField("Unidad", fieldWidth),
                _buildField("Placas", fieldWidth),
                _buildField("Fecha", fieldWidth),
                _buildField("Kilometraje", fieldWidth),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildField(String label, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
        ],
      ),
    );
  }
}