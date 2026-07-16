import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/pages/vehicle_inspection_page.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/pages/banda_inspection_page.dart';
import '../widgets/dynamic_stats_row.dart';
import '../widgets/quick_actions_i.dart';
import '../widgets/table_inspector.dart';
import '../provider/inspection_providers.dart';

class InspectionPage extends ConsumerStatefulWidget {
  final List<StatsModel> stats;
  final List<dynamic> actions;

  const InspectionPage({super.key, required this.stats, required this.actions});

  @override
  ConsumerState<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends ConsumerState<InspectionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryRed = const Color(0xFFC62828);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(inspectionProvider.notifier).filterInspections("");
      }
      setState(() {});
    });

    Future.microtask(() => ref.read(inspectionProvider.notifier).loadInspections());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToForm(int index) {
    final pages = [const PrensaInspectionPage(),  VehicleInspectionPage(), const BandaInspectionPage()];
    Navigator.push(context, MaterialPageRoute(builder: (_) => pages[index]));
  }

@override
  Widget build(BuildContext context) {
    ref.listen(inspectionProvider.select((state) => state.errorMessage), (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: primaryRed),
        );
      }
    });

    final inspectionState = ref.watch(inspectionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(title: 'Inspecciones', actionIcon: Icons.print_rounded),
            const SizedBox(height: 32),
            DynamicStatsRow(stats: inspectionState.stats),
            const SizedBox(height: 48),
            const Text('Realizar Una Inspección', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
            const SizedBox(height: 24),
            _buildQuickActionGrid(),
            const SizedBox(height: 56),
            _buildInventoryStyleTableSection(inspectionState),
          ],
        ),
      ),
    );
  }
Widget _buildAnimatedActionItem(BoxConstraints constraints, String title, String desc, IconData icon, int index) {
    return StatefulBuilder(builder: (context, setInnerState) {
      bool isHovered = false;
      return MouseRegion(
        onEnter: (_) => setInnerState(() => isHovered = true),
        onExit: (_) => setInnerState(() => isHovered = false),
        child: AnimatedScale(
          scale: isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: constraints.maxWidth > 700 ? (constraints.maxWidth / 3) - 11 : constraints.maxWidth,
            child: QuickActionCard(
              title: title,
              description: desc,
              icon: icon,
              onTap: () => _navigateToForm(index),
            ),
          ),
        ),
      );
    });
  }
Widget _buildQuickActionGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildAnimatedActionItem(constraints, "Prensas", "Checklists", Icons.build, 0),
          _buildAnimatedActionItem(constraints, "Vehículos", "Flota", Icons.local_shipping, 1),
          _buildAnimatedActionItem(constraints, "Bandas", "Transporte", Icons.settings, 2),
        ],
      );
    });
  }

  Widget _buildActionItem(BoxConstraints constraints, String title, String desc, IconData icon, int index) {
    return SizedBox(
      width: constraints.maxWidth > 700 ? (constraints.maxWidth / 3) - 11 : constraints.maxWidth,
      child: QuickActionCard(
        title: title,
        description: desc,
        icon: icon,
        onTap: () => _navigateToForm(index),
      ),
    );
  }
Widget _buildInventoryStyleTableSection(inspectionState) {
    final items = inspectionState.filteredInspections ?? [];
    final filtered = items.where((item) {
      final type = item.reportType.toUpperCase();
      if (_tabController.index == 0) return type == 'PRESS';
      if (_tabController.index == 1) return type == 'VEHICLE';
      return type == 'CONVEYOR';
    }).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 5))
        ]
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mis inspecciones', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                SizedBox(
                  width: 320,
                  child: TextField(
                    onChanged: (val) => ref.read(inspectionProvider.notifier).filterInspections(val),
                    decoration: InputDecoration(
                      hintText: "Buscar registros...",
                      prefixIcon: Icon(Icons.search, color: primaryRed),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: primaryRed,
            labelColor: primaryRed,
            unselectedLabelColor: Colors.grey,
            tabs: const [Tab(text: 'PRENSAS'), Tab(text: 'VEHÍCULOS'), Tab(text: 'BANDAS')],
          ),
          const SizedBox(height: 10),
          (inspectionState.isLoading) 
            ? const SizedBox(height: 250, child: Center(child: CircularProgressIndicator(color: Color(0xFFC62828))))
            : TableInspector(items: filtered),
        ],
      ),
    );
  }
}