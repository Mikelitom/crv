import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/service_stats_grid.dart';
import '../../widgets/vehiculos/service_Data_table.dart';

class VehicleServicePage extends StatelessWidget {
  const VehicleServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA), // Color más limpio
      body: LayoutBuilder(
        builder: (context, constraints) {
          double horizontalPadding = constraints.maxWidth > 600 ? 32 : 16;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(
                  title: "Control de Flota Operativa",
                  actionIcon: Icons.car_repair_rounded,
                  onActionTap: () {},
                ),
                
                const SizedBox(height: 32),
                
                // KPIs Operativos: Totales, Alertas, Próximos, Taller
                const ServiceStatsGrid(isVehiculo: true), 

                const SizedBox(height: 40),
                
                const Text(
                  "Monitoreo de Unidades", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))
                ),
                const SizedBox(height: 20),

                _buildSearchField(),

                const SizedBox(height: 24),

                // Tabla con lógica de estados (Crítico, Atención, Normal)
                const ServiceDataTable(isVehiculo: true),
              ],
            ),
          );
        }
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
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar unidad, placa o estado...",
          prefixIcon: Icon(Icons.search, color: Color(0xFFC62828), size: 24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}