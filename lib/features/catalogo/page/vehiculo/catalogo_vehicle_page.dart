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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header responsivo para evitar Right Overflow
                  _buildHeader("Gestión de Vehículos"),
                  const SizedBox(height: 32),
                  
                  // Estadísticas adaptables
                  const CatalogStats(),
                  const SizedBox(height: 48),

                  const Text(
                    "Monitoreo de Unidades", 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))
                  ),
                  const SizedBox(height: 20),

                  // Buscador de ancho completo
                  _buildSearchBar(),
                  const SizedBox(height: 24),

                  _buildTableContainer(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFD32F2F), borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar unidad o responsable...",
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildTableContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 12))
        ],
      ),
      child: _buildDataTable(),
    );
  }

  Widget _buildDataTable() {
    // Lista vacía para evitar RangeError
    final List<dynamic> vehicles = [];

    if (vehicles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.directions_car_filled_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("No hay unidades registradas", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('UNIDAD')),
          DataColumn(label: Text('ESTADO')),
          DataColumn(label: Text('ACCIONES')),
        ],
        rows: const [],
      ),
    );
  }
}