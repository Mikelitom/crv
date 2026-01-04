import 'package:flutter/material.dart';
import '../widgets/Capture_metho_selector.dart';
import '../widgets/General_vehicle_info.dart';
import '../widgets/Vehicle_inspection_section.dart';
import '../../dashboard/presentation/widgets/header.dart';
class VehicleInspectionPage extends StatelessWidget {
  const VehicleInspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Reutilizado
            const CustomHeader(title: "Inspección de Unidades Móviles", actionIcon: Icons.build),
            
            const SizedBox(height: 24),
            CaptureMethodSelector(onManualFill: () {}, onScan: () {}),
            
            const SizedBox(height: 24),
            const GeneralVehicleInfo(),
            
            const SizedBox(height: 24),
            // SECCIÓN 1: MOTOR
            VehicleInspectionSection(
              title: "MOTOR",
              items: [
                VehicleInspectionItem(description: "CABLES DE BUJIAS"),
                VehicleInspectionItem(description: "NIVEL DE ANTICONGELANTE"),
                VehicleInspectionItem(description: "NIVEL DE LIQUIDO PARA FRENOS"),
              ],
            ),
            
            const SizedBox(height: 24),
            // SECCIÓN 2: EXTERIOR (Ejemplo de reutilización)
            VehicleInspectionSection(
              title: "EXTERIOR",
              items: [
                VehicleInspectionItem(description: "LUCES DELANTERAS"),
                VehicleInspectionItem(description: "ESTADO DE LLANTAS"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}