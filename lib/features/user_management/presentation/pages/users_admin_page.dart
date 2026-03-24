import 'package:crv_reprosisa/features/user_management/presentation/provider/user_management_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../widgets/user_stats_card.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import '../widgets/user_search_field.dart';
import '../widgets/user_filter_bar.dart';
import '../widgets/user_data_table.dart';

class UsersAdminPage extends ConsumerStatefulWidget {
  const UsersAdminPage({super.key});

  @override
  ConsumerState<UsersAdminPage> createState() => _UsersAdminPageState();
}

class _UsersAdminPageState extends ConsumerState<UsersAdminPage> {
  String _searchQuery = '';
  String _selectedStatus = 'Todos los Estados';
  String _selectedRole = 'Todos los Roles';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userManagementProvider.notifier).getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userManagementProvider);
    final allUsers = state.users;

    final filteredUsers = allUsers.where((user) {
      final matchesSearch =
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _selectedStatus == 'Todos los Estados' ||
          (user.isActive && _selectedStatus == 'Habilitados') ||
          (!user.isActive && _selectedStatus == 'Deshabilitados');

      final matchesRole =
          _selectedRole == 'Todos los Roles' ||
          user.role.contains(_selectedRole);

      return matchesSearch && matchesStatus && matchesRole;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(
                  title: "Panel de Usuarios",
                  actionIcon: Icons.admin_panel_settings_rounded,
                ),
                const SizedBox(height: 32),
                _buildResponsiveStatsGrid(constraints.maxWidth, allUsers),
                const SizedBox(height: 48),
               // PEGA ESTE BLOQUE
Wrap(
  spacing: 16,        // Espacio horizontal entre título y buscador
  runSpacing: 16,     // Espacio vertical si el buscador salta a la línea de abajo
  alignment: WrapAlignment.spaceBetween,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    const Text(
      "Listado de Personal",
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
    ),
    UserSearchField(
      // Si la pantalla es pequeña (< 600px), el buscador ocupa todo el ancho
      width: constraints.maxWidth > 600 ? 350 : double.infinity,
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
                  onReset: () => setState(() {
                    _selectedStatus = 'Todos los Estados';
                    _selectedRole = 'Todos los Roles';
                    _searchQuery = '';
                  }),
                ),
                const SizedBox(height: 16),
                _tableCard(constraints.maxWidth, filteredUsers),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tableCard(double maxWidth, List<User> users) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 30),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: maxWidth < 1100 ? 1100 : maxWidth - 64,
            ),
            child: UserDataTable(
              users: users,
              onToggleStatus: (userId, val) {
                // CAMBIO AQUÍ: Ahora enviamos 'val' que es el estado del Switch
                ref
                    .read(userManagementProvider.notifier)
                    .toggleUserStatus(userId, val);
              },
              // ... dentro de UserDataTable
              onRoleChanged: (userId, newRoles) {
                ref.read(userManagementProvider.notifier).updateUserField(userId: userId, role: newRoles);
              },
              onScopeChanged: (userId, newScope) {
                ref.read(userManagementProvider.notifier).updateUserField(userId: userId, scope: newScope);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveStatsGrid(double maxWidth, List<User> users) {
    int col = maxWidth > 1200 ? 4 : (maxWidth > 750 ? 2 : 1);
    double w = (maxWidth - (16 * (col - 1)) - 64) / col;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _stat(w, "Total Usuarios", users.length.toString(), Icons.people_alt_rounded),
        _stat(w, "Técnicos", users.where((u) => u.role.contains('technician')).length.toString(), Icons.engineering_rounded),
        _stat(w, "Habilitados", users.where((u) => u.isActive).length.toString(), Icons.check_circle_rounded),
        _stat(w, "Deshabilitados", users.where((u) => !u.isActive).length.toString(), Icons.do_not_disturb_on_rounded),
      ],
    );
  }

  Widget _stat(double w, String l, String v, IconData i) => SizedBox(
    width: w,
    child: UserStatsCard(label: l, value: v, icon: i),
  );
}