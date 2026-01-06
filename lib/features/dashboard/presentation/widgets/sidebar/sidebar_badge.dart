import 'package:flutter/material.dart';

class SidebarBadge extends StatelessWidget {
  final int count;

  const SidebarBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
    );
  }
}