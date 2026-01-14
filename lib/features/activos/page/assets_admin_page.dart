import 'package:flutter/material.dart';
import '../widgets/action_card_activo.dart';
import '../widgets/dialog_crear_cliente.dart';
class AssetsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Activos Corporativos", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("Gestión integral de clientes, vehículos y prensas industriales",
              style: TextStyle(color: Colors.grey)),
            SizedBox(height: 32),
            
            // Sección de Crear Nuevo (Scroll horizontal)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionCardActivo(
                    title: "Nuevo Cliente",
                    description: "Registrar nuevo cliente empresarial",
                    icon: Icons.group_add,
                    onTap: () => _showModal(context, DialogCrearCliente()),
                  ),
                  SizedBox(width: 16),
                  ActionCardActivo(
                    title: "Nuevo Vehículo",
                    description: "Registrar vehículo de la flota",
                    icon: Icons.directions_car,
                    onTap: () {},
                  ),
                  SizedBox(width: 16),
                  ActionCardActivo(
                    title: "Nueva Prensa",
                    description: "Registrar prensa industrial",
                    icon: Icons.factory,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 48),
            
            // Sección de Listado con Tabs
            Text("Registros Existentes", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildTabbedContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabbedContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Color(0xFFD32F2F),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFFD32F2F),
              tabs: [
                Tab(icon: Icon(Icons.people), text: "Clientes (1)"),
                Tab(icon: Icon(Icons.car_repair), text: "Vehículos (1)"),
                Tab(icon: Icon(Icons.settings_suggest), text: "Prensas (1)"),
              ],
            ),
            SizedBox(
              height: 400, // Altura para la tabla
              child: TabBarView(
                children: [
                  _buildClientsTable(),
                  Center(child: Text("Lista de Vehículos")),
                  Center(child: Text("Lista de Prensas")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Nombre Completo')),
          DataColumn(label: Text('Empresa')),
          DataColumn(label: Text('Minas Relacionadas')), // Nueva columna para la relación
          DataColumn(label: Text('Contacto')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('#1')),
            DataCell(Text('Juan Pérez')),
            DataCell(Text('Industrias ABC')),
            DataCell(Chip(label: Text('Mina Santa Fe, Mina Norte'), backgroundColor: Colors.red.shade50)),
            DataCell(Text('+52 123 456 7890')),
            DataCell(IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () {})),
          ]),
        ],
      ),
    );
  }

  void _showModal(BuildContext context, Widget dialog) {
    showDialog(context: context, builder: (context) => dialog);
  }
}
