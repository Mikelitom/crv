import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/assets_admin_page.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/inspections/presentation/models/inspector_row_ui.dart';
import 'package:crv_reprosisa/features/inspections/presentation/pages/inspections_page.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/quick_actions_i.dart';
import 'package:crv_reprosisa/features/catalogo/presentation/page/catalogo_page.dart';
import 'package:crv_reprosisa/features/servicios/page/prensas/press_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/pages/banda_inspection_page.dart';
import 'package:crv_reprosisa/features/prensas_industriales/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/pages/vehicle_inspection_page.dart';
import 'package:crv_reprosisa/features/user_management/presentation/pages/users_admin_page.dart';
import 'package:crv_reprosisa/features/profile/presentation/page/profile_page.dart';
import 'package:crv_reprosisa/features/servicios/page/vehiculos/vehicle_service_page.dart'
    hide PressServicePage;
import 'package:flutter/material.dart';
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
    // Obtain user from authState
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Definición de páginas con el tipo explícito para evitar errores de parámetro
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
      const GenericCatalogPage(type: AssetType.vehiculo),
      const GenericCatalogPage(type: AssetType.prensa),
      const VehicleServicePage(),
      const PressServicePage(),
      // Tipo definido para evitar errores
      const ProfilePage(),
    ];

    return ResponsiveDashboardLayout(
      userName: user.name,
      userRole: user.role[0],
      sidebar: SidebarAdmin(
        selectedIndex: selectedIndex,
        onItemSelected: (i) => setState(() => selectedIndex = i),
      ),
      content: Padding(
        padding: const EdgeInsets.all(24),
        child: pages[selectedIndex],
      ),
    );
  }
}

class _AdminHomePage extends StatelessWidget {
  final User user;
  const _AdminHomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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

          _buildStatsGrid(context),

          const SizedBox(height: 32),

          // Layout de Gráficas Responsivo
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return Column(
                  children: [
                    _buildChartPlaceholder(
                      "Inspecciones por Tipo",
                      Icons.pie_chart_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildChartPlaceholder(
                      "Rendimiento Semanal",
                      Icons.bar_chart_rounded,
                    ),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildChartPlaceholder(
                        "Inspecciones por Tipo",
                        Icons.pie_chart_outline,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: _buildChartPlaceholder(
                        "Rendimiento Semanal",
                        Icons.bar_chart_rounded,
                      ),
                    ),
                  ],
                );
              }
            },
          ),

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

  Widget _buildStatsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        // Ajuste de columnas según el ancho disponible
        int crossAxisCount = maxWidth < 750 ? 2 : 4;

        // ASPECT RATIO CORREGIDO: Mayor valor vertical para evitar desbordamiento inferior
        double aspectRatio = maxWidth < 750 ? 3.0 : 1.8;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: aspectRatio,
          children: const [
            DashboardStatsCard(
              value: "0",
              sublabel: "0%",
              label: "Inspecciones Hoy",
              icon: Icons.assignment_outlined,
            ),
            DashboardStatsCard(
              value: "0/0",
              sublabel: "0%",
              label: "Prensas Activas",
              icon: Icons.settings_input_component_rounded,
            ),
            DashboardStatsCard(
              value: "0/0",
              sublabel: "0%",
              label: "Vehículos OK",
              icon: Icons.check_circle_outline_rounded,
            ),
            DashboardStatsCard(
              value: "0",
              sublabel: "0",
              label: "Reportes Pendientes",
              icon: Icons.error_outline_rounded,
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildActionItem(
                    context,
                    "Inspección de Prensas",
                    "Administrar checklists industriales",
                    Icons.build_circle_outlined,
                    const PrensaInspectionPage(),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildActionItem(
                    context,
                    "Inspección de Vehículos",
                    "Gestión de flota corporativa",
                    Icons.local_shipping_outlined,
                    VehicleInspectionPage(),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildActionItem(
                    context,
                    "Inspección de Bandas",
                    "Control de sistemas de transporte",
                    Icons.camera_alt_outlined,
                    const BandaInspectionPage(),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildActionItem(
              context,
              "Inspección de Prensas",
              "Administrar checklists",
              Icons.build_circle_outlined,
              const PrensaInspectionPage(),
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context,
              "Inspección de Vehículos",
              "Gestión de flota",
              Icons.local_shipping_outlined,
              VehicleInspectionPage(),
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context,
              "Inspección de Bandas",
              "Control de transporte",
              Icons.camera_alt_outlined,
              const BandaInspectionPage(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    Widget target,
  ) {
    return QuickActionCard(
      title: title,
      description: desc,
      icon: icon,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => target),
      ),
    );
  }

  Widget _buildChartPlaceholder(String title, IconData icon) {
    return Container(
      height: 320, // Altura aumentada para evitar Bottom Overflow
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Expanded(
            child: Center(
              child: Icon(
                Icons.analytics_outlined,
                size: 80,
                color: Color(0xFFFDECEA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Listas inicializadas como vacías para evitar el error de RangeError
final List<StatsModel> _adminStats = [
  StatsModel(value: "0", label: "Totales", color: Colors.grey),
  StatsModel(value: "0", label: "Pendientes", color: Colors.grey),
  StatsModel(value: "0", label: "Completadas", color: Colors.grey),
];
final List<ActionCardModel> _adminActions = [];
final List<InspectionRowUI> _adminInspections = [];
