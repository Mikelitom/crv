import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import '../models/inspector_row_ui.dart';
import '../widgets/dynamic_stats_row.dart';
import '../widgets/quick_actions_i.dart';
import '../widgets/table_inspector.dart';
import '../provider/inspection_providers.dart';

class InspectionPage extends ConsumerStatefulWidget {
  final List<StatsModel> stats;
  final List<dynamic> actions;

  const InspectionPage({
    super.key,
    required this.stats,
    required this.actions,
  });

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
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    Future.microtask(() => 
      ref.read(inspectionProvider.notifier).loadInspections()
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<InspectionRowUI> _getFilteredItemsByTab(List<InspectionRowUI> allItems) {
    return allItems.where((item) {
      final type = item.reportType.toUpperCase();
      switch (_tabController.index) {
        case 0: // PRENSAS
          return type == 'PRESS';
        case 1: // VEHÍCULOS
          return type == 'VEHICLE';
        case 2: // BANDAS
          return type == 'CONVEYOR';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final inspectionState = ref.watch(inspectionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: 'Inspecciones', actionIcon: Icons.print_rounded),
              const SizedBox(height: 32),
              
              DynamicStatsRow(stats: inspectionState.stats),
              
              const SizedBox(height: 48),
              const Text('Realizar Una Inspección',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
              const SizedBox(height: 24),
              _buildQuickActionGrid(),
              const SizedBox(height: 56),
              _buildInventoryStyleTableSection(inspectionState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryStyleTableSection(inspectionState) {
    final bool isDataLoading = inspectionState.isLoading ?? false;
    final searchFilteredItems = inspectionState.filteredInspections;
    final finalTabFilteredItems = _getFilteredItemsByTab(searchFilteredItems);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mis inspecciones', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                SizedBox(
                  width: 380,
                  child: TextField(
                    onChanged: (val) => ref.read(inspectionProvider.notifier).filterInspections(val),
                    decoration: InputDecoration(
                      hintText: "Buscar registros...",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search_rounded, color: primaryRed),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TabBar(
              controller: _tabController,
              indicatorColor: primaryRed,
              indicatorWeight: 3,
              labelColor: primaryRed,
              unselectedLabelColor: const Color(0xFF6B7280),
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.5),
              dividerColor: const Color(0xFFE5E7EB),
              tabs: const [
                Tab(text: 'PRENSAS'),
                Tab(text: 'VEHÍCULOS'),
                Tab(text: 'BANDAS'),
              ],
            ),
          ),

          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            child: isDataLoading 
                ? const SizedBox(height: 250, child: Center(child: CircularProgressIndicator(color: Color(0xFFC62828))))
                : TableInspector(items: finalTabFilteredItems), 
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionGrid() {
    return Row(
      children: [
        Expanded(child: QuickActionCard(title: "Prensas", description: "Checklists", icon: Icons.build, onTap: () => _tabController.animateTo(0))),
        const SizedBox(width: 16),
        Expanded(child: QuickActionCard(title: "Vehículos", description: "Flota", icon: Icons.local_shipping, onTap: () => _tabController.animateTo(1))),
        const SizedBox(width: 16),
        Expanded(child: QuickActionCard(title: "Bandas", description: "Transporte", icon: Icons.settings, onTap: () => _tabController.animateTo(2))),
      ],
    );
  }
}