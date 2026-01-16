import 'package:flutter/material.dart';
import '../widgets/dialog_crear_usuario.dart';
import '../widgets/user_stats_card.dart';

class UsersAdminPage extends StatelessWidget {
  const UsersAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildStatsGrid(),
            SizedBox(height: 24),
            _buildActionBanner(context),
            SizedBox(height: 24),
            _buildUserTableContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gestión de Usuarios", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text("Control y administración de usuarios del sistema", style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          Spacer(),
          CircleAvatar(backgroundColor: Color(0xFFD32F2F), child: Icon(Icons.settings, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          SizedBox(width: width > 1200 ? (width/4)-20 : (width/2)-10, child: UserStatsCard(label: "Total Usuarios", value: "3", icon: Icons.group)),
          SizedBox(width: width > 1200 ? (width/4)-20 : (width/2)-10, child: UserStatsCard(label: "Activos", value: "3", icon: Icons.check_circle_outline)),
          SizedBox(width: width > 1200 ? (width/4)-20 : (width/2)-10, child: UserStatsCard(label: "Administradores", value: "1", icon: Icons.security)),
          SizedBox(width: width > 1200 ? (width/4)-20 : (width/2)-10, child: UserStatsCard(label: "Empleados", value: "1", icon: Icons.person_outline)),
        ],
      );
    });
  }

  Widget _buildActionBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade50),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xFFD32F2F), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.person_add, color: Colors.white),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Crear Nuevo Usuario", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Registrar un nuevo usuario en el sistema", style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () => showDialog(context: context, builder: (c) => DialogCrearUsuario()),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD32F2F), padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
            child: Text("Crear Usuario", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildUserTableContainer() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: "Buscar por nombre o email...", prefixIcon: Icon(Icons.search)))),
                SizedBox(width: 16),
                _buildSmallDropdown("Todos los tipos"),
                SizedBox(width: 16),
                _buildSmallDropdown("Todos"),
              ],
            ),
          ),
          _buildDataTable(),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
        columns: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Email / Teléfono')),
          DataColumn(label: Text('Tipo')),
          DataColumn(label: Text('Área')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: [
          _userRow("Carlos Ramírez", "ID: 1", "carlos.ramirez@reprosisa.com", "+52 444 123 4567", "Administrador", "Todos"),
          _userRow("María González", "ID: 2", "maria.gonzalez@reprosisa.com", "+52 444 234 5678", "Admin Área", "Vehículos"),
        ],
      ),
    );
  }

  DataRow _userRow(String name, String id, String email, String phone, String type, String area) {
    return DataRow(cells: [
      DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(name, style: TextStyle(fontWeight: FontWeight.bold)), Text(id, style: TextStyle(fontSize: 12, color: Colors.grey))])),
      DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Row(children: [Icon(Icons.email_outlined, size: 14, color: Colors.grey), SizedBox(width: 4), Text(email)]), Row(children: [Icon(Icons.phone_outlined, size: 14, color: Colors.grey), SizedBox(width: 4), Text(phone)])])),
      DataCell(Chip(label: Text(type), backgroundColor: Colors.red.shade50, labelStyle: TextStyle(color: Color(0xFFD32F2F), fontSize: 12))),
      DataCell(Text(area)),
      DataCell(Chip(label: Text("Activo"), backgroundColor: Colors.green.shade50, labelStyle: TextStyle(color: Colors.green, fontSize: 12))),
      DataCell(Icon(Icons.more_vert, color: Colors.grey)),
    ]);
  }

  Widget _buildSmallDropdown(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<String>(
        value: label,
        underline: SizedBox(),
        items: [DropdownMenuItem(value: label, child: Text(label, style: TextStyle(fontSize: 14)))],
        onChanged: (v) {},
      ),
    );
  }
}