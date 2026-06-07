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
  final Color primaryRed = const Color(0xFFC62828);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final clientState = ref.watch(clientListProvider);
    final vehicleState = ref.watch(vehicleListProvider);
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
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 380),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) => setState(() => _searchQuery = v),
                                decoration: InputDecoration(
                                  hintText: "Buscar registros...",
                                  prefixIcon: Icon(Icons.search_rounded, color: primaryRed),
                                  filled: true,
                                  fillColor: const Color(0xFFF3F4F6),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          _buildDynamicCreateButton(),
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
        return _buildViewLayer(clients.status, clients.clients, "cliente", _searchQuery);
      case 1:
        return _buildViewLayer(vehicles.status, vehicles.vehicles, "vehiculo", _searchQuery);
      default:
        return _buildViewLayer(presses.status, presses.press, "prensa", _searchQuery);
    }
  }

  Widget _buildViewLayer(Status status, List<dynamic> items, String type, String query) {
    if (status == Status.loading) {
      return const SizedBox(height: 250, child: Center(child: CircularProgressIndicator()));
    }
    
    final filtered = items.where((item) {
      final q = query.toLowerCase().trim();
      if (q.isEmpty) return true;
      if (type == "cliente") {
        return (item.name?.toLowerCase() ?? "").contains(q) || (item.company?.toLowerCase() ?? "").contains(q);
      }
      if (type == "vehiculo") {
        return (item.plate?.toLowerCase() ?? "").contains(q) || (item.brand?.toLowerCase() ?? "").contains(q);
      }
      return (item.serie?.toLowerCase() ?? "").contains(q) || (item.model?.toLowerCase() ?? "").contains(q);
    }).toList();

    return CatalogDataTable(
      items: filtered,
      type: type,
      primaryRed: primaryRed,
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
      label: MediaQuery.of(context).size.width > 500
          ? Text("+ $text")
          : const SizedBox.shrink(),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}