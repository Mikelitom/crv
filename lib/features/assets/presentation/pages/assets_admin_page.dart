import 'package:crv_reprosisa/features/assets/domain/entities/clients_conveyor.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/update_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/update_press_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_vehicle_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_press_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/asset_action_card.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import '../../../catalogo/page/catalogo_page.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetsAdminPage extends ConsumerStatefulWidget {
  const AssetsAdminPage({super.key});

  @override
  ConsumerState<AssetsAdminPage> createState() => _AssetsAdminPageState();
}

class _AssetsAdminPageState extends ConsumerState<AssetsAdminPage> {
  // Controlador para el buscador
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(clientListProvider.notifier).loadClients();
      ref.read(vehicleListProvider.notifier).loadVehicles();
      ref.read(pressListProvider.notifier).loadPress();
    });
  }

  @override
  void dispose() {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          bool isMobile = maxWidth < 700;
          int crossAxisCount = maxWidth > 1200 ? 3 : (maxWidth > 800 ? 2 : 1);
          double aspectRatio = isMobile ? 1.4 : 1.5;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomHeader(
                  title: "Activos Corporativos",
                  actionIcon: Icons.business_center_rounded,
                ),
                const SizedBox(height: 32),
                const Text(
                  "Crear Nuevo",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: aspectRatio,
                  children: [
                    _buildAdaptedCard(context, "Nuevo Cliente", Icons.person_add_rounded, const CreateClientDialog()),
                    _buildAdaptedCard(context, "Nuevo Vehículo", Icons.directions_car_filled_rounded, const CreateVehicleDialog()),
                    _buildAdaptedCard(context, "Nueva Prensa", Icons.precision_manufacturing_rounded, const CreatePressDialog()),
                  ],
                ),
                const SizedBox(height: 56),
                const Text(
                  "Registros Existentes",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
                ),
                const SizedBox(height: 24),

                /// CONTENEDOR DINÁMICO
                _buildMainTableContainer(context, isMobile, clientState, vehicleState, pressState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdaptedCard(BuildContext context, String title, IconData icon, Widget dialog) {
    return ActionCardActivo(
      title: title,
      description: "Registrar $title en el sistema",
      icon: icon,
      onTap: () async {
        final result = await showDialog(context: context, builder: (context) => dialog);
        if (result == true && mounted) {
          ref.refresh(clientListProvider);
          ref.refresh(vehicleListProvider);
          ref.refresh(pressListProvider);
        }
      },
    );
  }

  Widget _buildMainTableContainer(BuildContext context, bool isMobile, dynamic clientState, dynamic vehicleState, dynamic pressState) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSearchBar(),
          DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  labelColor: const Color(0xFFD32F2F),
                  unselectedLabelColor: Colors.blueGrey.shade300,
                  indicatorColor: const Color(0xFFD32F2F),
                  indicatorWeight: 4,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  tabs: const [
                    Tab(height: 60, icon: Icon(Icons.group, size: 18), text: "CLIENTES"),
                    Tab(height: 60, icon: Icon(Icons.local_shipping, size: 18), text: "VEHÍCULOS"),
                    Tab(height: 60, icon: Icon(Icons.settings_suggest, size: 18), text: "PRENSAS"),
                  ],
                ),
                
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Builder(
                    builder: (context) {
                      final TabController tabController = DefaultTabController.of(context);
                      return AnimatedBuilder(
                        animation: tabController,
                        builder: (context, child) {
                          // Lógica de filtrado
                          final filteredClients = clientState.clients.where((c) => 
                              c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                              c.company.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                          
                          final filteredVehicles = vehicleState.vehicles.where((v) => 
                              v.brand!.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                              v.licensePlate.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                          final filteredPress = pressState.press.where((p) => 
                              p.serie.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                              p.type.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                          List<dynamic> activeItems = (tabController.index == 0) ? filteredClients : (tabController.index == 1 ? filteredVehicles : filteredPress);

                          double dynamicHeight = (activeItems.length * (isMobile ? 110.0 : 72.0)) + 80.0;
                          if (activeItems.isEmpty) dynamicHeight = 220.0;
                          if (dynamicHeight > 700) dynamicHeight = 700;

                          return SizedBox(
                            height: dynamicHeight,
                            child: TabBarView(
                              children: [
                                _buildStateContent(isMobile, clientState.status, clientState.error, filteredClients, "cliente"),
                                _buildStateContent(isMobile, vehicleState.status, vehicleState.error, filteredVehicles, "vehiculo"),
                                _buildStateContent(isMobile, pressState.status, pressState.error, filteredPress, "prensa"),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStateContent(bool isMobile, Status status, String? error, List<dynamic> items, String type) {
    if (status == Status.loading) return const Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F)));
    if (status == Status.error) return Center(child: Text(error ?? "Error al cargar"));
    if (items.isEmpty) return const Center(child: Text("No se encontraron resultados", style: TextStyle(color: Colors.grey)));

    return isMobile ? _buildMobileList(items, type) : _buildDesktopTable(items, type);
  }

  Widget _buildMobileList(List<dynamic> items, String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade100)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(type == "cliente" ? item.name : (type == "vehiculo" ? item.licensePlate : item.serie), style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(type == "cliente" ? item.company : (type == "vehiculo" ? "${item.brand} ${item.model}" : item.type)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const GenericCatalogPage(type: AssetType.vehiculo))),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(List<dynamic> items, String type) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 120),
        child: DataTable(
          dataRowHeight: 72,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFFBFBFC)),
          columns: _buildColumns(type),
          rows: items.map((item) => _buildDataRow(item, type)).toList(),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(String type) {
    final List<Map<String, dynamic>> cols = type == "cliente" 
      ? [{"l": "Nombre", "i": Icons.person}, {"l": "Compañía", "i": Icons.business}, {"l": "Teléfono", "i": Icons.phone}, {"l": "Acciones", "i": Icons.bolt}]
      : type == "vehiculo"
      ? [{"l": "Marca", "i": Icons.directions_car}, {"l": "Modelo", "i": Icons.info_outline}, {"l": "Placa", "i": Icons.badge}, {"l": "Acciones", "i": Icons.bolt}]
      : [{"l": "Serie", "i": Icons.qr_code}, {"l": "Tipo", "i": Icons.category}, {"l": "Voltaje", "i": Icons.electric_bolt}, {"l": "Acciones", "i": Icons.bolt}];

    return cols.map((c) => DataColumn(label: Row(children: [
      Icon(c['i'], size: 16, color: const Color(0xFFD32F2F)),
      const SizedBox(width: 8),
      Text(c['l'], style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF455A64))),
    ]))).toList();
  }

  DataRow _buildDataRow(dynamic item, String type) {
    return DataRow(cells: [
      if (type == "cliente") ...[
        DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(item.company)),
        DataCell(Text(item.phone)),
      ] else if (type == "vehiculo") ...[
        DataCell(Text(item.brand ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(item.model)),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFF1F3F4), borderRadius: BorderRadius.circular(8)),
          child: Text(item.licensePlate, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        )),
      ] else ...[
        DataCell(Text(item.serie, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)))),
        DataCell(Text(item.type)),
        DataCell(Text(item.voltz ?? "N/A")),
      ],
      DataCell(_buildActionsMenu(
        onEdit: () {}, 
        onDetails: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const GenericCatalogPage(type: AssetType.vehiculo))),
      )),
    ]);
  }

  Widget _buildActionsMenu({required VoidCallback onEdit, required VoidCallback onDetails}) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz_rounded, color: Colors.blueGrey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (val) {
        if (val == 'details') onDetails();
        if (val == 'edit') onEdit();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'details', child: Row(children: [Icon(Icons.analytics_outlined, size: 18), SizedBox(width: 10), Text("Más Detalles")])),
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18, color: Color(0xFFD32F2F)), SizedBox(width: 10), Text("Editar")])),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F9), 
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: "Filtrar por nombre, placa o serie...",
            hintStyle: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD32F2F), size: 22),
            suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = "");
            }) : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildStateTable(Status status, String? error, Widget table) {
    if (status == Status.loading) return const Center(child: Padding(padding: EdgeInsets.all(60), child: CircularProgressIndicator(color: Color(0xFFD32F2F), strokeWidth: 3)));
    if (status == Status.error) return Center(child: Text(error ?? "Error inesperado"));
    return table;
  }
}