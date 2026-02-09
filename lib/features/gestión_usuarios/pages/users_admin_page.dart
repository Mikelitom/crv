import 'package:flutter/material.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../widgets/dialog_crear_usuario.dart';
import '../widgets/user_stats_card.dart';

class UsersAdminPage extends StatelessWidget {
  const UsersAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: LayoutBuilder(builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        
        // Grid responsivo: 4 columnas en web, 2 en tablet, 1 en móvil
        int statColumns = maxWidth > 1200 ? 4 : (maxWidth > 700 ? 2 : 1);
        double spacing = 20.0;
        double statWidth = (maxWidth - (spacing * (statColumns - 1)) - 48) / statColumns;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                title: "Gestión de Usuarios",
                actionIcon: Icons.settings_rounded,
              ),
              const SizedBox(height: 32),
              
              // Estadísticas con ancho dinámico
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _buildStat(statWidth, "Total Usuarios", "3", Icons.group),
                  _buildStat(statWidth, "Activos", "3", Icons.check_circle_outline),
                  _buildStat(statWidth, "Administradores", "1", Icons.security),
                  _buildStat(statWidth, "Empleados", "1", Icons.person_outline),
                ],
              ),

              const SizedBox(height: 32),

              // Banner de Acción Adaptable
              _buildActionBanner(context, maxWidth),

              const SizedBox(height: 32),

              // Contenedor de Tabla con Sombra Profunda
              _buildUserTableContainer(maxWidth),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStat(double width, String label, String value, IconData icon) {
    return SizedBox(
      width: width,
      child: UserStatsCard(label: label, value: value, icon: icon),
    );
  }

  Widget _buildActionBanner(BuildContext context, double maxWidth) {
    // Si la pantalla es pequeña (<700px), cambiamos a columna para evitar desbordamiento
    bool isCompact = maxWidth < 700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Flex(
        direction: isCompact ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_add_rounded, color: Color(0xFFD32F2F), size: 30),
              ),
              if (isCompact) const SizedBox(width: 16),
              if (isCompact) const Text("Nuevo Usuario", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(width: 24, height: 16),
          Expanded(
            flex: isCompact ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCompact) const Text("Crear Nuevo Usuario", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1A1C1E))),
                const Text("Registra y asigna roles a nuevos miembros del equipo", 
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => showDialog(context: context, builder: (c) => DialogCrearUsuario()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text("Crear Usuario", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildUserTableContainer(double maxWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 12))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar por nombre o email...",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                if (maxWidth > 650) _buildFilterDropdown("Tipo de Usuario"),
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1000),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: const [
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Contacto')),
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Área')),
            DataColumn(label: Text('Estado')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: [
            _userRow("Carlos Ramírez", "ID: 1", "carlos.ramirez@reprosisa.com", "Administrador", "Todos"),
            _userRow("María González", "ID: 2", "maria.gonzalez@reprosisa.com", "Admin Área", "Vehículos"),
          ],
        ),
      ),
    );
  }

  DataRow _userRow(String name, String id, String email, String type, String area) {
    return DataRow(cells: [
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(id, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      )),
      DataCell(Text(email)),
      DataCell(_buildRoleBadge(type)),
      DataCell(Text(area)),
      DataCell(_buildStatusBadge("Activo")),
      DataCell(IconButton(icon: const Icon(Icons.more_horiz, color: Colors.grey), onPressed: () {})),
    ]);
  }

  Widget _buildRoleBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFDECEA), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFilterDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: DropdownButton<String>(
        hint: Text(label, style: const TextStyle(fontSize: 14)),
        underline: const SizedBox(),
        items: const [],
        onChanged: (v) {},
      ),
    );
  }
}