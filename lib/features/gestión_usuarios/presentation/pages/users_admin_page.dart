import 'package:flutter/material.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../widgets/user_stats_card.dart';
// IMPORTA TUS NUEVOS WIDGETS AQUÍ
import '../widgets/user_search_field.dart';
import '../widgets/user_filter_bar.dart';
import '../widgets/user_data_table.dart';

class UsersAdminPage extends StatefulWidget {
  const UsersAdminPage({super.key});

  @override
  State<UsersAdminPage> createState() => _UsersAdminPageState();
}

class _UsersAdminPageState extends State<UsersAdminPage> {
  final List<Map<String, dynamic>> _allUsers = [
    {'name': 'Carlos Ramírez', 'email': 'carlos@reprosisa.com', 'role': 'Técnico', 'area': 'General', 'isActive': true},
    {'name': 'Admin Test', 'email': 'admin@reprosisa.com', 'role': 'Administrador', 'area': 'Vehículos', 'isActive': false},
    // ... más usuarios
  ];

  String _searchQuery = '';
  String _selectedStatus = 'Todos los Estados';
  String _selectedRole = 'Todos los Roles';

  @override
  Widget build(BuildContext context) {
    // Lógica de filtrado (se mantiene aquí para reaccionar al estado)
    final filteredUsers = _allUsers.where((user) {
      final matchesSearch = user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           user['email'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'Todos los Estados' || 
                           (user['isActive'] && _selectedStatus == 'Habilitados') ||
                           (!user['isActive'] && _selectedStatus == 'Deshabilitados');
      final matchesRole = _selectedRole == 'Todos los Roles' || user['role'] == _selectedRole;
      return matchesSearch && matchesStatus && matchesRole;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Panel de Usuarios", actionIcon: Icons.admin_panel_settings_rounded),
              const SizedBox(height: 32),
              
              _buildResponsiveStatsGrid(constraints.maxWidth), // Reutiliza tu Wrap de Stats

              const SizedBox(height: 48),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Listado de Personal", style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal)),
                  UserSearchField(
                    width: 350,
                    query: _searchQuery,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    onClear: () => setState(() => _searchQuery = ''),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              UserFilterBar(
                selectedStatus: _selectedStatus,
                selectedRole: _selectedRole,
                onStatusChanged: (val) => setState(() => _selectedStatus = val!),
                onRoleChanged: (val) => setState(() => _selectedRole = val!),
                onReset: () => setState(() { _selectedStatus = 'Todos los Estados'; _selectedRole = 'Todos los Roles'; _searchQuery = ''; }),
              ),

              const SizedBox(height: 16),
              
              // CONTENEDOR DE LA TABLA
              _tableCard(constraints.maxWidth, filteredUsers),
            ],
          ),
        );
      }),
    );
  }

  Widget _tableCard(double maxWidth, List<Map<String, dynamic>> users) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 30)]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: maxWidth < 1100 ? 1100 : maxWidth - 64),
            child: UserDataTable(
              users: users, 
              onToggleStatus: (index, val) => setState(() => users[index]['isActive'] = val),
            ),
          ),
        ),
      ),
    );
  }
  
  // Tu método _buildResponsiveStatsGrid y _stat se quedan aquí o también se pueden mover a widgets/
  Widget _buildResponsiveStatsGrid(double maxWidth) {
    int col = maxWidth > 1200 ? 4 : (maxWidth > 750 ? 2 : 1);
    double w = (maxWidth - (16 * (col - 1)) - 64) / col;
    return Wrap(spacing: 16, runSpacing: 16, children: [
      _stat(w, "Total Usuarios", _allUsers.length.toString(), Icons.people_alt_rounded),
      _stat(w, "Técnicos", _allUsers.where((u) => u['role'] == 'Técnico').length.toString(), Icons.engineering_rounded),
      _stat(w, "Habilitados", _allUsers.where((u) => u['isActive']).length.toString(), Icons.check_circle_rounded),
      _stat(w, "Deshabilitados", _allUsers.where((u) => !u['isActive']).length.toString(), Icons.do_not_disturb_on_rounded),
    ]);
  }
  Widget _stat(double w, String l, String v, IconData i) => SizedBox(width: w, child: UserStatsCard(label: l, value: v, icon: i));
}