import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:intl/intl.dart'; // Importa esto para formatear fechas

class VehicleInfoCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleInfoCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    // Formateador de fechas
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattedDate = vehicle.checkoutDate != null 
        ? formatter.format(vehicle.checkoutDate!) 
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // COLUMNA IZQUIERDA: Info detallada
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${vehicle.brand} ${vehicle.model} - ${vehicle.plate}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _infoBadge(Icons.speed, "${vehicle.mileage} km"),
                    _infoBadge(Icons.calendar_today, "Última salida: $formattedDate"),
                    _infoBadge(Icons.person_outline, "Resp: ${vehicle.responsible}"),
                  ],
                ),
              ],
            ),
          ),
          
          // COLUMNA DERECHA: KPIs (Aquí podrías poner contadores reales cuando tengas el servicio de conteo)
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _kpiItem("3", "Hallazgos", Colors.red, Icons.warning_amber_rounded),
                _kpiItem("1", "Orden", Colors.orange, Icons.calendar_month),
                _kpiItem("5", "Servicios", Colors.blue, Icons.check_circle_outline),
                _kpiItem("12", "Inspecc.", Colors.green, Icons.fact_check_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiItem(String val, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              val,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}