import 'package:flutter/material.dart';
import 'notification_item.dart';

class NotificationPanel extends StatelessWidget {
  final List<NotificationItem> children;

  const NotificationPanel({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Hace que el panel solo use el espacio necesario
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Notificaciones", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))
              ),
              if (children.isNotEmpty)
                TextButton(
                  onPressed: () {}, 
                  child: const Text("Ver todo", style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold))
                ),
            ],
          ),
          const Divider(height: 20, thickness: 0.8),
          
          // Si no hay notificaciones, mostramos un mensaje en lugar de dejar el espacio en blanco o dar error
          if (children.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "No tienes notificaciones pendientes",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            )
          else
            ...children, // Aquí se listan las notificaciones
        ],
      ),
    );
  }
}