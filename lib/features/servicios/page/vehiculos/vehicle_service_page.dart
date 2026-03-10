import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/service_stats_grid.dart';
import '../../widgets/vehiculos/service_Data_table.dart';



class VehicleServicePage extends StatelessWidget {
  const VehicleServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER EN SINTONÍA: Blanco con icono a la derecha
            CustomHeader(
              title: "Control de Servicios de Flota",
              actionIcon: Icons.car_repair_rounded,
              onActionTap: () {},
            ),
            
            const SizedBox(height: 32),
            
            // STATS GRANDES: 100px de altura para llenar la pantalla
            const ServiceStatsGrid(isVehiculo: true), 

            const SizedBox(height: 40),
            
            const Text(
              "Monitoreo de Unidades", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))
            ),
            const SizedBox(height: 20),

            // BUSCADOR PROPORCIONAL: 56px de alto para tablets
            _buildSearchField(),

            const SizedBox(height: 24),

            // TABLA DE DATOS: Sin 'const' para evitar errores de compilación
            ServiceDataTable(isVehiculo: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar unidad, placa o folio de servicio...",
          prefixIcon: const Icon(Icons.search, color: Color(0xFFC62828), size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}