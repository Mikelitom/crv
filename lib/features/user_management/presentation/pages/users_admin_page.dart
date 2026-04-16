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

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userManagementProvider.notifier).getUsers());
  }

  void _openRequestsTray(List<User> pending) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Solicitudes Pendientes", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, size: 28)),
                ],
              ),
              const Divider(height: 40),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 900),
                        child: UserDataTable(
                          users: pending,
                          onToggleStatus: (id, v) => ref.read(userManagementProvider.notifier).toggleUserStatus(id, v),
                          onRoleChanged: (id, r) => ref.read(userManagementProvider.notifier).updateUserField(userId: id, role: r),
                          onScopeChanged: (id, s) async {
                            await ref.read(userManagementProvider.notifier).updateUserField(userId: id, scope: s);
                            if (mounted) Navigator.pop(context); 
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F3F4),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Cerrar", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userManagementProvider);
    final allUsers = state.users;

    final pendingUsers = allUsers.where((u) => u.scope.toUpperCase() == 'NONE').toList();
    final verifiedUsers = allUsers.where((u) => u.scope.toUpperCase() != 'NONE').toList();

    final filteredUsers = verifiedUsers.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'Todos los Estados' || (user.isActive && _selectedStatus == 'Habilitados') || (!user.isActive && _selectedStatus == 'Deshabilitados');
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(constraints.maxWidth > 600 ? 32 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: "Panel de Usuarios", actionIcon: Icons.admin_panel_settings_rounded),
                const SizedBox(height: 32),
                _buildResponsiveStatsGrid(constraints.maxWidth, allUsers),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Personal Verificado", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    _buildRequestButton(pendingUsers),
                  ],
                ),
                const SizedBox(height: 24),
                UserSearchField(width: double.infinity, query: _searchQuery, onChanged: (v) => setState(() => _searchQuery = v), onClear: () => setState(() => _searchQuery = '')),
                const SizedBox(height: 16),
                _tableCard(constraints.maxWidth, filteredUsers),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestButton(List<User> pending) {
    final bool hasRequests = pending.isNotEmpty;
    return InkWell(
      onTap: () => _openRequestsTray(pending),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasRequests ? const Color(0xFFC62828) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: hasRequests ? null : Border.all(color: Colors.black12),
          boxShadow: hasRequests ? [BoxShadow(color: const Color(0xFFC62828).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 5))] : [],
        ),
        child: Row(
          children: [
            Icon(Icons.notifications_active_rounded, color: hasRequests ? Colors.white : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text("${pending.length} SOLICITUDES", style: TextStyle(color: hasRequests ? Colors.white : Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _tableCard(double maxWidth, List<User> users) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(28), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25)]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: maxWidth < 1000 ? 1000 : maxWidth - 64),
            child: UserDataTable(
              users: users,
              onToggleStatus: (id, v) => ref.read(userManagementProvider.notifier).toggleUserStatus(id, v),
              onRoleChanged: (id, r) => ref.read(userManagementProvider.notifier).updateUserField(userId: id, role: r),
              onScopeChanged: (id, s) => ref.read(userManagementProvider.notifier).updateUserField(userId: id, scope: s),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveStatsGrid(double maxWidth, List<User> users) {
    int col = maxWidth > 1200 ? 4 : (maxWidth > 750 ? 2 : 1);
    double w = (maxWidth - (16 * (col - 1)) - (maxWidth > 600 ? 64 : 32)) / col;
    return Wrap(
      spacing: 16, runSpacing: 16,
      children: [
        _stat(w, "Total", users.length.toString(), Icons.people_rounded),
        _stat(w, "Activos", users.where((u) => u.isActive).length.toString(), Icons.verified_user_rounded),
        _stat(w, "Pendientes", users.where((u) => u.scope == 'NONE').length.toString(), Icons.pending_rounded),
        _stat(w, "Técnicos", users.where((u) => u.role.contains('technician')).length.toString(), Icons.engineering_rounded),
      ],
    );
  }

  Widget _stat(double w, String l, String v, IconData i) => SizedBox(width: w, child: UserStatsCard(label: l, value: v, icon: i));
}