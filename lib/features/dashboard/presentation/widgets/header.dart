import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? userName; // Opcional: Si viene, muestra el saludo
  final IconData? actionIcon;
  final VoidCallback? onActionTap;

  const CustomHeader({
    super.key,
    required this.title,
    this.userName,
    this.actionIcon,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lógica: Si hay userName, dice "Bienvenido, Juan". Si no, usa el title.
          Text(
            userName != null ? "Bienvenido, $userName" : title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (actionIcon != null)
            InkWell(
              onTap: onActionTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935), // Rojo del diseño
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(actionIcon, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}