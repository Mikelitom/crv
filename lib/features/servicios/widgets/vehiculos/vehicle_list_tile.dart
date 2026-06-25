import 'package:flutter/material.dart';

class VehicleListTile extends StatelessWidget {
  final String model;
  final String plate;
  final String status; // WORKSHOP, AVAILABLE, OCCUPIED
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
    // Definición de colores según estatus
    Color statusColor = status == 'WORKSHOP' 
        ? const Color(0xFFC62828) // Rojo corporativo
        : const Color(0xFF388E3C); // Verde para disponible

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected 
            ? Border.all(color: const Color(0xFFC62828), width: 2) 
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          model,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1C1B1F)),
        ),
        subtitle: Text(
          plate,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ),
      ),
    );
  }
}