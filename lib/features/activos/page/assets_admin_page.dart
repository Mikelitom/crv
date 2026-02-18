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
          
          int crossAxisCount = maxWidth > 1200 ? 3 : (maxWidth > 800 ? 2 : 1);
          double spacing = 20.0;
          double cardWidth = (maxWidth - (spacing * (crossAxisCount - 1)) - 48) / crossAxisCount;

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

                Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _buildAdaptedCard(context, cardWidth, "Nuevo Cliente", Icons.group_add_rounded, const DialogCrearCliente()),
                    _buildAdaptedCard(context, cardWidth, "Nuevo Vehículo", Icons.directions_car_filled_rounded, const DialogCrearVehiculo()),
                    _buildAdaptedCard(context, cardWidth, "Nueva Prensa", Icons.precision_manufacturing_rounded, const DialogCrearPrensa()),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                const Text(
                  "Registros Existentes", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))
                ),
                const SizedBox(height: 20),
                
                // CONTENEDOR DE TABLA CENTRADO CON BUSCADOR
                _buildCenteredTableContainer(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdaptedCard(BuildContext context, double width, String title, IconData icon, Widget dialog) {
    return SizedBox(
      width: width,
      child: ActionCardActivo(
        title: title,
        description: "Registrar $title en el sistema",
        icon: icon,
        onTap: () => showDialog(context: context, builder: (context) => dialog),
      ),
    );
  }

  Widget _buildCenteredTableContainer(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          children: [
            // BARRA DE BÚSQUEDA INTEGRADA
            _buildSearchBar(),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  )
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
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      tabs: [
                        Tab(icon: Icon(Icons.people_alt_rounded), text: "Clientes"),
                        Tab(icon: Icon(Icons.local_shipping_rounded), text: "Vehículos"),
                        Tab(icon: Icon(Icons.settings_suggest_rounded), text: "Prensas"),
                      ],
                    ),
                    SizedBox(
                      height: 600, 
                      child: TabBarView(
                        children: [
                          _buildResponsiveTable(context, clientCols),
                          _buildResponsiveTable(context, vehicleCols),
                          _buildResponsiveTable(context, pressCols),
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
          hintText: "Buscar por ID, nombre o placa...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildResponsiveTable(BuildContext context, List<DataColumn> cols) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1200),
        child: DataTable(
          headingRowHeight: 60,
          dataRowMaxHeight: 70,
          horizontalMargin: 24,
          columnSpacing: 35,
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: cols.map((c) => DataColumn(
            label: DefaultTextStyle.merge(
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF454B4E),
                fontSize: 13,
              ),
              child: c.label,
            ),
          )).toList(),
          rows: _buildPlaceholderRows(cols.length), 
        ),
      ),
    );
  }

  List<DataColumn> get clientCols => const [
    DataColumn(label: Text('ID')), 
    DataColumn(label: Text('Nombre')), 
    DataColumn(label: Text('Compañía')), 
    DataColumn(label: Text('Teléfono')), 
    DataColumn(label: Text('Dirección')),
    DataColumn(label: Text('Email')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get vehicleCols => const [
    DataColumn(label: Text('ID')), 
    DataColumn(label: Text('Tipo ID')), 
    DataColumn(label: Text('Marca')),
    DataColumn(label: Text('Modelo')), 
    DataColumn(label: Text('Año')), 
    DataColumn(label: Text('Placas')),
    DataColumn(label: Text('Fecha Creación')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get pressCols => const [
    DataColumn(label: Text('ID')), 
    DataColumn(label: Text('Tipo')), 
    DataColumn(label: Text('Modelo')),
    DataColumn(label: Text('Voltz')), 
    DataColumn(label: Text('Serie')), 
    DataColumn(label: Text('Tamaño')),
    DataColumn(label: Text('Fecha Creación')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataRow> _buildPlaceholderRows(int colCount) {
    return List.generate(3, (index) => DataRow(
      cells: List.generate(colCount, (i) => DataCell(
        i == colCount - 1 
          ? Row(
              children: [
                IconButton(icon: const Icon(Icons.edit_note_rounded, color: Colors.blue), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete_sweep_rounded, color: Color(0xFFD32F2F)), onPressed: () {}),
              ],
            )
          : const Text("---", style: TextStyle(fontSize: 13, color: Colors.grey))
      )),
    ));
  }
}