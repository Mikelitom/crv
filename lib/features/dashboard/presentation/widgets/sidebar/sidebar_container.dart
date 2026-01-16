import 'package:flutter/material.dart';

class SidebarContainer extends StatelessWidget {
  final Widget child;

  const SidebarContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      // Cambiado a blanco para que resalten los ítems rojos
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}