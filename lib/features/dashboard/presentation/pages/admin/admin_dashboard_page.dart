import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/assets/presentation/model/asset_models.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/assets_admin_page.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/inspections/presentation/models/inspector_row_ui.dart';
import 'package:crv_reprosisa/features/inspections/presentation/pages/inspections_page.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/quick_actions_i.dart';
import 'package:crv_reprosisa/features/catalogo/presentation/page/generic_catalog_page.dart';
import 'package:crv_reprosisa/features/servicios/page/prensas/press_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/pages/banda_inspection_page.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/pages/vehicle_inspection_page.dart';
import 'package:crv_reprosisa/features/user_management/presentation/pages/users_admin_page.dart';
import 'package:crv_reprosisa/features/profile/presentation/page/profile_page.dart';
import 'package:crv_reprosisa/features/servicios/page/vehiculos/vehicle_service_page.dart';
import 'package:flutter/material.dart';

// Importación de widgets de layout y UI
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_admin.dart';
import '../../widgets/header.dart';
import '../../widgets/notification_panel.dart';
import '../../widgets/stats_card_dash_e.dart';
import '../../../../reports/Pages/reports_page.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Listado de navegación
    final pages = [
      _AdminHomePage(user: user),
      InspectionPage(
        stats: _adminStats,
        actions: _adminActions,
        inspections: _adminInspections,
      ),
      const ReportsPage(),
      const AssetsAdminPage(),
      const UsersAdminPage(),
      GenericCatalogPage(type: AssetType.vehicle),
      GenericCatalogPage(type: AssetType.press),
      const VehicleServicePage(),
      const PressServicePage(),
      const ProfilePage(),
    ];

    return ResponsiveDashboardLayout(
      userName: user.name,
      userRole: user.role[0],
      sidebar: SidebarAdmin(
        selectedIndex: selectedIndex,
        onItemSelected: (i) => setState(() => selectedIndex = i),
      ),
      // Se eliminó el Padding fijo aquí para manejarlo dentro de cada página si es necesario
      content: pages[selectedIndex],
    );
  }
}

class _AdminHomePage extends StatelessWidget {
  final User user;
  const _AdminHomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader(
            title: "Dashboard",
            userName: user.name,
            actionIcon: Icons.admin_panel_settings_rounded,
          ),

          const SizedBox(height: 32),

          const Text(
            "Estadísticas Operativas",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 16),

          // GRID DE ESTADÍSTICAS RESPONSIVO
          _buildStatsGrid(context),

          const SizedBox(height: 32),

          // Layout de Gráficas Responsivo
          _buildChartsLayout(),

          const SizedBox(height: 40),

          const Text(
            "Acciones Principales",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildQuickActionGrid(context),

          const SizedBox(height: 40),

          const NotificationPanel(children: []),
        ],
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCCIÓN ---

  Widget _buildStatsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        // 1. Decidir número de columnas
        int crossAxisCount = maxWidth < 750 ? 2 : 4;

        // 2. Calcular Ratio dinámico para evitar overflows
        double aspectRatio;
        if (maxWidth < 400) {
          aspectRatio = 2.6; // Pantallas mini
        } else if (maxWidth < 750) {
          aspectRatio = 2.3; // Celulares estándar
        } else {
          aspectRatio = 1.8; // Escritorio/Tablet
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
          children: [
            _statItem("0", "0%", "Inspecciones Hoy", Icons.assignment_outlined),
            _statItem("0/0", "0%", "Prensas Activas", Icons.settings_input_component_rounded),
            _statItem("0/0", "0%", "Vehículos OK", Icons.check_circle_outline_rounded),
            _statItem("0", "0", "Reportes Pendientes", Icons.error_outline_rounded),
          ],
        );
      },
    );
  }

  // Función para envolver la tarjeta en un FittedBox preventivo
  Widget _statItem(String val, String sub, String lab, IconData ic) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 160,
        height: 70,
        child: DashboardStatsCard(
          value: val,
          sublabel: sub,
          label: lab,
          icon: ic,
        ),
      ),
    );
  }

  Widget _buildChartsLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            children: [
              _buildChartPlaceholder("Inspecciones por Tipo", Icons.pie_chart_outline),
              const SizedBox(height: 20),
              _buildChartPlaceholder("Rendimiento Semanal", Icons.bar_chart_rounded),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildChartPlaceholder("Inspecciones por Tipo", Icons.pie_chart_outline),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: _buildChartPlaceholder("Rendimiento Semanal", Icons.bar_chart_rounded),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 900;
        
        final actions = [
          _buildActionItem(context, "Inspección de Prensas", "Checlists industriales", Icons.build_circle_outlined, PrensaInspectionPage()),
          _buildActionItem(context, "Inspección de Vehículos", "Gestión de flota", Icons.local_shipping_outlined, VehicleInspectionPage()),
          _buildActionItem(context, "Inspección de Bandas", "Sistemas de transporte", Icons.camera_alt_outlined, const BandaInspectionPage()),
        ];

        if (isWide) {
          return IntrinsicHeight(
            child: Row(
              children: actions.map((a) => Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: a,
              ))).toList(),
            ),
          );
        }

        return Column(
          children: actions.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: a,
          )).toList(),
        );
      },
    );
  }

  Widget _buildActionItem(BuildContext context, String title, String desc, IconData icon, Widget target) {
    return QuickActionCard(
      title: title,
      description: desc,
      icon: icon,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
    );
  }

  Widget _buildChartPlaceholder(String title, IconData icon) {
    return Container(
      height: 320, 
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Center(
              child: Icon(icon, size: 80, color: const Color(0xFFFDECEA)),
            ),
          ),
        ],
      ),
    );
  }
}

// --- DATOS INICIALES ---
final List<StatsModel> _adminStats = [
  StatsModel(value: "0", label: "Totales", color: Colors.grey),
  StatsModel(value: "0", label: "Pendientes", color: Colors.grey),
  StatsModel(value: "0", label: "Completadas", color: Colors.grey),
];
final List<ActionCardModel> _adminActions = [];
final List<InspectionRowUI> _adminInspections = [];