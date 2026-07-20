import 'package:flutter/material.dart';

class DashboardStatsCard extends StatefulWidget {
  final String label;
  final String value;
  final String sublabel;
  final IconData icon;
  final VoidCallback? onTap; // Funcionalidad al hacer clic

  const DashboardStatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.sublabel,
    required this.icon,
    this.onTap,
  });

  @override
  State<DashboardStatsCard> createState() => _DashboardStatsCardState();
}

class _DashboardStatsCardState extends State<DashboardStatsCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..translate(0.0, isHovered ? -3.0 : 0.0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovered 
                  ? const Color(0xFFC62828).withValues(alpha: 0.3) 
                  : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isHovered ? 0.08 : 0.03),
                blurRadius: isHovered ? 20 : 10,
                offset: Offset(0, isHovered ? 10 : 4),
              )
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.value,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                            ),
                            if (widget.sublabel.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(
                                widget.sublabel,
                                style: const TextStyle(
                                  color: Color(0xFFC62828),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isHovered 
                          ? const Color(0xFFC62828) 
                          : const Color(0xFFC62828).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: isHovered ? Colors.white : const Color(0xFFC62828),
                      size: 22,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}