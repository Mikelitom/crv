import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';
import '../Widgets/dynamic_stats_row.dart';
import '../Widgets/quick_actions_i.dart';
import '../Widgets/table_inspector.dart';
import '../../dashboard/presentation/widgets/header.dart';

class InspectionPage extends StatelessWidget {
  // Se deben declarar estas variables exactamente así para que el Dashboard no de error
  final List<StatsModel> stats;
  final List<dynamic> actions;
  final List<InspectionRowUI> inspections;

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
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;
                final columns = isMobile ? 1 : 3;
                final spacing = 20.0;

                final itemWidth =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final card in [
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
                    ])
                      SizedBox(width: itemWidth, child: card),
                  ],
                );
              }
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