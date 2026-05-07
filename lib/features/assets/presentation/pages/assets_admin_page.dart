import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Conserva tus imports originales
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_vehicle_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_press_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/asset_action_card.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

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

class _AssetsAdminPageState extends ConsumerState<AssetsAdminPage> {
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
  Widget build(BuildContext context) {
    final clientState = ref.watch(clientListProvider);
    final vehicleState = ref.watch(vehicleListProvider);
    final pressState = ref.watch(pressListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 900;
            int crossAxisCount = isMobile ? 1 : (constraints.maxWidth < 1300 ? 2 : 3);
            
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: "Gestión de Activos", actionIcon: Icons.admin_panel_settings_rounded),
                  const SizedBox(height: 24),
                  const Text("Crear Nuevo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 260, 
                    ),
                    children: [
                      _buildTopCard(context, "Nuevo Cliente", Icons.person_add_rounded, const CreateClientDialog()),
                      _buildTopCard(context, "Nuevo Vehículo", Icons.directions_car_rounded, const CreateVehicleDialog()),
                      _buildTopCard(context, "Nueva Prensa", Icons.precision_manufacturing_rounded, const CreatePressDialog()),
                    ],
                  ),

                  const SizedBox(height: 40),
                  const Text("Inventario Corporativo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),

                  _buildMainContainer(isMobile, clientState, vehicleState, pressState),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContainer(bool isMobile, dynamic clients, dynamic vehicles, dynamic presses) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
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
                const TabBar(
                  labelColor: Color(0xFFD32F2F),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xFFD32F2F),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: [Tab(text: "CLIENTES"), Tab(text: "VEHÍCULOS"), Tab(text: "PRENSAS")],
                ),
                Builder(builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: tabController,
                    builder: (context, child) {
                      final index = tabController.index;
                      Widget content;
                      if (index == 0) content = _buildList(clients.status, clients.clients, "cliente", isMobile);
                      else if (index == 1) content = _buildList(vehicles.status, vehicles.vehicles, "vehiculo", isMobile);
                      else content = _buildList(presses.status, presses.press, "prensa", isMobile);
                      
                      return content;
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "Buscar registros...",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          filled: true,
          fillColor: const Color(0xFFF1F3F5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildList(Status status, List<dynamic> items, String type, bool isMobile) {
    if (status == Status.loading) return const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Color(0xFFD32F2F))));
    
    final filtered = items.where((item) {
      final q = _searchQuery.toLowerCase();
      if (type == "cliente") return (item.name?.toLowerCase() ?? "").contains(q);
      if (type == "vehiculo") return (item.plate?.toLowerCase() ?? "").contains(q);
      return (item.serie?.toLowerCase() ?? "").contains(q);
    }).toList();

    if (filtered.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No se encontraron registros", style: TextStyle(color: Colors.grey))));

    if (!isMobile) {
      return SizedBox(
        width: double.infinity,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.grey.withOpacity(0.1)),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
            dataRowMaxHeight: 65,
            headingRowHeight: 50,
            horizontalMargin: 24,
            columnSpacing: 10, // Reducido para que quepan más columnas
            showCheckboxColumn: false,
            columns: _buildTableColumns(type),
            rows: filtered.map((item) => _buildDataRow(item, type)).toList(),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _buildMobileCard(filtered[index], type),
    );
  }

  List<DataColumn> _buildTableColumns(String type) {
    const headerStyle = TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF495057), fontSize: 11, letterSpacing: 0.5);
    
    if (type == "cliente") {
      return const [
        DataColumn(label: Expanded(child: Text("NOMBRE", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("COMPAÑÍA", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("TELÉFONO", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("EMAIL", style: headerStyle))),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else if (type == "vehiculo") {
      return const [
        DataColumn(label: Expanded(child: Text("MARCA", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("MODELO", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("AÑO", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("PLACA", style: headerStyle))),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    } else {
      return const [
        DataColumn(label: Expanded(child: Text("TIPO", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("MODELO", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("VOLTAJE", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("SERIE", style: headerStyle))),
        DataColumn(label: Expanded(child: Text("TAMAÑO", style: headerStyle))),
        DataColumn(label: Text("ACCIONES", style: headerStyle)),
      ];
    }
  }

  DataRow _buildDataRow(dynamic item, String type) {
    final cellStyle = TextStyle(color: Colors.blueGrey.shade800, fontSize: 13);
    
    return DataRow(
      cells: [
        if (type == "cliente") ...[
          DataCell(Text(item.name ?? "-", style: cellStyle.copyWith(fontWeight: FontWeight.w600))),
          DataCell(Text(item.company ?? "-", style: cellStyle)),
          DataCell(Text(item.phone ?? "-", style: cellStyle)),
          DataCell(Text(item.email ?? "-", style: cellStyle)),
        ] else if (type == "vehiculo") ...[
          DataCell(Text(item.brand ?? "-", style: cellStyle)),
          DataCell(Text(item.model ?? "-", style: cellStyle)),
          DataCell(Text(item.year?.toString() ?? "-", style: cellStyle)),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFE9F0F7), borderRadius: BorderRadius.circular(6)),
            child: Text(item.plate ?? "-", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF2C3E50))),
          )),
        ] else ...[
          DataCell(Text(item.type ?? "-", style: cellStyle)),
          DataCell(Text(item.model ?? "-", style: cellStyle)),
          DataCell(Text(item.voltz ?? "-", style: cellStyle)),
          DataCell(Text(item.serie ?? "-", style: cellStyle.copyWith(fontWeight: FontWeight.w600))),
          DataCell(Text(item.size ?? "-", style: cellStyle)),
        ],
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(Icons.edit_rounded, const Color(0xFFE3F2FD), const Color(0xFF2196F3), () {}),
            const SizedBox(width: 8),
            _buildActionButton(Icons.delete_rounded, const Color(0xFFFFEBEE), const Color(0xFFD32F2F), () {}),
          ],
        )),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: iconColor, size: 16),
      ),
    );
  }

  Widget _buildMobileCard(dynamic item, String type) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade100)),
      child: ExpansionTile(
        iconColor: const Color(0xFFD32F2F),
        leading: const Icon(Icons.inventory_2_outlined, color: Color(0xFFD32F2F), size: 20),
        title: Text(
          type == "cliente" ? (item.name ?? "-") : (type == "vehiculo" ? (item.plate ?? "-") : (item.serie ?? "-")),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (type == "cliente") ...[
                  _infoRow("Compañía", item.company),
                  _infoRow("Teléfono", item.phone),
                  _infoRow("Email", item.email),
                ] else if (type == "vehiculo") ...[
                  _infoRow("Marca", item.brand),
                  _infoRow("Modelo", item.model),
                  _infoRow("Año", item.year?.toString()),
                ] else ...[
                  _infoRow("Tipo", item.type),
                  _infoRow("Voltaje", item.voltz),
                  _infoRow("Tamaño", item.size),
                ],
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(onPressed: () {}, child: const Text("Editar")),
                  TextButton(onPressed: () {}, child: const Text("Borrar", style: TextStyle(color: Colors.red))),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value ?? "-", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTopCard(BuildContext context, String title, IconData icon, Widget dialog) {
    return ActionCardActivo(
      title: title,
      description: "Añadir registro",
      icon: icon,
      onTap: () => showDialog(context: context, builder: (context) => dialog),
    );
  }
}