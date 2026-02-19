import 'package:crv_reprosisa/features/prensas_industriales/widgets/prestamo_devolucion.dart';
import 'package:crv_reprosisa/features/vehiculos/models/inspection_vehicle_model.dart';
import 'package:flutter/material.dart';
import '../../prensas_industriales/widgets/capture_method_selector.dart';
import '../widgets/General_vehicle_info.dart';
import '../widgets/Vehicle_inspection_section.dart';
import '../widgets/Service_Vehicle_required.dart';
import '../widgets/Inspector.dart';
import '../../dashboard/presentation/widgets/header.dart';
class VehicleInspectionPage extends StatelessWidget {
  // Define tus listas aquí
  final List<InspectionItemModel> motorItems = [
    InspectionItemModel(description: "Cables de Bujias"),
    InspectionItemModel(description: "Nivel de Anticongelante"),
    InspectionItemModel(description: "Nivel de Liquidos Para Frenos"),
  ];

  VehicleInspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CustomHeader(title: "Inspección de Unidades Móviles", actionIcon: Icons.directions_car),
            const SizedBox(height: 24),
            const GeneralVehicleInfo(), 
            const SizedBox(height: 24),
            // QUITA EL 'CONST' DE AQUÍ PARA SOLUCIONAR EL ERROR
            VehicleInspectionSection(title: "MOTOR", items: motorItems),
            const SizedBox(height: 24),
            const VehicleServiceRequired(), 
            const SizedBox(height: 24),
            _buildInspectorFooter(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInspectorFooter() {
    return const InspectorAndActionsFooter(); // Tu widget de inspector
  }
}