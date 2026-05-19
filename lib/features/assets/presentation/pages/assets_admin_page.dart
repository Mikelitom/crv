import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_vehicle_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_press_dialog.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

// Componentes modulares limpios
import '../widgets/catalog_stats_row.dart';
import '../widgets/catalog_data_table.dart';
import '../widgets/catalog_mobile_card.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class AssetsAdminPage extends ConsumerStatefulWidget {
  const AssetsAdminPage({super.key});

  @override
  ConsumerState<AssetsAdminPage> createState() => _AssetsAdminPageState();
}

class _AssetsAdminPageState extends ConsumerState<AssetsAdminPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final Color primaryRed = const Color(0xFFC62828); // Rojo Corporativo REPROSISA

  @override
  void initState() {
    super.initState();
    
    // Inicialización del TabController nativo para erradicar el LateInitializationError
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Sincroniza las tarjetas informativas de arriba según el Tab activo
      }
    });

    Future.microtask(() {
      ref.read(clientListProvider.notifier).loadClients();
      ref.read(vehicleListProvider.notifier).loadVehicles();
      ref.read(pressListProvider.notifier).loadPress();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToExpedienteDigital(dynamic item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Abriendo Expediente Digital del activo: ${item.id}"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientState = ref.watch(clientListProvider);
    final vehicleState = ref.watch(vehicleListProvider);
    
    // 🔥 SOLUCIÓN AL ERROR: Se cambió 'pressState' por 'pressListProvider' corrigiendo el conflicto de ámbito
    final pressState = ref.watch(pressListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                title: "Catálogo Operativo",
                actionIcon: Icons.analytics_rounded,
              ),
              const SizedBox(height: 24),

              // KPIs superiores dinámicos sin una sola gota de color azul
              CatalogStatsRow(
                activeTabIndex: _tabController.index,
                clientState: clientState,
                vehicleState: vehicleState,
                pressState: pressState,
              ),

              const SizedBox(height: 32),

              // Panel blanco de control de inventario
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 25,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Buscador a la izquierda y botón de alta a la derecha
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 380,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v), // Actualización reactiva del filtro
                              decoration: InputDecoration(
                                hintText: "Buscar registros...",
                                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                prefixIcon: Icon(Icons.search_rounded, color: primaryRed, size: 20),
                                filled: true,
                                fillColor: const Color(0xFFF3F4F6),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          _buildDynamicCreateButton(),
                        ],
                      ),
                    ),

                    // Orden de pestañas corporativas de REPROSISA
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: primaryRed,
                        unselectedLabelColor: const Color(0xFF6B7280),
                        indicatorColor: primaryRed,
                        indicatorWeight: 3.5,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.5),
                        dividerColor: const Color(0xFFE5E7EB),
                        tabs: const [
                          Tab(text: "CLIENTES"),
                          Tab(text: "VEHÍCULOS"),
                          Tab(text: "PRENSAS"),
                        ],
                      ),
                    ),

                    _buildTabContent(clientState, vehicleState, pressState),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(dynamic clients, dynamic vehicles, dynamic presses) {
    final constraints = BoxConstraints(maxWidth: MediaQuery.of(context).size.width);
    final bool isMobile = constraints.maxWidth < 900;

    // Inyección de la variable _searchQuery para solucionar el bug de filtrado
    switch (_tabController.index) {
      case 0: // CLIENTES
        return _buildViewLayer(clients.status, clients.clients, "cliente", isMobile, _searchQuery);
      case 1: // VEHÍCULOS
        return _buildViewLayer(vehicles.status, vehicles.vehicles, "vehiculo", isMobile, _searchQuery);
      default: // PRENSAS
        return _buildViewLayer(presses.status, presses.press, "prensa", isMobile, _searchQuery);
    }
  }

  Widget _buildViewLayer(Status status, List<dynamic> items, String type, bool isMobile, String query) {
    if (status == Status.loading) {
      return SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator(color: primaryRed)),
      );
    }

    // Filtrado seguro multi-campo en minúsculas
    final filtered = items.where((item) {
      final q = query.toLowerCase().trim();
      if (q.isEmpty) return true;

      if (type == "cliente") {
        final matchesName = (item.name?.toLowerCase() ?? "").contains(q);
        final matchesCompany = (item.company?.toLowerCase() ?? "").contains(q);
        final matchesRfc = item.toString().contains('rfc') && item.rfc != null 
            ? item.rfc.toLowerCase().contains(q) 
            : false;
        return matchesName || matchesCompany || matchesRfc;
      }
      
      if (type == "vehiculo") {
        final matchesPlate = (item.plate?.toLowerCase() ?? "").contains(q);
        final matchesBrand = (item.brand?.toLowerCase() ?? "").contains(q);
        final matchesModel = (item.model?.toLowerCase() ?? "").contains(q);
        return matchesPlate || matchesBrand || matchesModel;
      }
      
      // PRENSAS
      final matchesSerie = (item.serie?.toLowerCase() ?? "").contains(q);
      final matchesType = (item.type?.toLowerCase() ?? "").contains(q);
      final matchesModel = (item.model?.toLowerCase() ?? "").contains(q);
      return matchesSerie || matchesType || matchesModel;
    }).toList();

    if (filtered.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "No se encontraron registros bajo ese criterio", 
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)
          )
        ),
      );
    }

    if (!isMobile) {
      return CatalogDataTable(
        items: filtered,
        type: type,
        primaryRed: primaryRed,
        onDetailsPressed: _navigateToExpedienteDigital,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return CatalogMobileCard(
          item: filtered[index],
          type: type,
          primaryRed: primaryRed,
          onDetailsPressed: _navigateToExpedienteDigital,
        );
      },
    );
  }

  Widget _buildDynamicCreateButton() {
    String text = "";
    Widget dialog;

    if (_tabController.index == 0) {
      text = "Nuevo Cliente";
      dialog = const CreateClientDialog();
    } else if (_tabController.index == 1) {
      text = "Nuevo Vehículo";
      dialog = const CreateVehicleDialog();
    } else {
      text = "Nueva Prensa";
      dialog = const CreatePressDialog();
    }

    return ElevatedButton.icon(
      onPressed: () => showDialog(context: context, builder: (context) => dialog),
      icon: const Icon(Icons.add, size: 18),
      label: Text("+ $text", style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}