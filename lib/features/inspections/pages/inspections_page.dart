import 'package:flutter/material.dart';
import '../Widgets/dynamic_stats_row.dart';
import '../Widgets/quick_actions_i.dart';
import '../Widgets/table_inspector.dart';
import '../../dashboard/presentation/widgets/header.dart';

class InspectionPage extends StatelessWidget {
  // Se deben declarar estas variables exactamente así para que el Dashboard no de error
  final List<dynamic> stats;
  final List<dynamic> actions;
  final List<dynamic> inspections;

  const InspectionPage({
    super.key,
    required this.stats,
    required this.actions,
    required this.inspections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(title: 'Inspecciones', actionIcon: Icons.print_rounded),
            const SizedBox(height: 32),
            
            // CONTEOS SEGUIDOS (Estilo Gestión de Usuarios)
            DynamicStatsRow(stats: stats),
            
            const SizedBox(height: 40),
            const Text('Realizar Una Inspección', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // TARJETAS SIN AMARILLO Y SIN TEXTOS DE EQUIPOS
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                QuickActionCard(
                  title: "Inspección de Prensas",
                  description: "Realizar checklist de prensa industrial",
                  icon: Icons.build_circle_outlined,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: "Inspección de Vehículos",
                  description: "Realizar checklist de flota vehicular",
                  icon: Icons.local_shipping_outlined,
                  onTap: () {},
                ),
                QuickActionCard(
                  title: "Inspección de Bandas",
                  description: "Realizar checklist de bandas transportadoras",
                  icon: Icons.camera_alt_outlined,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 48),
            const Text('Mis inspecciones', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar inspección...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  // Usamos la variable declarada arriba
                  TableInspector(
                    items: inspections,
                    onSearch: (v) => debugPrint("Buscando: $v"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}