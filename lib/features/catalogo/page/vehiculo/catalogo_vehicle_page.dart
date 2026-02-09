import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/catalag_stats.dart';

class VehicleCatalogPage extends StatelessWidget {
  const VehicleCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(
              title: "Gestión de Vehículos",
              actionIcon: Icons.refresh_rounded,
            ),
            const SizedBox(height: 32),
            const CatalogStats(),
            const SizedBox(height: 40),

            // Contenedor de Tabla Adaptable
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 12))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchHeader(context),
                  _buildFullWidthTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 600;

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            const Text("Monitoreo de Unidades", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16, width: 16),
            // El buscador ahora se expande o tiene un ancho máximo responsivo
            Flexible(
              child: SizedBox(
                width: isMobile ? double.infinity : 350,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar unidad...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFullWidthTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1000), // Ancho mínimo para mantener legibilidad
        child: DataTable(
          horizontalMargin: 24,
          columnSpacing: 30,
          dataRowMaxHeight: 80,
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: const [
            DataColumn(label: Text('UNIDAD')),
            DataColumn(label: Text('ESTADO')),
            DataColumn(label: Text('RESPONSABLE')),
            DataColumn(label: Text('UBICACIÓN')),
            DataColumn(label: Text('SALIDA / REGRESO')),
            DataColumn(label: Text('ODÓMETRO')),
            DataColumn(label: Text('ACCIONES')),
          ],
          rows: [
            _buildRow("V-102", "Ford F-150", "En Uso", "Ing. Mario Casas", "Mina Sector 3", "08:00 AM - 06:00 PM", "45,200 km", true),
            _buildRow("V-105", "Toyota Hilux", "Disponible", "---", "Patio Principal", "---", "32,100 km", false),
            _buildRow("V-201", "Camión Mack", "Taller", "Mec. Luis Peña", "Taller Mecánico", "24/01 - 28/01", "88,400 km", true),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(String id, String model, String status, String user, String loc, String time, String km, bool alert) {
    return DataRow(cells: [
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alert) const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(model, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      )),
      DataCell(_buildStatusBadge(status)),
      DataCell(Text(user)),
      DataCell(Text(loc)),
      DataCell(Text(time, style: const TextStyle(fontSize: 12))),
      DataCell(Text(km)),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.history_rounded, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.map_outlined, color: Color(0xFFC62828)), onPressed: () {}),
        ],
      )),
    ]);
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == "Disponible" ? Colors.green : (status == "En Uso" ? Colors.blue : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}