import 'package:flutter/material.dart';

class VehicleListTile extends StatelessWidget {
  final String model;
  final String plate;
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleListTile({
    super.key,
    required this.model,
    required this.plate,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == "WORKSHOP" ? Colors.orange : (status == "AVAILABLE" ? Colors.green : Colors.blue);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF1F1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFFC62828) : Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.directions_car, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(plate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ]),
                _buildBadge(status, statusColor),
              ],
            ),
            const SizedBox(height: 4),
            Text(model, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.orange),
              const Text(" 3 hallazgos", style: TextStyle(color: Colors.grey, fontSize: 10)),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
              const Text(" 15 Jun 2026", style: TextStyle(color: Colors.grey, fontSize: 10)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}