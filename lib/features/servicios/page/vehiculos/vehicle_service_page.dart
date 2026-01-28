import 'package:crv_reprosisa/features/servicios/widgets/vehiculos/service_Data_table.dart';
import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../widgets/vehiculos/service_stats_grid.dart';


class VehicleServicesPage extends StatelessWidget {
  const VehicleServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CustomHeader(
              title: "Centro de Control de Servicios",
              actionIcon: Icons.add_business_rounded,
            ),
            const SizedBox(height: 32),
            
            // Widget separado para las estadísticas superiores
            const ServiceStatsGrid(),

            const SizedBox(height: 40),

            // Contenedor de la tabla de ancho completo
            Container(
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
              child: const Column(
                children: [
                  // Widget separado para la tabla de datos
                  ServiceDataTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}