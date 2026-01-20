import 'package:flutter/material.dart';

class QuickActionCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, isHovered ? -8 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white, // Cero amarillo
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.08 : 0.04),
              blurRadius: isHovered ? 30 : 15,
              offset: Offset(0, isHovered ? 12 : 6),
            ),
          ],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon,
                color: isHovered ? Colors.white : const Color(0xFFC62828),
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
            const SizedBox(height: 8),
            Text(widget.description, // Sin conteos de equipos
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: widget.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isHovered ? const Color(0xFFE53935) : const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  elevation: isHovered ? 4 : 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Iniciar Inspección", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}