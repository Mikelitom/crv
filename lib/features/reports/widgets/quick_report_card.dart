import 'package:flutter/material.dart';

class QuickReportCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String countText;
  final IconData icon;
  final VoidCallback onTap;

  const QuickReportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.countText,
    required this.icon,
    required this.onTap,
  });

  @override
  State<QuickReportCard> createState() => _QuickReportCardState();
}

class _QuickReportCardState extends State<QuickReportCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        // Elevación física en hover
        transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.08 : 0.04),
              blurRadius: isHovered ? 25 : 15,
              offset: Offset(0, isHovered ? 12 : 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECEA), // Fondo rojo tenue
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(widget.icon, color: const Color(0xFFC62828), size: 32),
            ),
            const SizedBox(height: 20),
            Text(widget.title, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
            const SizedBox(height: 10),
            Text(widget.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
            const SizedBox(height: 12),
            Text(widget.countText, 
              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: widget.onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Acceder", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}