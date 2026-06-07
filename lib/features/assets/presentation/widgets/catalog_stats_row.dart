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
    int kpi1Value = 0;
    int kpi2Value = 0;
    String labelTotal = "";
    String labelKpi1 = "";
    String labelKpi2 = "";
    
    IconData iconTotal = Icons.analytics_rounded;
    IconData iconKpi1 = Icons.play_circle_fill_rounded;
    IconData iconKpi2 = Icons.build_circle_rounded;

    if (activeTabIndex == 0) { // --- CLIENTES ---
      final List clients = clientState.clients ?? [];
      total = clients.length;
      kpi1Value = clients.where((c) => c.isActive == true).length;
      kpi2Value = clients.where((c) => c.isActive == false).length;
      labelTotal = "Total de Clientes:";
      labelKpi1 = "Clientes Activos:";
      labelKpi2 = "Clientes Inactivos:";
      iconTotal = Icons.business_rounded;
      iconKpi1 = Icons.check_circle_rounded;
      iconKpi2 = Icons.cancel_rounded;
    } else if (activeTabIndex == 1) { // --- VEHÍCULOS ---
      final List vehicles = vehicleState.vehicles ?? [];
      total = vehicles.length;
      // Asumiendo que operationState es "DISPONIBLE" o "EN_MANTENIMIENTO"
      kpi1Value = vehicles.where((v) => (v.operationState ?? "").toUpperCase() == "DISPONIBLE").length;
      kpi2Value = vehicles.where((v) => (v.operationState ?? "").toUpperCase() == "EN_MANTENIMIENTO").length;
      labelTotal = "Total de Vehículos:";
      labelKpi1 = "En Operación:";
      labelKpi2 = "En Mantenimiento:";
      iconTotal = Icons.directions_car_rounded;
      iconKpi1 = Icons.trending_up_rounded;
      iconKpi2 = Icons.handyman_rounded;
    } else { // --- PRENSAS ---
      final List presses = pressState.press ?? [];
      total = presses.length;
      // Contamos según estado operativo
      kpi1Value = presses.where((p) => (p.operationState ?? "").toUpperCase() == "DISPONIBLE").length;
      kpi2Value = presses.where((p) => (p.operationState ?? "").toUpperCase() == "EN_MANTENIMIENTO").length;
      labelTotal = "Total de Prensas:";
      labelKpi1 = "Prensas Activas:";
      labelKpi2 = "En Mantenimiento:";
      iconTotal = Icons.precision_manufacturing_rounded;
      iconKpi1 = Icons.bolt_rounded;
      iconKpi2 = Icons.settings_suggest_rounded;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 750;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(labelTotal, total.toString(), iconTotal, const Color(0xFFC62828), isWide, constraints.maxWidth, isRedTheme: true),
            _buildStatCard(labelKpi1, kpi1Value.toString(), iconKpi1, const Color(0xFF2E7D32), isWide, constraints.maxWidth),
            _buildStatCard(labelKpi2, kpi2Value.toString(), iconKpi2, const Color(0xFFEF6C00), isWide, constraints.maxWidth),
          ],
        );
      },
    );
  }

  // --- El método _buildStatCard se mantiene igual ---
  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isWide, double maxWidth, {bool isRedTheme = false}) {
    return Container(
      width: isWide ? (maxWidth - 32) / 3 : maxWidth,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: isRedTheme ? const Color(0xFFC62828) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label, 
                style: TextStyle(
                  color: isRedTheme ? Colors.white.withOpacity(0.7) : const Color(0xFF6B7280), 
                  fontSize: 13, 
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 6),
              Text(
                value, 
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: isRedTheme ? Colors.white : const Color(0xFF111827)
                )
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isRedTheme ? Colors.white.withOpacity(0.18) : color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isRedTheme ? Colors.white : color, size: 26),
          ),
        ],
      ),
    );
  }
}