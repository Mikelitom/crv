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
        child: Center(
          child: ConstrainedBox(
            // Ancho máximo unificado para todas las tablas del sistema
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(
                  title: "Gestión de Vehículos",
                  actionIcon: Icons.refresh_rounded,
                ),
                const SizedBox(height: 32),
                
                // Estadísticas superiores
                const CatalogStats(),
                const SizedBox(height: 48),

                // Título y Buscador (Fuera del contenedor de la tabla)
                _buildSectionHeader(),
                const SizedBox(height: 20),

                // Contenedor Unificado de Tabla
                _buildTableContainer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Encabezado de sección con buscador unificado
  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Monitoreo de Unidades", 
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w900, 
            color: Color(0xFF1A1C1E)
          )
        ),
        SizedBox(
          width: 350,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Buscar unidad o responsable...",
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), 
                borderSide: BorderSide(color: Colors.grey.shade200)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), 
                borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5)
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Contenedor con la estética premium del sistema
  Widget _buildTableContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), 
            blurRadius: 25, 
            offset: const Offset(0, 12)
          )
        ],
      ),
      child: _buildDataTable(context),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1200),
        child: DataTable(
          horizontalMargin: 24,
          columnSpacing: 40,
          dataRowMaxHeight: 80, // Altura para evitar overflow
          headingRowHeight: 64,
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: _buildColumns(),
          rows: [
            _buildRow("V-102", "Ford F-150", "En Uso", "Ing. Mario Casas", "Mina Sector 3", "08:00 AM", "06:00 PM", "12/02/2026", true),
            _buildRow("V-105", "Toyota Hilux", "Disponible", "---", "Patio Principal", "---", "---", "10/02/2026", false),
            _buildRow("V-201", "Camión Mack", "Taller", "Mec. Luis Peña", "Taller Mecánico", "24/01", "28/01", "01/02/2026", true),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    const labels = ['UNIDAD', 'ESTADO', 'RESPONSABLE', 'UBICACIÓN', 'SALIDA', 'REGRESO', 'FECHA CREACIÓN', 'ACCIONES'];
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

  DataRow _buildRow(String id, String model, String status, String user, String loc, String outT, String inT, String date, bool alert) {
    return DataRow(cells: [
      // Celda de Unidad con ID y Modelo
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alert) const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 12),
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
      DataCell(Text(user, style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(loc)),
      DataCell(Text(outT, style: const TextStyle(fontSize: 13, color: Colors.blueGrey))),
      DataCell(Text(inT, style: const TextStyle(fontSize: 13, color: Colors.blueGrey))),
      DataCell(Text(date, style: const TextStyle(fontSize: 13, color: Colors.grey))),
      // Acciones unificadas con iconos modernos
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Colors.blue, size: 22), 
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.grey, size: 20), 
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, color: Color(0xFFD32F2F), size: 20), 
            onPressed: () {},
          ),
        ],
      )),
    ]);
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == "Disponible" ? Colors.green : (status == "En Uso" ? Colors.blue : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}