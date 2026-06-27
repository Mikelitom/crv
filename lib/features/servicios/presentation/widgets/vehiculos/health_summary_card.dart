import 'package:flutter/material.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat("Hallazgos", "3", Colors.red),
          _stat("OS Abierta", "1", Colors.orange),
          _stat("Servicios", "5", Colors.blue),
          _stat("Inspecciones", "12", Colors.green),
        ],
      ),
    );
  }

  Widget _stat(String label, String val, Color color) => Column(children: [
    Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
    Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
  ]);
}