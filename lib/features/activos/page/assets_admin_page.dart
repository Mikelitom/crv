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
          // Calculamos el ancho disponible
          double maxWidth = constraints.maxWidth;
          
          // Determinamos cuántas columnas mostrar según el ancho
          int crossAxisCount = 1; // Celular por defecto
          if (maxWidth > 1200) {
            crossAxisCount = 3; // Computadora
          } else if (maxWidth > 800) {
            crossAxisCount = 2; // Tablet
          }

          // Espaciado entre tarjetas
          double spacing = 20.0;
          // Calculamos el ancho de cada tarjeta restando los espacios
          double cardWidth = (maxWidth - (spacing * (crossAxisCount - 1)) - 48) / crossAxisCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header compartido (sin subtítulo)
                const CustomHeader(
                  title: "Activos Corporativos",
                  actionIcon: Icons.business_center_rounded,
                ),
                
                const SizedBox(height: 32),
                const Text(
                  "Crear Nuevo", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))
                ),
                const SizedBox(height: 32),
                // Sección de Tarjetas Responsivas
                Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _buildAdaptedCard(context, cardWidth, "Nuevo Cliente", Icons.group_add, const DialogCrearCliente()),
                    _buildAdaptedCard(context, cardWidth, "Nuevo Vehículo", Icons.directions_car, const DialogCrearVehiculo()),
                    _buildAdaptedCard(context, cardWidth, "Nueva Prensa", Icons.factory, const DialogCrearPrensa()),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                const Text(
                  "Registros Existentes", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))
                ),
                const SizedBox(height: 20),
                
                // Contenedor de Tabla que abarca el 100% de la página
                _buildTabbedContainer(maxWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdaptedCard(BuildContext context, double width, String title, IconData icon, Widget dialog) {
    return SizedBox(
      width: width, // El ancho ahora es dinámico y adaptado
      child: ActionCardActivo(
        title: title,
        description: "Registrar $title",
        icon: icon,
        onTap: () => showDialog(context: context, builder: (context) => dialog),
      ),
    );
  }

  Widget _buildTabbedContainer(double availableWidth) {
    return Container(
      width: double.infinity, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
              tabs: [
                Tab(icon: Icon(Icons.people_outline), text: "Clientes"),
                Tab(icon: Icon(Icons.directions_car_outlined), text: "Vehículos"),
                Tab(icon: Icon(Icons.precision_manufacturing_outlined), text: "Prensas"),
              ],
            ),
            SizedBox(
              height: 500,
              child: TabBarView(
                children: [
                  _buildScrollableTable(clientCols),
                  _buildScrollableTable(vehicleCols),
                  _buildScrollableTable(pressCols),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableTable(List<DataColumn> cols) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1000), // Ancho mínimo para que no se amontone
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: cols,
          rows: const [], 
        ),
      ),
    );
  }

  // Columnas exactas solicitadas
  List<DataColumn> get clientCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Nombre Completo')), 
    DataColumn(label: Text('Empresa')), DataColumn(label: Text('Minas Relacionadas')), 
    DataColumn(label: Text('Contacto')), DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get vehicleCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Marca')), DataColumn(label: Text('Modelo')),
    DataColumn(label: Text('Año')), DataColumn(label: Text('Placa')), DataColumn(label: Text('Estado')),
    DataColumn(label: Text('Acciones')),
  ];

  List<DataColumn> get pressCols => const [
    DataColumn(label: Text('ID')), DataColumn(label: Text('Marca')), DataColumn(label: Text('Modelo')),
    DataColumn(label: Text('N° Serie')), DataColumn(label: Text('Estado')), DataColumn(label: Text('Acciones')),
  ];
}