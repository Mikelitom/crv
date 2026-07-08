import 'package:flutter/material.dart';

class CatalogStatsRow extends StatelessWidget {
  final int activeTabIndex;
  final dynamic clientState;
  final dynamic vehicleState;
  final dynamic pressState;

  const CatalogStatsRow({
    super.key,
    required this.activeTabIndex,
    required this.clientState,
    required this.vehicleState,
    required this.pressState,
  });

  @override
  Widget build(BuildContext context) {
    int total = 0;
    int kpi1 = 0; // Disponible
    int kpi2 = 0; // Taller
    int kpi3 = 0; // Ocupado
    
    String labelTotal = "Total";
    String labelKpi1 = "Disponible";
    String labelKpi2 = "Taller";
    String labelKpi3 = "Ocupado";
    
    IconData iconTotal = Icons.analytics_rounded;
    IconData iconKpi1 = Icons.check_circle_rounded;
    IconData iconKpi2 = Icons.build_rounded;
    IconData iconKpi3 = Icons.lock_rounded;

    // --- LÓGICA DE DATOS ---
    if (activeTabIndex == 0) { // --- CLIENTES (3 tarjetas) ---
      final List clients = clientState.clients ?? [];
      total = clients.length;
      kpi1 = clients.where((c) => c.isActive == true).length;
      kpi2 = clients.where((c) => c.isActive == false).length;
      labelTotal = "Total Clientes";
      labelKpi1 = "Activos";
      labelKpi2 = "Inactivos";
      iconTotal = Icons.business_rounded;
      iconKpi1 = Icons.check_circle_rounded;
      iconKpi2 = Icons.cancel_rounded;
    } else { // --- VEHÍCULOS (1) Y PRENSAS (2) (4 tarjetas) ---
      final List items = (activeTabIndex == 1) ? (vehicleState.vehicles ?? []) : (pressState.press ?? []);
      total = items.length;
      
      // Filtros basados en los estados estándar
      kpi1 = items.where((i) => (i.operationState ?? "").toUpperCase() == "DISPONIBLE" || (i.operationState ?? "").toUpperCase() == "AVAILABLE").length;
      kpi2 = items.where((i) => (i.operationState ?? "").toUpperCase() == "TALLER" || (i.operationState ?? "").toUpperCase() == "WORKSHOP").length;
      kpi3 = items.where((i) => (i.operationState ?? "").toUpperCase() == "OCUPADO" || (i.operationState ?? "").toUpperCase() == "OCCUPIED").length;
      
      labelTotal = activeTabIndex == 1 ? "Total Vehículos" : "Total Prensas";
      iconTotal = activeTabIndex == 1 ? Icons.directions_car_rounded : Icons.precision_manufacturing_rounded;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final int count = (activeTabIndex == 0) ? 3 : 4;
        final double spacing = 16.0;
        final double cardWidth = (constraints.maxWidth - (spacing * (count - 1))) / count;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _StatCard(label: labelTotal, value: total.toString(), icon: iconTotal, color: const Color(0xFFC62828), width: cardWidth, isRedTheme: true),
            _StatCard(label: labelKpi1, value: kpi1.toString(), icon: iconKpi1, color: Colors.green, width: cardWidth),
            _StatCard(label: labelKpi2, value: kpi2.toString(), icon: iconKpi2, color: Colors.blue, width: cardWidth),
            if (activeTabIndex != 0)
              _StatCard(label: labelKpi3, value: kpi3.toString(), icon: iconKpi3, color: Colors.orange, width: cardWidth),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final double width;
  final bool isRedTheme;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.width, this.isRedTheme = false});

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
        width: widget.width < 200 ? double.infinity : widget.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.isRedTheme ? (isHovered ? const Color(0xFFB71C1C) : const Color(0xFFC62828)) : (isHovered ? Colors.grey.shade50 : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: !widget.isRedTheme ? Border.all(color: Colors.black.withOpacity(0.06)) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.08 : 0.03),
              blurRadius: isHovered ? 15 : 8,
              offset: Offset(0, isHovered ? 6 : 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label, style: TextStyle(color: widget.isRedTheme ? Colors.white70 : Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold)),
                Icon(widget.icon, color: widget.isRedTheme ? Colors.white : widget.color, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: widget.isRedTheme ? Colors.white : Colors.black87)),
          ],
        ),
      ),
    );
  }
}