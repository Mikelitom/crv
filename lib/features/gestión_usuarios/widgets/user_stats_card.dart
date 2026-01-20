import 'package:flutter/material.dart';
class UserStatsCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;

  const UserStatsCard({super.key, required this.label, required this.value, required this.icon});

  @override
  State<UserStatsCard> createState() => _UserStatsCardState();
}

class _UserStatsCardState extends State<UserStatsCard> {
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.08 : 0.04), // Sombra más oscura al pasar el mouse
              blurRadius: isHovered ? 25 : 15,
              offset: Offset(0, isHovered ? 12 : 8),
            )
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, 
                  style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(widget.value, 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFD32F2F) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, 
                color: isHovered ? Colors.white : const Color(0xFFD32F2F), size: 26),
            )
          ],
        ),
      ),
    );
  }
}