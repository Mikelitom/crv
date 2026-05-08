import 'package:flutter/material.dart';

class ServiceStatsGrid extends StatelessWidget {
  final bool isVehiculo;
  const ServiceStatsGrid({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isMobile = constraints.maxWidth < 600;
      final double spacing = 12.0;
      final double cardWidth = isMobile 
          ? constraints.maxWidth 
          : (constraints.maxWidth - (spacing * 2)) / 3;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          _StatCard(
            label: "Servicios Totales",
            value: isVehiculo ? "42" : "18", // Datos estáticos
            icon: isVehiculo ? Icons.history_edu_rounded : Icons.precision_manufacturing_rounded,
            width: cardWidth,
          ),
          _StatCard(
            label: isVehiculo ? "En Taller" : "En Reparación",
            value: isVehiculo ? "5" : "2", // Datos estáticos
            icon: isVehiculo ? Icons.car_repair_outlined : Icons.handyman_outlined,
            width: cardWidth,
          ),
          _StatCard(
            label: "Finalizados",
            value: isVehiculo ? "37" : "16", // Datos estáticos
            icon: Icons.check_circle_outline_rounded,
            width: cardWidth,
          ),
        ],
      );
    });
  }
}

class _StatCard extends StatefulWidget {
  final String label, value;
  final IconData icon;
  final double width;

  const _StatCard({required this.label, required this.value, required this.icon, required this.width});

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
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: 100, 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(isHovered ? 0.05 : 0.02), blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(
                    widget.label, 
                    style: const TextStyle(color: Color(0xFFC62828), fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: isHovered ? Colors.white : const Color(0xFFC62828), size: 24),
            ),
          ],
        ),
      ),
    );
  }
}