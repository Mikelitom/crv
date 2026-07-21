import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Providers
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
// Dialogs
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/update_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_vehicle_dialog.dart';
import '../dialogs/update_vehicle_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/update_press_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_press_dialog.dart';
// UI Components
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import '../widgets/catalog_stats_row.dart';
import '../widgets/catalog_data_table.dart';

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

class _AssetsAdminPageState extends ConsumerState<AssetsAdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  // Filtros de estado separados para cada sección
  String _clientStatusFilter = "TODOS";
  String _vehicleStatusFilter = "TODOS";
  String _pressStatusFilter = "TODOS";

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

  String get _currentFilter {
    switch (_tabController.index) {
      case 0:
        return _clientStatusFilter;
      case 1:
        return _vehicleStatusFilter;
      case 2:
        return _pressStatusFilter;
      default:
        return "TODOS";
    }
  }

  void _setCurrentFilter(String val) {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _clientStatusFilter = val;
          break;
        case 1:
          _vehicleStatusFilter = val;
          break;
        case 2:
          _pressStatusFilter = val;
          break;
      }
    });
  }

  List<String> _getAvailableFilters() {
    switch (_tabController.index) {
      case 0:
        return ["TODOS", "ACTIVO", "INACTIVO"];
      case 1:
      case 2:
        return ["TODOS", "DISPONIBLE", "TALLER", "OCUPADO", "MANTENIMIENTO", "LOANED"];
      default:
        return ["TODOS"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientState = ref.watch(clientListProvider);
    final vehicleState = ref.watch(vehicleListProvider);
    final pressState = ref.watch(pressListProvider);
    final filters = _getAvailableFilters();
    final activeFilter = _currentFilter;

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
                  title: "Catálogo Operativo", actionIcon: Icons.analytics_rounded),
              const SizedBox(height: 24),
              
              // Contadores funcionales
              CatalogStatsRow(
                activeTabIndex: _tabController.index,
                clientState: clientState,
                vehicleState: vehicleState,
                pressState: pressState,
              ),
              
              const SizedBox(height: 32),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 25,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: Column(
                  children: [
                    // Barra superior rediseñada con espaciado vertical y columnas seguras para evitar desbordamientos
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (v) => setState(() => _searchQuery = v),
                                  decoration: InputDecoration(
                                    hintText: "Buscar registros...",
                                    prefixIcon: Icon(Icons.search_rounded, color: primaryRed),
                                    filled: true,
                                    fillColor: const Color(0xFFF3F4F6),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              _buildDynamicCreateButton(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: filters.contains(activeFilter) 
                                        ? activeFilter 
                                        : "TODOS",
                                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryRed),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                                    items: filters.map((f) {
                                      return DropdownMenuItem(
                                        value: f,
                                        child: Text("Estado: ${f[0]}${f.substring(1).toLowerCase()}"),
                                      );
                                    }).toList(),
                                    onChanged: (val) => _setCurrentFilter(val ?? "TODOS"),
                                  ),
                                ),
                              ),
                              if (activeFilter != "TODOS" || _searchQuery.isNotEmpty)
                                OutlinedButton.icon(
                                  onPressed: () => setState(() {
                                    _searchQuery = "";
                                    _searchController.clear();
                                    _setCurrentFilter("TODOS");
                                  }),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: primaryRed,
                                    side: BorderSide(color: primaryRed.withOpacity(0.4)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                  icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                                  label: const Text("Limpiar filtros", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: primaryRed,
                      unselectedLabelColor: const Color(0xFF6B7280),
                      indicatorColor: primaryRed,
                      tabs: const [
                        Tab(text: "CLIENTES"),
                        Tab(text: "VEHÍCULOS"),
                        Tab(text: "PRENSAS")
                      ],
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
    switch (_tabController.index) {
      case 0:
        return _buildViewLayer(clients.status, clients.clients, "cliente", _searchQuery, _clientStatusFilter);
      case 1:
        return _buildViewLayer(vehicles.status, vehicles.vehicles, "vehiculo", _searchQuery, _vehicleStatusFilter);
      default:
        return _buildViewLayer(presses.status, presses.press, "prensa", _searchQuery, _pressStatusFilter);
    }
  }

  String _translateStatus(String? status) {
    if (status == null) return "N/A";
    switch (status.toUpperCase()) {
      case 'AVAILABLE': return 'DISPONIBLE';
      case 'WORKSHOP': return 'TALLER';
      case 'OCCUPIED': return 'OCUPADO';
      case 'ACTIVE': return 'ACTIVO';
      case 'INACTIVE': return 'INACTIVO';
      case 'MANTENIMIENTO': return 'MANTENIMIENTO';
      case 'LOANED': return 'LOANED';
      default: return status.toUpperCase();
    }
  }

  Widget _buildViewLayer(Status status, List<dynamic> items, String type, String query, String statusFilter) {
    if (status == Status.loading) {
      return const SizedBox(height: 250, child: Center(child: CircularProgressIndicator()));
    }

    final q = query.toLowerCase().trim();
    final filtered = items.where((item) {
      if (statusFilter != "TODOS") {
        if (type == "cliente") {
          final bool isActive = item.isActive ?? true;
          final statusStr = isActive ? "ACTIVO" : "INACTIVO";
          if (statusStr != statusFilter) return false;
        } else {
          final itemStatus = _translateStatus(item.operationState);
          if (itemStatus != statusFilter) return false;
        }
      }

      if (q.isEmpty) return true;

      String searchableText = "";
      if (type == "cliente") {
        searchableText = "${item.name} ${item.company} ${item.email}".toLowerCase();
      } else if (type == "vehiculo") {
        searchableText = "${item.plate} ${item.brand} ${item.model} ${item.currentLocation} ${item.unit}".toLowerCase();
      } else {
        searchableText = "${item.serie} ${item.model} ${item.currentLocation}".toLowerCase();
      }
      
      return searchableText.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      return SizedBox(
        height: 250,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                q.isNotEmpty 
                    ? "No se encontraron coincidencias para: \"$query\"" 
                    : "No hay registros con el estado seleccionado.", 
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return CatalogDataTable(
      items: filtered,
      type: type,
      primaryRed: primaryRed,
      statusTranslator: _translateStatus,
      onEdit: (item) {
        if (type == "vehiculo") {
          showDialog(context: context, builder: (_) => UpdateVehicleDialog(vehicle: item));
        } else if (type == "prensa") {
          showDialog(context: context, builder: (_) => UpdatePressDialog(press: item));
        } else {
          showDialog(context: context, builder: (_) => UpdateClientDialog(client: item));
        }
      },
      onToggleStatus: (item, isActive) {},
    );
  }

  Widget _buildDynamicCreateButton() {
    String text = "Nuevo";
    Widget dialog = const SizedBox();
    if (_tabController.index == 0) {
      text = "Cliente";
      dialog = const CreateClientDialog();
    } else if (_tabController.index == 1) {
      text = "Vehículo";
      dialog = const CreateVehicleDialog();
    } else {
      text = "Prensa";
      dialog = const CreatePressDialog();
    }

    return ElevatedButton.icon(
      onPressed: () => showDialog(context: context, builder: (_) => dialog),
      icon: const Icon(Icons.add),
      label: Text("+ $text"),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}