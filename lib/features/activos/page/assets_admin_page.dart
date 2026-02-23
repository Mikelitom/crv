import 'package:flutter/material.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../widgets/action_card_activo.dart';
import '../widgets/dialog_crear_cliente.dart';

class AssetsAdminPage extends StatelessWidget {
  const AssetsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          bool isDesktop = maxWidth > 900;
          double spacing = 20.0;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(
                  title: "Activos Corporativos",
                  actionIcon: Icons.business_center_rounded,
                ),
                
                const SizedBox(height: 32),
                const Text(
                  "Crear Nuevo", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))
                ),
                const SizedBox(height: 24),

                // DISEÑO DE FILA ÚNICA PARA LAPTOP
                isDesktop 
                  ? IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(child: _buildAdaptedCard(context, "Nuevo Cliente", Icons.group_add_rounded, const DialogCrearCliente())),
                          SizedBox(width: spacing),
                          Expanded(child: _buildAdaptedCard(context, "Nuevo Vehículo", Icons.directions_car_filled_rounded, const DialogCrearVehiculo())),
                          SizedBox(width: spacing),
                          Expanded(child: _buildAdaptedCard(context, "Nueva Prensa", Icons.precision_manufacturing_rounded, const DialogCrearPrensa())),
                        ],
                      ),
                    )
                  : Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        _buildAdaptedCard(context, "Nuevo Cliente", Icons.group_add_rounded, const DialogCrearCliente(), customWidth: maxWidth),
                        _buildAdaptedCard(context, "Nuevo Vehículo", Icons.directions_car_filled_rounded, const DialogCrearVehiculo(), customWidth: maxWidth),
                        _buildAdaptedCard(context, "Nueva Prensa", Icons.precision_manufacturing_rounded, const DialogCrearPrensa(), customWidth: maxWidth),
                      ],
                    ),
                
                const SizedBox(height: 48),
                
                const Text(
                  "Registros Existentes", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))
                ),
                const SizedBox(height: 20),
                
                _buildCenteredTableContainer(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdaptedCard(BuildContext context, String title, IconData icon, Widget dialog, {double? customWidth}) {
    return SizedBox(
      width: customWidth,
      child: ActionCardActivo(
        title: title,
        description: "Registrar $title en el sistema",
        icon: icon,
        onTap: () => showDialog(
          context: context, 
          builder: (context) => dialog
        ),
      ),
    );
  }

  Widget _buildCenteredTableContainer(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 12))
                ],
              ),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFFD32F2F),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFFD32F2F),
                      indicatorWeight: 3,
                      tabs: [
                        Tab(icon: Icon(Icons.people_alt_rounded), text: "Clientes"),
                        Tab(icon: Icon(Icons.local_shipping_rounded), text: "Vehículos"),
                        Tab(icon: Icon(Icons.settings_suggest_rounded), text: "Prensas"),
                      ],
                    ),
                    SizedBox(
                      height: 400, // Altura ajustada para tablas vacías
                      child: TabBarView(
                        children: [
                          _buildResponsiveTable(context, clientCols, []), // Lista vacía
                          _buildResponsiveTable(context, vehicleCols, []), // Lista vacía
                          _buildResponsiveTable(context, pressCols, []), // Lista vacía
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar registros...",
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildResponsiveTable(BuildContext context, List<DataColumn> cols, List<DataRow> rows) {
    if (rows.isEmpty) {
      return const Center(
        child: Text("No hay registros disponibles", style: TextStyle(color: Colors.grey)),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: cols, rows: rows),
    );
  }

  // --- COLUMNAS (MANTENIDAS PARA LA ESTRUCTURA) ---
  List<DataColumn> get clientCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Nombre')), 
    DataColumn(label: Text('Compañía')), DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get vehicleCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Placas')), 
    DataColumn(label: Text('Modelo')), DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get pressCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Serie')), 
    DataColumn(label: Text('Tipo')), DataColumn(label: Text('Acciones')),
  ];
}