import 'package:flutter/material.dart';
import '../widgets/catalogo_stats.dart';

enum AssetType { vehiculo, prensa }

class GenericCatalogPage extends StatelessWidget {
  final AssetType type;

  const GenericCatalogPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Definición dinámica según el tipo
    final String title = type == AssetType.vehiculo ? "Gestión de Vehículos" : "Gestión de Prensas";
    final IconData actionIcon = type == AssetType.vehiculo ? Icons.directions_car_filled : Icons.precision_manufacturing;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Adaptable contra Right Overflow
              _buildResponsiveHeader(title, actionIcon),
              const SizedBox(height: 24),
              
              // Estadísticas (se adaptan internamente)
              const CatalogStats(), 

              const SizedBox(height: 32),
              
              // Buscador y Título de tabla responsivo
              _buildSearchSection(context),

              // Tabla de Datos Genérica
              _buildTableContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveHeader(String title, IconData icon) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(10)),
          child: IconButton(icon: Icon(icon, color: Colors.white, size: 20), onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type == AssetType.vehiculo ? "Monitoreo de Unidades" : "Monitoreo de Maquinaria",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: "Buscar en el catálogo...",
            prefixIcon: const Icon(Icons.search, color: Color(0xFFC62828)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTableContainer() {
    // Definición de columnas según el tipo
    final List<DataColumn> columns = type == AssetType.vehiculo 
      ? const [DataColumn(label: Text('UNIDAD')), DataColumn(label: Text('PLACA')), DataColumn(label: Text('ESTADO'))]
      : const [DataColumn(label: Text('PRENSA')), DataColumn(label: Text('SERIE')), DataColumn(label: Text('ESTADO'))];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text("Cargando catálogo...", style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}