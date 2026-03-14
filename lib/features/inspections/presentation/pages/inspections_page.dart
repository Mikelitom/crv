import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';
import '../Widgets/dynamic_stats_row.dart';
import '../Widgets/quick_actions_i.dart';
import '../Widgets/table_inspector.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../../bandas_transportadoras/pages/banda_inspection_page.dart';
import '../../prensas_industriales/Pages/prensa_inspection.dart';
import '../../vehiculos/pages/vehicle_inspection_page.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: 'Inspecciones', actionIcon: Icons.print_rounded),
                  const SizedBox(height: 32),
                  
                  // Contadores animados seguidos
                  DynamicStatsRow(stats: stats),
                  
                  const SizedBox(height: 48),
                  const Text('Realizar Una Inspección', 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
                  const SizedBox(height: 24),
                  
                  // Grid responsivo forzado a fila única en PC
                  _buildQuickActionGrid(context),

                  const SizedBox(height: 56),

                  // Buscador y título de tabla
                  _buildTableTopActions(),

                  const SizedBox(height: 16),

                  // Tabla de inspecciones
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
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _buildActionItem(context, "Inspección de Prensas", "Administrar checklists industriales", Icons.build_circle_outlined, const PrensaInspectionPage())),
                const SizedBox(width: 24),
                Expanded(child: _buildActionItem(context, "Inspección de Vehículos", "Gestión de flota corporativa", Icons.local_shipping_outlined, VehicleInspectionPage())),
                const SizedBox(width: 24),
                Expanded(child: _buildActionItem(context, "Inspección de Bandas", "Control de sistemas de transporte", Icons.camera_alt_outlined, const BandaInspectionPage())),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildActionItem(context, "Inspección de Prensas", "Administrar checklists", Icons.build_circle_outlined, const PrensaInspectionPage()),
            const SizedBox(height: 16),
            _buildActionItem(context, "Inspección de Vehículos", "Gestión de flota", Icons.local_shipping_outlined, VehicleInspectionPage()),
            const SizedBox(height: 16),
            _buildActionItem(context, "Inspección de Bandas", "Control de transporte", Icons.camera_alt_outlined, const BandaInspectionPage()),
          ],
        );
      }
    );
  }

  Widget _buildActionItem(BuildContext context, String title, String desc, IconData icon, Widget target) {
    return QuickActionCard(
      title: title,
      description: desc,
      icon: icon,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
    );
  }

  Widget _buildTableTopActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Mis inspecciones', 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
        SizedBox(
          width: 380,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Buscar inspección...",
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC62828)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5)),
            ),
          ),
        ),
      ],
    );
  }
}