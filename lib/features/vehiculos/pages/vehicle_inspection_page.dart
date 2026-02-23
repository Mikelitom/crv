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
  // Definición de listas de inspección
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
            // HEADER CON FUNCIÓN DE REGRESO EN EL ICONO
            CustomHeader(
              title: "Inspección de Unidades Móviles", 
              actionIcon: Icons.directions_car, // Icono del coche
              onActionTap: () => Navigator.of(context).pop(), // Regresa al Dashboard
            ),
            
            const SizedBox(height: 24),
            
            // INFORMACIÓN GENERAL DEL VEHÍCULO
            const GeneralVehicleInfo(), 
            
            const SizedBox(height: 24),
            
            // SECCIÓN DE INSPECCIÓN TÉCNICA (MOTOR)
            VehicleInspectionSection(title: "MOTOR", items: motorItems),
            
            const SizedBox(height: 24),
            
            // SERVICIOS REQUERIDOS
            const VehicleServiceRequired(), 
            
            const SizedBox(height: 24),
            
            // FOOTER CON FIRMA DEL INSPECTOR Y ACCIONES
            _buildInspectorFooter(),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInspectorFooter() {
    return const InspectorAndActionsFooter();
  }
}