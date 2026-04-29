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
        // Determinamos si es compacto basándonos en el ancho disponible
        bool isCompact = constraints.maxWidth < 400;

        return Container(
          // Definimos un padding simétrico, permitiendo que el alto crezca solo si es necesario
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // Un poco más redondeado para un look moderno
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Alinea el icono al centro del texto multi-línea
            children: [
              Expanded(
                child: Text(
                  userName != null ? "Bienvenido, $userName" : title,
                  style: TextStyle(
                    fontSize: isCompact ? 18 : 22,
                    fontWeight: FontWeight.w900, // Un poco más de peso visual
                    color: const Color(0xFF1A1C1E),
                    height: 1.2, // Mejora la legibilidad si el texto se divide en dos líneas
                  ),
                  // Eliminamos TextOverflow.ellipsis para permitir que el texto baje
                  softWrap: true, 
                  overflow: TextOverflow.visible,
                ),
              ),
              if (actionIcon != null) ...[
                const SizedBox(width: 16),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onActionTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC62828), // Rojo institucional
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(actionIcon, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}