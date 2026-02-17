import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';
import '../Widgets/dynamic_stats_row.dart';
import '../Widgets/quick_actions_i.dart';
import '../Widgets/table_inspector.dart';
import '../../dashboard/presentation/widgets/header.dart';

class InspectionPage extends StatelessWidget {
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
        child: Center(
          child: ConstrainedBox(
            // ANCHO UNIFICADO: 1600px para simetría total
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: 'Inspecciones', actionIcon: Icons.print_rounded),
                const SizedBox(height: 32),
                
                // Estadísticas (Conteo estilo Gestión de Usuarios)
                DynamicStatsRow(stats: stats),
                
                const SizedBox(height: 48),
                const Text('Realizar Una Inspección', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
                const SizedBox(height: 24),
                
                // Tarjetas de Acciones Rápidas
                _buildQuickActionGrid(),

                const SizedBox(height: 56),

                // --- ENCABEZADO INDEPENDIENTE (TÍTULO Y BUSCADOR FUERA) ---
                // Se eliminó el duplicado y se dejó solo uno con el buscador alineado
                _buildTableTopActions(),

                const SizedBox(height: 16),

                // --- CONTENEDOR DE TABLA (Abarca todo el ancho) ---
                // Siguiendo la estética de image_f43d45 y image_ea4478
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 12))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: TableInspector(
                      items: inspections,
                      onSearch: (v) => debugPrint("Buscando: $v"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableTopActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mis inspecciones', 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
        ),
        // Buscador independiente (Fuera de la tabla)
        SizedBox(
          width: 380,
          child: TextField(
            onChanged: (v) {},
            decoration: InputDecoration(
              hintText: "Buscar inspección...",
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        final columns = isMobile ? 1 : 3;
        final spacing = 24.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _buildActionItem(constraints.maxWidth, spacing, columns, "Inspección de Prensas", "Checklist de prensa industrial", Icons.build_circle_outlined),
            _buildActionItem(constraints.maxWidth, spacing, columns, "Inspección de Vehículos", "Checklist de flota vehicular", Icons.local_shipping_outlined),
            _buildActionItem(constraints.maxWidth, spacing, columns, "Inspección de Bandas", "Checklist de bandas transportadoras", Icons.camera_alt_outlined),
          ],
        );
      }
    );
  }

  Widget _buildActionItem(double maxWidth, double spacing, int columns, String title, String desc, IconData icon) {
    final itemWidth = (maxWidth - spacing * (columns - 1)) / columns;
    return SizedBox(
      width: itemWidth,
      child: QuickActionCard(
        title: title,
        description: desc,
        icon: icon,
        onTap: () {},
      ),
    );
  }
}