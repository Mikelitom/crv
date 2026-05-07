import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Imports de tu proyecto
import 'package:crv_reprosisa/features/assets/presentation/providers/client_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_client_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_vehicle_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/dialogs/create_press_dialog.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/asset_action_card.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

/// 1. CONFIGURACIÓN PARA EL SCROLL CON MOUSE
/// Esta clase permite que el mouse y el trackpad funcionen como "drag"
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
      // 2. APLICAMOS EL SCROLL CONFIGURATION AQUÍ
      body: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 900;
            int crossAxisCount = isMobile ? 1 : (constraints.maxWidth < 1300 ? 2 : 3);
            
            return SingleChildScrollView(
              // Physics para que el scroll sea fluido y siempre esté activo
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
                      // 3. ALTURA DE TARJETA AUMENTADA PARA EVITAR OVERFLOW
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
      ),
      child: Column(
        children: [
          _buildSearchBar(),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Color(0xFFD32F2F),
                  indicatorColor: Color(0xFFD32F2F),
                  indicatorWeight: 3,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: [Tab(text: "CLIENTES"), Tab(text: "VEHÍCULOS"), Tab(text: "PRENSAS")],
                ),
                SizedBox(
                  height: 600, 
                  child: TabBarView(
                    children: [
                      _buildList(clients.status, clients.clients, "cliente", isMobile),
                      _buildList(vehicles.status, vehicles.vehicles, "vehiculo", isMobile),
                      _buildList(presses.status, presses.press, "prensa", isMobile),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "Escriba para filtrar...",
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD32F2F), size: 20),
          filled: true,
          fillColor: const Color(0xFFF5F7F9),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildList(Status status, List<dynamic> items, String type, bool isMobile) {
    if (status == Status.loading) return const Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F)));
    
    final filtered = items.where((item) {
      final q = _searchQuery.toLowerCase();
      if (type == "cliente") return (item.name?.toLowerCase() ?? "").contains(q);
      if (type == "vehiculo") return (item.plate?.toLowerCase() ?? "").contains(q);
      return (item.serie?.toLowerCase() ?? "").contains(q);
    }).toList();

    if (filtered.isEmpty) return const Center(child: Text("No hay registros disponibles", style: TextStyle(color: Colors.grey)));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade100),
          ),
          child: ExpansionTile(
            iconColor: const Color(0xFFD32F2F),
            leading: const Icon(Icons.inventory_2_outlined, color: Color(0xFFD32F2F), size: 20),
            title: Text(
              type == "cliente" ? (item.name ?? "-") : (type == "vehiculo" ? (item.plate ?? "-") : (item.serie ?? "-")),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    if (type == "cliente") ...[
                      _infoRow("Compañía", item.company),
                      _infoRow("Teléfono", item.phone),
                      _infoRow("Correo", item.email),
                    ] else if (type == "vehiculo") ...[
                      _infoRow("Marca", item.brand),
                      _infoRow("Modelo", item.model),
                      _infoRow("Año", item.year?.toString()),
                    ] else ...[
                      _infoRow("Tipo", item.type),
                      _infoRow("Modelo", item.model),
                      _infoRow("Voltaje", item.voltz),
                      _infoRow("Tamaño", item.size),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {}, 
                          icon: const Icon(Icons.edit_outlined, size: 18), 
                          label: const Text("Editar", style: TextStyle(fontSize: 13)),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {}, 
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18), 
                          label: const Text("Borrar", style: TextStyle(color: Colors.red, fontSize: 13)),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value ?? "-", 
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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