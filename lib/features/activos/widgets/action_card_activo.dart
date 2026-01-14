import 'package:flutter/material.dart';
class ActionCardActivo extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const ActionCardActivo({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200), // Eliminado el amarillo
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.red.shade700, size: 30),
          ),
          SizedBox(height: 16),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(description, 
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12)),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(Icons.add, size: 18),
            label: Text("Crear ${title.split(' ')[1]}"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F), // Rojo sólido
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          )
        ],
      ),
    );
  }
}