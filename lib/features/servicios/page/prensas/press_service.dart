import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart'; // Ajusta según tu header
import '../../widgets/vehiculos/service_stats_grid.dart';
import '../../widgets/vehiculos/service_Data_table.dart';

class PressServicePage extends StatelessWidget {
  const PressServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header estilo blanco con icono a la derecha
            CustomHeader(
              title: "Servicios de Prensas Industriales",
              actionIcon: Icons.precision_manufacturing_rounded,
              onActionTap: () {},
            ),
            
            const SizedBox(height: 32),
            
            // Stats de tamaño grande (100px)
            const ServiceStatsGrid(isVehiculo: false), 
            
            const SizedBox(height: 40),
            
            const Text(
              "Monitoreo de Maquinaria", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            
            const SizedBox(height: 20),

            // Buscador proporcional para llenar el espacio
            _buildSearchSection(),

            const SizedBox(height: 24),

            // LA TABLA (Sin 'const' para que no de error)
            ServiceDataTable(isVehiculo: false), 
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar por prensa o folio de servicio...",
          prefixIcon: Icon(Icons.search, color: Color(0xFFC62828), size: 24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}