import 'package:flutter/material.dart';


class ActionCardActivo extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const ActionCardActivo({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<ActionCardActivo> createState() => _ActionCardActivoState();
}

class _ActionCardActivoState extends State<ActionCardActivo> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 280,
        curve: Curves.easeInOut,
        // Elevación física del card completo
        transform: Matrix4.translationValues(0, isHovered ? -8 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.08 : 0.04),
              blurRadius: isHovered ? 25 : 15,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            // EFECTO 1: El contenedor del icono cambia de color
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFD32F2F) : const Color(0xFFFDECEA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon, 
                // El icono cambia a blanco en hover para contraste
                color: isHovered ? Colors.white : const Color(0xFFD32F2F), 
                size: 32
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            const SizedBox(height: 8),
            Text(
              widget.description, 
              textAlign: TextAlign.center, 
              style: const TextStyle(color: Colors.grey, fontSize: 12)
            ),
            const SizedBox(height: 20),
            // EFECTO 2: El botón reacciona visualmente
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: widget.onTap,
                icon: const Icon(Icons.add, size: 18),
                label: Text("Crear ${widget.title.split(' ')[1]}"),
                style: ElevatedButton.styleFrom(
                  // Cambio sutil de tono en el botón
                  backgroundColor: isHovered ? const Color(0xFFB71C1C) : const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  // El botón gana sombra propia en hover
                  elevation: isHovered ? 4 : 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}