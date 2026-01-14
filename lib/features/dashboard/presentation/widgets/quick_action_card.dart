import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const QuickActionCard({super.key, required this.title, required this.description, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          // const Spacer(),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Iniciar"),
          )
        ],
      ),
    );
  }
}