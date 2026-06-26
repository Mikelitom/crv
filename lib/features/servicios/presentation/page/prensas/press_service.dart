import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:flutter/material.dart';
import '../../widgets/vehiculos/service_stats_grid.dart';

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
            CustomHeader(
              title: "Servicios de Prensas Industriales",
              actionIcon: Icons.precision_manufacturing_rounded,
              onActionTap: () {},
            ),
            
            const SizedBox(height: 32),
            
            const ServiceStatsGrid(isVehiculo: false), 
            
            const SizedBox(height: 40),
            
            const Text(
              "Monitoreo de Maquinaria", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            
            const SizedBox(height: 20),

            _buildSearchSection(),

            const SizedBox(height: 24),
            
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