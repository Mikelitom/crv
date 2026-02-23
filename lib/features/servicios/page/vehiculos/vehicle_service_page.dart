import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/service_stats_grid.dart';
import 'package:crv_reprosisa/features/servicios/widgets/vehiculos/service_Data_table.dart';

class VehicleServicesPage extends StatelessWidget {
  const VehicleServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header adaptable para evitar Right Overflow
              _buildResponsiveHeader("Centro de Control de Servicios"),
              const SizedBox(height: 24),
              
              const ServiceStatsGrid(), // Corregido internamente contra Bottom Overflow

              const SizedBox(height: 32),
              
              // Buscador inteligente
              _buildSearchSection(context),

              const ServiceDataTable(), // Tabla limpia sin datos estáticos
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveHeader(String title) {
    return Row(
      children: [
        Expanded( // Expanded obliga al texto a no empujar el icono fuera
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(10)),
          child: IconButton(icon: const Icon(Icons.add_business, color: Colors.white, size: 20), onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 600;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monitoreo de Servicios", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField( // Siempre ocupa el ancho disponible en móvil
            decoration: InputDecoration(
              hintText: "Buscar servicio...",
              prefixIcon: const Icon(Icons.search, color: Color(0xFFC62828)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    });
  }
}