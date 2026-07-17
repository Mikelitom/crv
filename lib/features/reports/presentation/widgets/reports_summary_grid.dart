import 'package:flutter/material.dart';

class ReportsSummaryGrid extends StatelessWidget {
  final int total, pending, approved, returned;

  const ReportsSummaryGrid({
    super.key,
    required this.total,
    required this.pending,
    required this.approved,
    required this.returned,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double spacing = 16;
      int crossAxisCount = constraints.maxWidth > 1100 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
      double cardWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          _StatCard(
            label: "Total de Reportes",
            value: "$total",
            subtitle: "Todos los reportes",
            icon: Icons.folder_open,
            color: const Color(0xFFC62828), // Rojo Institucional
            width: cardWidth,
            isPrimary: true,
          ),
          _StatCard(
            label: "Pendientes",
            value: "$pending",
            subtitle: "Requieren revisión",
            icon: Icons.schedule,
            color: Colors.orange,
            width: cardWidth,
          ),
          _StatCard(
            label: "Aprobados",
            value: "$approved",
            subtitle: "Reportes aprobados",
            icon: Icons.check_circle_outline,
            color: Colors.green,
            width: cardWidth,
          ),
          _StatCard(
            label: "Regresados",
            value: "$returned",
            subtitle: "Con observaciones",
            icon: Icons.refresh,
            color: Colors.purple,
            width: cardWidth,
          ),
        ],
      );
    });
  }
}

class _StatCard extends StatefulWidget {
  final String label, value, subtitle;
  final IconData icon;
  final Color color;
  final double width;
  final bool isPrimary;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.width,
    this.isPrimary = false,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: widget.width,
        padding: const EdgeInsets.all(24),
        transform: Matrix4.translationValues(0, isHovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: widget.isPrimary
              ? widget.color
              : (isHovered ? Colors.grey.shade50 : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.isPrimary ? widget.color : widget.color.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.15 : 0.05),
              blurRadius: isHovered ? 20 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isPrimary 
                    ? Colors.white.withValues(alpha: 0.2) 
                    : widget.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon, 
                color: widget.isPrimary ? Colors.white : widget.color, 
                size: 24
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isPrimary ? Colors.white70 : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: widget.isPrimary ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: widget.isPrimary ? Colors.white70 : Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}