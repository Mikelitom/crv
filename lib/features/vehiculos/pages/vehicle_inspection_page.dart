import 'package:crv_reprosisa/features/prensas_industriales/widgets/prestamo_devolucion.dart';
import 'package:crv_reprosisa/features/vehiculos/models/inspection_vehicle_model.dart';
import 'package:flutter/material.dart';
import '../../prensas_industriales/widgets/capture_method_selector.dart';
import '../widgets/General_vehicle_info.dart';
import '../widgets/Vehicle_inspection_section.dart';
import '../../dashboard/presentation/widgets/header.dart';
class VehicleInspectionPage extends StatelessWidget {
  // Simulación de datos que vendrían de una Base de Datos/API
  final List<InspectionItemModel> motorItems = [
    InspectionItemModel(description: "CABLES DE BUJIAS"),
    InspectionItemModel(description: "NIVEL DE ANTICONGELANTE"),
    InspectionItemModel(description: "NIVEL DE LIQUIDO PARA FRENOS"),
  ];

  final List<InspectionItemModel> exteriorItems = [
    InspectionItemModel(description: "LUCES DELANTERAS"),
    InspectionItemModel(description: "ESTADO DE LLANTAS"),
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
            
            CaptureMethodSelector(onManualFill: () {}, onScan: () {}),
            const SizedBox(height: 24),
            
            const GeneralVehicleInfo(),
            const SizedBox(height: 24),
            
            // SECCIÓN MOTOR (Dinámica)
            VehicleInspectionSection(title: "MOTOR", items: motorItems),
            
            // SECCIÓN EXTERIOR (Dinámica)
            VehicleInspectionSection(title: "EXTERIOR", items: exteriorItems),
            
            // FOOTER DE ACCIONES (Préstamo / Firma / Guardar)
            const LoanAndInspectorSection(), // El que hicimos para Prensas es compatible aquí
          ],
        ),
      ),
    );
  }
}