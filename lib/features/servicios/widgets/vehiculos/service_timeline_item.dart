import 'package:flutter/material.dart';

class ServiceTimelineItem extends StatelessWidget {
  final String date;
  final String workshop;
  final String description;
  final String km;
  final bool hasInvoice;

  const ServiceTimelineItem({
    super.key,
    required this.date,
    required this.workshop,
    required this.description,
    required this.km,
    this.hasInvoice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: Color(0xFFC62828), width: 4)), // Indicador de línea de tiempo
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(workshop, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 8),
                Text("Kilometraje: $km", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
              ],
            ),
          ),
          if (hasInvoice)
            IconButton(
              icon: const Icon(Icons.description_outlined, color: Color(0xFFC62828)),
              onPressed: () {}, // Ver factura
              tooltip: "Ver Comprobante",
            ),
        ],
      ),
    );
  }
}