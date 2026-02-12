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
          
          // Configuración de columnas responsivas
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

                // Sección de Tarjetas de Acción
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
                
                // Contenedor de Tabla con Diseño Premium
                _buildTabbedContainer(context),
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

  Widget _buildTabbedContainer(BuildContext context) {
    return Container(
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
              height: 550, // Altura incrementada para mejor visualización
              child: TabBarView(
                children: [
                  _buildScrollableTable(context, clientCols, []), // [] son filas vacías de ejemplo
                  _buildScrollableTable(context, vehicleCols, []),
                  _buildScrollableTable(context, pressCols, []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableTable(BuildContext context, List<DataColumn> cols, List<DataRow> rows) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1100),
        child: DataTable(
          headingRowHeight: 60,
          dataRowMaxHeight: 75, // Espacio extra para evitar amontonamiento
          horizontalMargin: 24,
          columnSpacing: 40,
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: cols.map((c) => DataColumn(
            label: DefaultTextStyle.merge(
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF454B4E),
                fontSize: 13,
                letterSpacing: 0.3,
              ),
              child: c.label,
            ),
          )).toList(),
          // Se muestran filas de ejemplo o las que pases por parámetro
          rows: rows.isEmpty ? _buildPlaceholderRows() : rows, 
        ),
      ),
    );
  }

  // Columnas exactas solicitadas con diseño limpio
  List<DataColumn> get clientCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Nombre Completo')), 
    DataColumn(label: Text('Empresa')), DataColumn(label: Text('Teléfono')), 
    DataColumn(label: Text('Email')), DataColumn(label: Text('Dirección')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get vehicleCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Tipo')), DataColumn(label: Text('Marca')),
    DataColumn(label: Text('Modelo')), DataColumn(label: Text('Año')), DataColumn(label: Text('Placa')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get pressCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Tipo')), DataColumn(label: Text('Modelo')),
    DataColumn(label: Text('N° Serie')), DataColumn(label: Text('Voltz')), DataColumn(label: Text('Tamaño')),
    DataColumn(label: Text('Acciones')),
  ];

  // Placeholder para visualizar el diseño de las filas
  List<DataRow> _buildPlaceholderRows() {
    return List.generate(2, (index) => DataRow(
      cells: List.generate(7, (i) => DataCell(
        i == 6 
          ? Row(
              children: [
                IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F), size: 20), onPressed: () {}),
              ],
            )
          : const Text("---", style: TextStyle(color: Colors.grey, fontSize: 13))
      )),
    ));
  }
}