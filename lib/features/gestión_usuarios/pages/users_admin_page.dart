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
        
        int statColumns = maxWidth > 1200 ? 4 : (maxWidth > 700 ? 2 : 1);
        double spacing = 20.0;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(
                    title: "Gestión de Usuarios",
                    actionIcon: Icons.settings_rounded,
                  ),
                  const SizedBox(height: 32),
                  
                  _buildResponsiveStats(maxWidth, statColumns, spacing),

                  const SizedBox(height: 32),

                  _buildActionBanner(context),

                  const SizedBox(height: 48),

                  // Arreglo de Overflow en el encabezado de la tabla
                  _buildTableTopActions(maxWidth),

                  const SizedBox(height: 16),

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
    bool isSmallScreen = maxWidth < 900;

    return Flex(
      direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: isSmallScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        const Text(
          "Listado de Personal",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E)),
        ),
        if (isSmallScreen) const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              // Ancho dinámico para evitar overflow
              width: isSmallScreen ? (maxWidth - 48) : 380,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar por nombre o email...",
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD32F2F)),
                  filled: true,
                  fillColor: Colors.white,
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
            if (!isSmallScreen) ...[
              const SizedBox(width: 16),
              _buildFilterDropdown("Tipo"),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildUserTableContainer() {
    return Container(
      width: double.infinity, 
      decoration: BoxDecoration(
        color: Colors.white,
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
    // Lista de filas vacía para eliminar datos estáticos
    final List<DataRow> rows = []; 

    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.person_search_rounded, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("No hay usuarios registrados", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1200),
        child: DataTable(
          headingRowHeight: 68,
          dataRowMaxHeight: 85,
          horizontalMargin: 32,
          columnSpacing: 60,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
          columns: _buildColumns(),
          rows: rows,
        ),
      ),
    );
  }

  // --- MÉTODOS DE APOYO ---

  List<DataColumn> _buildColumns() {
    const labels = ['NOMBRE', 'CONTACTO', 'TIPO', 'ÁREA', 'ESTADO', 'ACCIONES'];
    return labels.map((label) => DataColumn(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
    )).toList();
  }

  Widget _buildResponsiveStats(double maxWidth, int columns, double spacing) {
    double statWidth = (maxWidth.clamp(0, 1600) - (spacing * (columns - 1)) - 48) / columns;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        _buildStat(statWidth, "Total Usuarios", "0", Icons.group),
        _buildStat(statWidth, "Activos", "0", Icons.check_circle_outline),
        _buildStat(statWidth, "Administradores", "0", Icons.security),
        _buildStat(statWidth, "Empleados", "0", Icons.person_outline),
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
      child: LayoutBuilder(builder: (context, bConstraints) {
        bool isCompact = bConstraints.maxWidth < 600;
        return Flex(
          direction: isCompact ? Axis.vertical : Axis.horizontal,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFDECEA), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.person_add_rounded, color: Color(0xFFD32F2F), size: 32),
            ),
            SizedBox(width: isCompact ? 0 : 28, height: isCompact ? 16 : 0),
            Expanded(
              flex: isCompact ? 0 : 1,
              child: Column(
                crossAxisAlignment: isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: const [
                  Text("Crear Nuevo Usuario", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  Text("Registra y asigna roles a miembros del equipo", style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),
            ),
            SizedBox(width: isCompact ? 0 : 16, height: isCompact ? 24 : 0),
            ElevatedButton(
              onPressed: () => showDialog(context: context, builder: (c) =>  DialogCrearUsuario()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text("Crear Usuario", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        );
      }),
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