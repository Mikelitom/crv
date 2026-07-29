import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/asset_last_movement.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/last_move_providers.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_usage_provider.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/pending_maintenance.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_distribution_chart.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_usage_trend_chart.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_service_detail_view.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/recent_movements_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressServicePage extends ConsumerStatefulWidget {
  const PressServicePage({super.key});

  @override
  ConsumerState<PressServicePage> createState() => _PressServicePageState();
}

class _PressServicePageState extends ConsumerState<PressServicePage> {
  Press? selectedPress;
  bool showList = false; // Control para móvil
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pressListProvider.notifier).loadPress());
  }

  void _onPressSelected(Press p, bool isWide) {
    setState(() {
      selectedPress = p;
      if (!isWide) showList = false;
    });

    // Forzamos la carga inmediata de los datos y órdenes de la prensa seleccionada
    ref.read(pressItemNotifierProvider.notifier).loadPendingItems(p.id);
    ref.read(pressIncidenceNotifierProvider.notifier).loadIncidences(p.id);
    ref.read(pressServiceOrderNotifierProvider.notifier).loadOrders(p.id);
    ref.read(pressHistoryProvider.notifier).loadHistory(p.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pressListProvider);
    final usageData = ref.watch(pressUsageProvider);
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final filteredPress = state.press
        .where(
          (p) =>
              p.serie.toLowerCase().contains(searchQuery.toLowerCase()) ||
              p.model.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth <= 1000
              ? FloatingActionButton(
                  backgroundColor: const Color(0xFFC62828),
                  onPressed: () => setState(() => showList = !showList),
                  child: Icon(
                    showList ? Icons.close : Icons.list,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 1000;
          return Stack(
            children: [
              // CONTENIDO PRINCIPAL
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: isWide ? 380 : 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: selectedPress == null
                      ? _buildDashboard(
                          usageData,
                          filteredPress,
                          dashboardState.pressMovements,
                          dashboardState.isLoading, 
                          isWide,
                        )
                      : PressServiceDetailView(
                          key: ValueKey(selectedPress!.id),
                          press: selectedPress!,
                        ),
                ),
              ),

              // PANEL LATERAL (Lista de Prensas con diseño flotante y separado)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: isWide || showList ? 0 : -400,
                top: 0,
                bottom: 0,
                child: _buildSidePanel(filteredPress, state.status, isWide),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboard(
    AsyncValue usageData,
    List<Press> filteredPress,
    List<AssetLastMovement> movements,
    bool isLoading,
    bool isWide,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        int crossAxisCount = maxWidth > 1200 ? 3 : (maxWidth > 700 ? 2 : 1);
        double cardWidth = (maxWidth - 32 - (16 * (crossAxisCount - 1))) / crossAxisCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dashboard de Prensas",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildAnimatedCard(const PressDistributionChart(), cardWidth),
                  _buildAnimatedCard(
                    usageData.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Text("Error: $err"),
                      data: (data) => PressUsageTrendChart(data: data),
                    ),
                    cardWidth,
                  ),
                  _buildAnimatedCard(
                    PendingMaintenanceWidget(
                      onNavigateToPress: (pressId) {
                        final state = ref.read(pressListProvider);
                        final press = state.press.firstWhere((p) => p.id == pressId);
                        _onPressSelected(press, isWide);
                      },
                    ),
                    cardWidth,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RecentMovementsTable(
                movements: movements,
                searchQuery: searchQuery,
                isLoading: isLoading,
                identifierTitle: "SERIE",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard(Widget child, double width) {
    return StatefulBuilder(
      builder: (context, setSt) {
        return MouseRegion(
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: width > 360 ? width : 360,
              height: 380,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidePanel(
    List<Press> filteredPress,
    Status status,
    bool isWide,
  ) {
    return Container(
      width: 360,
      margin: const EdgeInsets.all(16), // Separación idéntica al diseño de vehículos
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: const InputDecoration(
                hintText: "Buscar por serie o modelo...",
                prefixIcon: Icon(Icons.search, color: Color(0xFFC62828)),
                filled: true,
                fillColor: Color(0xFFF4F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: status == Status.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filteredPress.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (_, i) =>
                        _buildPressTile(filteredPress[i], isWide),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPressTile(Press p, bool isWide) {
    // Traducción y colores dinámicos para los estados de la prensa
    String rawState = p.operationState.toUpperCase();
    String translatedState = "DISPONIBLE";
    Color statusColor = Colors.green;

    if (rawState.contains("LOANED") || rawState.contains("USO") || rawState.contains("EN PRÉSTAMO")) {
      translatedState = "PRESTADA";
      statusColor = Colors.orange;
    } else if (rawState.contains("MANTENIMIENTO")) {
      translatedState = "EN SERVICIO";
      statusColor = Colors.red;
    } else if (rawState.contains("AVAILABLE") || rawState.contains("DISPONIBLE")) {
      translatedState = "DISPONIBLE";
      statusColor = Colors.green;
    } else {
      translatedState = p.operationState;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _onPressSelected(p, isWide), // <-- Conectado aquí correctamente
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFC62828).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.precision_manufacturing, color: Color(0xFFC62828), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.serie,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.model,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  translatedState,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}