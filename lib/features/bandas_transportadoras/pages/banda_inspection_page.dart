import 'package:flutter/material.dart';
import '../model/banda_inspection_model.dart';
import '../widgets/banda_section_table.dart';
import '../../dashboard/presentation/widgets/header.dart';
class BandaInspectionPage extends StatelessWidget {
  const BandaInspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header reutilizado
            const CustomHeader(title: "Inspección de Bandas Transportadoras", actionIcon: Icons.build),
            
            const SizedBox(height: 24),
            const Text("Secciones de Inspección Técnica", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("Evaluación detallada de cada componente del sistema transportador", 
              style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 32),

            // SECCIÓN 1: COLA (Dinámica)
            BandaSectionTable(
              sectionNumber: 1,
              sectionTitle: "Cola",
              items: [
                BandaComponentItem(accessory: "Banda en la Polea", observationOptions: ["a) Alineada", "b) Desalineada"]),
                BandaComponentItem(accessory: "Raspador de Retorno", observationOptions: ["a) Hay", "b) No hay", "c) Raspa", "d) No raspa"]),
                BandaComponentItem(accessory: "Hule Raspador", observationOptions: ["a) Bueno", "b) Cambiar", "c) Ajustar"]),
              ],
            ),

            // SECCIÓN 2: CARGA (Reutilización dinámica)
            BandaSectionTable(
              sectionNumber: 2,
              sectionTitle: "Zona de Carga",
              items: [
                BandaComponentItem(accessory: "Camas de Impacto", observationOptions: ["a) Bueno", "b) Desgastado"]),
                BandaComponentItem(accessory: "Guías de Carga", observationOptions: ["a) Alineadas", "b) Sueltas"]),
              ],
            ),

            // ... Repetir para las secciones 3, 4 y 5

            // Botón de Siguiente (Footer)
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text("Siguiente"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}