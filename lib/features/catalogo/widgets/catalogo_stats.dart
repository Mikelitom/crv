import 'package:flutter/material.dart';

class CatalogStats extends StatelessWidget {
  final bool isVehiculo;
  const CatalogStats({super.key, required this.isVehiculo});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Determinamos el número de columnas (3 para desktop/tablet)
      int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20, // Más espacio entre tarjetas para que no se vean pegadas
          mainAxisSpacing: 20,
          // ALTURA CORREGIDA: 100px para que se vean grandes como en Usuarios
          mainAxisExtent: 100, 
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          final labels = isVehiculo 
            ? ["Total Vehículos", "En Operación", "En Taller"]
            : ["Total Prensas", "Activas", "Mantenimiento"];
            
          final icons = isVehiculo
            ? [Icons.inventory_2_outlined, Icons.local_shipping_outlined, Icons.build_circle_outlined]
            : [Icons.precision_manufacturing, Icons.settings_suggest, Icons.handyman_outlined];

          return _StatCard(label: labels[index], value: "0", icon: icons[index]);
        },
      );
    });
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

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
        padding: const EdgeInsets.symmetric(horizontal: 24), // Más aire interno
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Bordes más redondeados como la foto
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.06 : 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 32, // Texto grande y legible
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF1A1C1E)
                  ),
                ),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 16, 16, 16), 
                    fontSize: 14, // Label más claro
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            // ICONO GRANDE Y SINTONIZADO
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHovered ? const Color(0xFFC62828) : const Color(0xFFFDECEA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: isHovered ? Colors.white : const Color(0xFFC62828),
                size: 28, // Icono mucho más grande
              ),
            ),
          ],
        ),
      ),
    );
  }
}