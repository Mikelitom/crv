import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'sidebar_container.dart';
import 'sidebar_header.dart';
import 'sidebar_item.dart';

class SidebarTechnician extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SidebarTechnician({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final bool isVerified = user != null && 
                            user.scope.trim().toUpperCase() != 'NONE';

    return SidebarContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SidebarHeader(),
          const SizedBox(height: 16),

          // --- ESTADO DE AUTORIZACIÓN (Solo si NO está verificado) ---
          if (!isVerified) 
            _buildWaitingStatus(),

          const SizedBox(height: 8),

          // --- SECCIÓN DE NAVEGACIÓN PROTEGIDA ---
          if (isVerified) ...[
            SidebarItem(
              icon: Icons.dashboard_outlined,
              label: 'Dashboard',
              isActive: selectedIndex == 0,
              onTap: () => onItemSelected(0),
            ),
            SidebarItem(
              icon: Icons.assignment_outlined,
              label: 'Reportes',
              badgeCount: 3,
              isActive: selectedIndex == 1,
              onTap: () => onItemSelected(1),
            ),
            SidebarItem(
              icon: Icons.bar_chart_outlined,
              label: 'Inspecciones',
              isActive: selectedIndex == 2,
              onTap: () => onItemSelected(2),
            ),
          ],

          // --- PERFIL (Siempre visible) ---
          SidebarItem(
            icon: Icons.person_outline,
            label: 'Mi Perfil',
            isActive: selectedIndex == 3,
            onTap: () => onItemSelected(3),
          ),

          const Spacer(),

          // ÚNICO BOTÓN DE SALIDA AL FINAL
          SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Cerrar Sesión',
            onTap: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
          const SizedBox(height: 12)
        ],
      ),
    );
  }

  Widget _buildWaitingStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "En espera de autorización",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}