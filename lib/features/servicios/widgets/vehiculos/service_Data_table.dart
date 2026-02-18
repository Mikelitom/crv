import 'package:flutter/material.dart';
import '../../page/vehiculos/vehicle_history_page.dart';

class ServiceDataTable extends StatelessWidget {
  const ServiceDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centrado simétrico de 1600px para coherencia con el sistema
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ENCABEZADO INDEPENDIENTE (FUERA DEL CONTENEDOR) ---
            // Este bloque flota sobre el fondo gris, tal como en Monitoreo
           

            // --- CONTENEDOR EXCLUSIVO PARA LA TABLA ---
            // Solo contiene la estructura de datos, sin elementos externos
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _buildDataTable(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1200),
        child: DataTable(
          headingRowHeight: 64,
          dataRowMaxHeight: 80, 
          horizontalMargin: 24,
          columnSpacing: 40,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
          columns: _buildColumns(),
          rows: [
            _buildRow(context, "V-102", "Ford F-150", "Crítico", "Taller", "Falla Suspensión", "26/01", "30/01", Colors.red),
            _buildRow(context, "V-105", "Toyota Hilux", "Operativo", "Patio", "Mantenimiento", "27/01", "28/01", Colors.green),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    const labels = ['UNIDAD', 'ESTATUS', 'UBICACIÓN', 'MOTIVO', 'FECHAS', 'ACCIONES'];
    return labels.map((label) => DataColumn(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xFF454B4E),
          fontSize: 12,
          letterSpacing: 0.5
        ),
      ),
    )).toList();
  }

  DataRow _buildRow(BuildContext context, String id, String model, String status, String loc, String info, String start, String end, Color color) {
    return DataRow(cells: [
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
          Text(model, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      )),
      DataCell(_statusBadge(status, color)),
      DataCell(Text(loc, style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(info, style: const TextStyle(fontSize: 12, color: Color(0xFF454B4E)))),
      DataCell(Text("In: $start\nEst: $end", style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold))),
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded, color: Color(0xFFC62828), size: 22),
            onPressed: () {
              // Navegación corregida sin 'const' innecesario
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VehicleHistoryPage(vehicleId: id)),
              );
            },
          ),
        ],
      )),
    ]);
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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