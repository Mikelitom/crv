import 'package:flutter/material.dart';
import '../../page/vehiculos/vehicle_history_page.dart';

class ServiceDataTable extends StatelessWidget {
  const ServiceDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        // Ajuste de ancho mínimo para asegurar legibilidad en web y tablet
        constraints: const BoxConstraints(minWidth: 1000),
        child: DataTable(
          dataRowMaxHeight: 80,
          horizontalMargin: 20,
          columnSpacing: 25,
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: const [
            DataColumn(label: Text('UNIDAD')),
            DataColumn(label: Text('ESTATUS')),
            DataColumn(label: Text('UBICACIÓN')),
            DataColumn(label: Text('MOTIVO')),
            DataColumn(label: Text('FECHAS')),
            DataColumn(label: Text('ACCIONES')),
          ],
          rows: [
            _buildRow(context, "V-102", "Ford F-150", "Crítico", "Taller", "Falla Suspensión Delantera", "26/01", "30/01", Colors.red),
            _buildRow(context, "V-105", "Toyota Hilux", "Operativo", "Patio", "Mantenimiento Preventivo", "27/01", "28/01", Colors.green),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, String id, String model, String status, String loc, String info, String start, String end, Color color) {
    return DataRow(cells: [
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(model, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      )),
      DataCell(_statusBadge(status, color)),
      DataCell(Text(loc)),
      // FLEXIBILIDAD: Se envuelve en Flexible/SizedBox con ellipsis para evitar desbordamiento
      DataCell(
        SizedBox(
          width: 180, 
          child: Text(
            info, 
            style: const TextStyle(fontSize: 12), 
            overflow: TextOverflow.ellipsis, // Previene píxeles rojos de overflow
            maxLines: 2,
          )
        )
      ),
      DataCell(Text("In: $start\nEst: $end", style: const TextStyle(fontSize: 11))),
      DataCell(
        // Acción interactiva con efecto de hover
        IconButton(
          icon: const Icon(Icons.receipt_long_rounded, color: Color(0xFFC62828)),
          tooltip: 'Ver Historial',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VehicleHistoryPage(vehicleId: id)),
            );
          },
        ),
      ),
    ]);
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2))
      ),
      child: Text(
        text, 
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)
      ),
    );
  }
}