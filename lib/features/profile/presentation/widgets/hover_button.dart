import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final String label;
  final Color baseColor;
  final Color hoverColor;
  final VoidCallback onTap;

  const HoverButton({
    super.key, 
    required this.label, 
    required this.baseColor, 
    required this.hoverColor, 
    required this.onTap,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: _isHovered ? widget.hoverColor : widget.baseColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (_isHovered ? widget.hoverColor : widget.baseColor).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(widget.label, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
        ),
      ),
    );
  }
}