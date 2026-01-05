import 'package:flutter/material.dart';
import '..//Models/prensa_inspection_model.dart';
import '..//widgets/information_general_equipo.dart';
import '../widgets/prestamo_devolucion.dart';
import '..//widgets/table_componentes_vehiculo.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../../vehiculos/widgets/Capture_metho_selector.dart';
class PrensaInspectionPage extends StatelessWidget {
  const PrensaInspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de lista que vendría de tu Base de Datos
    final List<PrensaComponentItem> dataFromDB = [
      PrensaComponentItem(unidad: "ML", descripcion: "NIVELES DE ACEITE"),
      PrensaComponentItem(unidad: "PZA", descripcion: "MANOMETRO EN CERO"),
      PrensaComponentItem(unidad: "PZA", descripcion: "PRENSA EN MODO MANUAL"),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CustomHeader(title: "Inspección de Prensas Industriales", actionIcon: Icons.build),
            const SizedBox(height: 20),
            CaptureMethodSelector(onManualFill: () {}, onScan: () {}),
            const SizedBox(height: 24),
            const GeneralEquipmentInfo(equipmentData: {}),
            const SizedBox(height: 24),
            PrensaInspectionTable(items: dataFromDB), // Aquí pasas la lista dinámica
            const SizedBox(height: 24),
            const LoanAndInspectorSection(),
          ],
        ),
      ),
    );
  }
}