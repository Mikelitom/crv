import 'package:flutter/material.dart';

// 1. EL HEADER (BIENVENIDA)
class DynamicHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onIconTap;

  const DynamicHeader({required this.title, required this.icon, required this.onIconTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          InkWell(
            onTap: onIconTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}