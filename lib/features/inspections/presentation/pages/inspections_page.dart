import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/pages/banda_inspection_page.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/inspections/presentation/models/inspector_row_ui.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/dynamic_stats_row.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/quick_actions_i.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/table_inspector.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/pages/vehicle_inspection_page.dart';
import 'package:flutter/material.dart';

class InspectionPage extends StatefulWidget {
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
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  late List<InspectionRowUI> filteredInspections;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredInspections = widget.inspections;
  }

  void _filterInspections(String query) {
    setState(() {
      searchQuery = query;
      filteredInspections = widget.inspections
          .where((item) =>
              item.equipment.toLowerCase().contains(query.toLowerCase()) ||
              item.id.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
                  DynamicStatsRow(stats: widget.stats),
                  const SizedBox(height: 48),
                  const Text('Realizar Una Inspección',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
                  const SizedBox(height: 24),
                  _buildQuickActionGrid(context),
                  const SizedBox(height: 56),
                  
                  // Encabezado de tabla responsivo
                  _buildTableTopActions(),

                  const SizedBox(height: 16),

                  // Contenedor de la tabla
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
                      child: TableInspector(items: filteredInspections),
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

  Widget _buildTableTopActions() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 700) {
        // En móvil, ponemos el buscador debajo del título para que no choque
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mis inspecciones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
            const SizedBox(height: 16),
            _buildSearchField(double.infinity),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Mis inspecciones',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
          _buildSearchField(380),
        ],
      );
    });
  }

  Widget _buildSearchField(double width) {
    return SizedBox(
      width: width,
      child: TextField(
        onChanged: _filterInspections,
        decoration: InputDecoration(
          hintText: "Buscar por ID o equipo...",
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC62828)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5)),
        ),
      ),
    );
  }

  // ... (Mantiene tu _buildQuickActionGrid y _buildActionItem igual)
  Widget _buildQuickActionGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _buildActionItem(context, "Inspección de Prensas", "Administrar checklists industriales", Icons.build_circle_outlined,  PrensaInspectionPage())),
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
            _buildActionItem(context, "Inspección de Prensas", "Administrar checklists", Icons.build_circle_outlined,  PrensaInspectionPage()),
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
}