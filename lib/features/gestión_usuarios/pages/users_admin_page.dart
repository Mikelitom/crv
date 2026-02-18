import 'package:flutter/material.dart';
import '../../dashboard/presentation/widgets/header.dart';
import '../widgets/dialog_crear_usuario.dart';
import '../widgets/user_stats_card.dart';

class UsersAdminPage extends StatelessWidget {
  const UsersAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FONDO RESTAURADO: Se vuelve al gris suave original
      backgroundColor: const Color(0xFFF8F9FA), 
      body: LayoutBuilder(builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        
        int statColumns = maxWidth > 1200 ? 4 : (maxWidth > 700 ? 2 : 1);
        double spacing = 20.0;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              // ANCHO MAXIMIZADO: 1600px para abarcar todo el sistema
              constraints: const BoxConstraints(maxWidth: 1600), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(
                    title: "Gestión de Usuarios",
                    actionIcon: Icons.settings_rounded,
                  ),
                  const SizedBox(height: 32),
                  
                  // Estadísticas dinámicas
                  _buildResponsiveStats(maxWidth, statColumns, spacing),

                  const SizedBox(height: 32),

                  // Banner de Acción (Blanco sobre fondo gris)
                  _buildActionBanner(context),

                  const SizedBox(height: 48),

                  // --- ENCABEZADO INDEPENDIENTE (Abarca todo el ancho) ---
                  _buildTableTopActions(maxWidth),

                  const SizedBox(height: 16),

                  // --- CONTENEDOR DE TABLA (Blanco puro para resaltar) ---
                  _buildUserTableContainer(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTableTopActions(double maxWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Listado de Personal",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
        ),
        Row(
          children: [
            SizedBox(
              width: 380,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar por nombre o email...",
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
                  filled: true,
                  fillColor: Colors.white, // Buscador blanco para resaltar del fondo gris
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (maxWidth > 850) _buildFilterDropdown("Tipo de Usuario"),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTableContainer() {
    return Container(
      width: double.infinity, 
      decoration: BoxDecoration(
        color: Colors.white, // La tabla permanece en blanco para legibilidad
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 12))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: _buildDataTable(),
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1550), // Forzar ancho completo
        child: DataTable(
          headingRowHeight: 68,
          dataRowMaxHeight: 85,
          horizontalMargin: 32,
          columnSpacing: 60,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
          columns: _buildColumns(),
          rows: [
            _userRow("Carlos Ramírez", "ID: 1", "carlos.ramirez@reprosisa.com", "Administrador", "Todos"),
            _userRow("María González", "ID: 2", "maria.gonzalez@reprosisa.com", "Admin Área", "Vehículos"),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS DE APOYO ---

  List<DataColumn> _buildColumns() {
    const labels = ['NOMBRE', 'CONTACTO', 'TIPO', 'ÁREA', 'ESTADO', 'ACCIONES'];
    return labels.map((label) => DataColumn(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
    )).toList();
  }

  DataRow _userRow(String name, String id, String email, String type, String area) {
    return DataRow(cells: [
      DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(id, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      )),
      DataCell(Text(email, style: const TextStyle(fontSize: 13))),
      DataCell(_buildRoleBadge(type)),
      DataCell(Text(area, style: const TextStyle(fontSize: 13))),
      DataCell(_buildStatusBadge("Activo")),
      DataCell(IconButton(icon: const Icon(Icons.more_horiz_rounded, color: Colors.grey), onPressed: () {})),
    ]);
  }

  Widget _buildResponsiveStats(double maxWidth, int columns, double spacing) {
    double statWidth = (maxWidth.clamp(0, 1600) - (spacing * (columns - 1)) - 48) / columns;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        _buildStat(statWidth, "Total Usuarios", "3", Icons.group),
        _buildStat(statWidth, "Activos", "3", Icons.check_circle_outline),
        _buildStat(statWidth, "Administradores", "1", Icons.security),
        _buildStat(statWidth, "Empleados", "1", Icons.person_outline),
      ],
    );
  }

  Widget _buildStat(double width, String label, String value, IconData icon) {
    return SizedBox(width: width, child: UserStatsCard(label: label, value: value, icon: icon));
  }

  Widget _buildActionBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFFDECEA), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.person_add_rounded, color: Color(0xFFD32F2F), size: 32),
          ),
          const SizedBox(width: 28),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Crear Nuevo Usuario", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                Text("Registra y asigna roles a nuevos miembros del equipo", style: TextStyle(color: Colors.grey, fontSize: 15)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => showDialog(context: context, builder: (c) => DialogCrearUsuario()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text("Crear Usuario", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFFDECEA), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFilterDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFD32F2F)),
          items: const [],
          onChanged: (v) {},
        ),
      ),
    );
  }
}