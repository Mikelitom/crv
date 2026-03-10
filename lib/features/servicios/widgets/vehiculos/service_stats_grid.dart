import 'package:flutter/material.dart';

class ServiceStatsGrid extends StatelessWidget {
  final bool isVehiculo;
  const ServiceStatsGrid({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Cálculo para que las 3 tarjetas ocupen todo el ancho sin huecos blancos
      final double cardWidth = (constraints.maxWidth - 24) / 3;

      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _StatCard(
            label: "Servicios Totales",
            value: "0",
            icon: isVehiculo ? Icons.history_edu_rounded : Icons.precision_manufacturing_rounded,
            width: cardWidth,
          ),
          _StatCard(
            label: isVehiculo ? "En Taller" : "En Reparación",
            value: "0",
            icon: isVehiculo ? Icons.car_repair_outlined : Icons.handyman_outlined,
            width: cardWidth,
          ),
          _StatCard(
            label: "Finalizados",
            value: "0",
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
        height: 100, // ALTURA GRANDE: Como en Gestión de Usuarios
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(isHovered ? 0.05 : 0.02), blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                Text(widget.label, style: const TextStyle(color: Color(0xFFC62828), fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            // Icono sintonizado a la derecha con animación focalizada
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: isHovered ? Colors.white : const Color(0xFFC62828), size: 28),
            ),
          ],
        ),
      ),
    );
  }
}