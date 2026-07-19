import 'package:crv_reprosisa/features/servicios/domain/entities/asset_last_movement.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/last_move_providers.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/recent_movements_table.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/asset_distribution_chart.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/mainting_pending.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/usage_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/service_detail_view.dart';

class VehicleServicePage extends ConsumerStatefulWidget {
  const VehicleServicePage({super.key});

  @override
  ConsumerState<VehicleServicePage> createState() => _VehicleServicePageState();
}

class _VehicleServicePageState extends ConsumerState<VehicleServicePage> {
  Vehicle? selectedVehicle;
  String searchQuery = "";
  bool showList = false; // Control de visibilidad para móvil

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(vehicleListProvider.notifier).loadVehicles(),
    );
  }

  // --- MÉTODOS DE ESTILO ---
  Widget _buildPlateBadge(String plate) => Text(
    plate.toUpperCase(),
    style: const TextStyle(
      color: Color(0xFFC62828),
      fontWeight: FontWeight.w900,
      fontSize: 14,
    ),
  );
  Widget _buildVehicleAvatar(Vehicle vehicle) {
    if (vehicle.imageUrl != null && vehicle.imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: const Color(0xFFF4F7FA),
        backgroundImage: NetworkImage(vehicle.imageUrl!),
      );
    }

    return const CircleAvatar(
      radius: 24,
      backgroundColor: Color(0xFFF4F7FA),
      child: Icon(Icons.directions_car, color: Color(0xFFC62828), size: 20),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _translateStatus(status),
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return 'DISPONIBLE';
      case 'WORKSHOP':
        return 'TALLER';
      case 'OCCUPIED':
        return 'OCUPADO';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return Colors.green;
      case 'WORKSHOP':
        return Colors.orange;
      case 'OCCUPIED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleListProvider);
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final filtered = state.vehicles
        .where((v) => v.plate.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth <= 800
              ? FloatingActionButton(
                  backgroundColor: const Color(0xFFC62828),
                  onPressed: () => setState(() => showList = !showList),
                  child: const Icon(Icons.menu, color: Colors.white),
                )
              : const SizedBox.shrink();
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;
          return Stack(
            children: [
              // Dashboard al fondo
              Positioned(
                left: isWide ? 380 : 16,
                right: 16,
                top: 16,
                bottom: 16,
                child: selectedVehicle == null
                    ? _buildDashboard(
                      state.vehicles,
                      dashboardState.vehicleMovements,
                      dashboardState.isLoading
                    )
                    : ServiceDetailView(
                        key: ValueKey(selectedVehicle!.vehicleId),
                        vehicle: selectedVehicle!,
                      ),
              ),

              // Lista con el diseño original pero animada
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: isWide || showList ? 16 : -400,
                top: 16,
                bottom: 16,
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          onChanged: (v) => setState(() => searchQuery = v),
                          decoration: const InputDecoration(
                            hintText: "Buscar por placa...",
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFC62828),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF8F9FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const Divider(
                            height: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          // ... dentro de tu ListView.separated
                          itemBuilder: (_, i) => Material(
                            color: Colors.white, // Define el color de fondo aquí
                            child: ListTile(
                              leading: _buildVehicleAvatar(filtered[i]),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPlateBadge(filtered[i].plate),
                                  Text(
                                    "${filtered[i].brand} ${filtered[i].model}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing: _buildStatusBadge(filtered[i].operationState),
                              onTap: () => setState(() {
                                selectedVehicle = filtered[i];
                                if (!isWide) showList = false;
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

Widget _buildDashboard(
    List<Vehicle> vehicles,
    List<AssetLastMovement> movements,
    bool isLoading
  ) {
    // Calculamos las métricas basándonos en el estado de operación
    final occupiedCount = vehicles
        .where((v) => v.operationState.toUpperCase() == 'OCCUPIED')
        .length;
    final availableCount = vehicles
        .where((v) => v.operationState.toUpperCase() == 'AVAILABLE')
        .length;
    final workshopCount = vehicles
        .where((v) => v.operationState.toUpperCase() == 'WORKSHOP')
        .length;
    
    // Asumimos que los pendientes de mantenimiento son los que están en taller
    final pendingCount = workshopCount;
    // Puedes ajustar 'progressCount' si tienes una lógica distinta para órdenes en proceso
    final progressCount = 0; 

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        int crossAxisCount = maxWidth > 1200 ? 3 : (maxWidth > 700 ? 2 : 1);
        double cardWidth =
            (maxWidth - 32 - (16 * (crossAxisCount - 1))) / crossAxisCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildAnimatedCard(
                    AssetDistributionChart(
                      total: vehicles.length,
                      occupied: occupiedCount,
                      available: availableCount,
                      workshop: workshopCount,
                    ),
                    cardWidth,
                  ),
                  _buildAnimatedCard(const UsageTrendChart(), cardWidth),
                  // Mantenimiento actualizado con los parámetros requeridos
                  _buildAnimatedCard(
                    MaintenancePendingCard(
                      pendingCount: pendingCount,
                      progressCount: progressCount,
                      lastOrderNumber: "N/A", // O asigna el valor dinámico correspondiente
                      onNavigate: () {
                        // Agrega tu lógica de navegación aquí
                      },
                    ),
                    cardWidth,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RecentMovementsTable(
                movements: movements,
                searchQuery: searchQuery,
                isLoading: isLoading,
                identifierTitle: "PLACA",
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
}
