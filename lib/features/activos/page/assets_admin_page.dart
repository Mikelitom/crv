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
                    _buildAdaptedCard(context, cardWidth, "Nuevo Vehículo", Icons.directions_car_filled_rounded, const Placeholder()), // Reemplaza con tu DialogCrearVehiculo
                    _buildAdaptedCard(context, cardWidth, "Nueva Prensa", Icons.precision_manufacturing_rounded, const Placeholder()), // Reemplaza con tu DialogCrearPrensa
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
                          _buildResponsiveTable(context, clientCols, _buildClientRows()),
                          _buildResponsiveTable(context, vehicleCols, _buildVehicleRows()),
                          _buildResponsiveTable(context, pressCols, _buildPressRows()),
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

  Widget _buildResponsiveTable(BuildContext context, List<DataColumn> cols, List<DataRow> rows) {
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
          rows: rows,
        ),
      ),
    );
  }

  // --- DATOS ESTÁTICOS PARA LA DEMO ---

  List<DataRow> _buildClientRows() {
    final clients = [
      ["CLI-001", "Miguel Fajardo", "Reprosisa", "662-368-3723", "Hermosillo, Sonora", "majfe202@hotmail.com"],
      ["CLI-002", "Juan Soto", "Minería del Norte", "662-123-4567", "Cananea, Sonora", "jsoto@mineria.com"],
      ["CLI-003", "Empresa ABC", "Logística Express", "800-999-0000", "CDMX, México", "contacto@abc.mx"],
    ];

    return clients.map((c) => DataRow(cells: [
      DataCell(Text(c[0], style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(c[1])),
      DataCell(Text(c[2])),
      DataCell(Text(c[3])),
      DataCell(Text(c[4])),
      DataCell(Text(c[5])),
      _buildActionCell(),
    ])).toList();
  }

  List<DataRow> _buildVehicleRows() {
    final vehicles = [
      ["VEH-01", "Pickup", "Toyota", "Hilux", "2023", "V-3305-SON", "20/02/2026"],
      ["VEH-02", "Camioneta", "Nissan", "NP300", "2022", "AB-123-CD", "15/01/2026"],
      ["VEH-03", "Sedán", "Honda", "Civic", "2024", "XY-987-ZZ", "01/02/2026"],
    ];

    return vehicles.map((v) => DataRow(cells: [
      DataCell(Text(v[0], style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(v[1])),
      DataCell(Text(v[2])),
      DataCell(Text(v[3])),
      DataCell(Text(v[4])),
      DataCell(Text(v[5])),
      DataCell(Text(v[6])),
      _buildActionCell(),
    ])).toList();
  }

  List<DataRow> _buildPressRows() {
    final presses = [
      ["PRN-8821", "Hidráulica", "PH-2000", "440V", "SN-8821-2026", "24x24", "19/02/2026"],
      ["PRN-8822", "Térmica", "T-100", "220V", "SN-8822-2025", "12x12", "18/02/2026"],
      ["PRN-8823", "Manual", "M-50", "N/A", "SN-8823-2024", "10x10", "10/12/2025"],
    ];

    return presses.map((p) => DataRow(cells: [
      DataCell(Text(p[0], style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(p[1])),
      DataCell(Text(p[2])),
      DataCell(Text(p[3])),
      DataCell(Text(p[4])),
      DataCell(Text(p[5])),
      DataCell(Text(p[6])),
      _buildActionCell(),
    ])).toList();
  }

  DataCell _buildActionCell() {
    return DataCell(
      Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_note_rounded, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete_sweep_rounded, color: Color(0xFFD32F2F)), onPressed: () {}),
        ],
      ),
    );
  }

  // --- COLUMNAS (MANTENIDAS) ---

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
    DataColumn(label: Text('Tipo')), 
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
}