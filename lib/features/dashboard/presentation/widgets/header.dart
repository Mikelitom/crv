import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? userName; 
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Si el ancho es muy pequeño, reducimos el tamaño de fuente o el espaciado
        bool isCompact = constraints.maxWidth < 400;

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
              Expanded(
                child: Text(
                  userName != null ? "Bienvenido, $userName" : title,
                  style: TextStyle(
                    fontSize: isCompact ? 18 : 22, 
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actionIcon != null)
                const SizedBox(width: 10),
              if (actionIcon != null)
                InkWell(
                  onTap: onActionTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(actionIcon, color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}