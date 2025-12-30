import 'package:flutter/material.dart';
import 'notification_item.dart';

class NotificationPanel extends StatelessWidget {
  final List<NotificationItem> children;

  const NotificationPanel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Notificaciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("Ver todo", style: TextStyle(color: Colors.red))),
            ],
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}