import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_admin.dart';
import '../../widgets/header.dart'; // CustomHeader
import '../../../../inspections/Widgets/quick_actions_i.dart';
import '../../widgets/notification_panel.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/stats_card_dash_e.dart';
import '../../../../reports/Pages/reports_page.dart';
import '../../../../inspections/pages/inspections_page.dart';
import '../../../../activos/page/assets_admin_page.dart';
import '../../../../gestión_usuarios/pages/users_admin_page.dart';


class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Definimos las páginas aquí para que reconozcan los cambios de estado
    final pages = [
      const _AdminHomePage(),
      InspectionPage(stats: _adminStats, actions: _adminActions, inspections: _adminInspections),
      const ReportsPage(),
      const AssetsAdminPage(),
      const UsersAdminPage()
    ];

    return ResponsiveDashboardLayout(
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
  const _AdminHomePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER CON SALUDO DE ADMINISTRACIÓN
          const CustomHeader(
            title: "Dashboard",
            userName: "Administrador",
            actionIcon: Icons.admin_panel_settings_rounded,
          ),

          const SizedBox(height: 32),

          // 2. ESTADÍSTICAS OPERATIVAS (SEGUIDAS)
          const Text("Estadísticas Operativas", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
          const SizedBox(height: 16),
          _buildStatsGrid(context),

          const SizedBox(height: 32),

          // 3. GRÁFICOS Y TENDENCIAS (SIMULADOS SEGÚN IMAGEN)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildChartPlaceholder("Inspecciones por Tipo", Icons.pie_chart_outline)),
              const SizedBox(width: 20),
              Expanded(flex: 4, child: _buildChartPlaceholder("Rendimiento Semanal", Icons.bar_chart_rounded)),
            ],
          ),

          const SizedBox(height: 40),

          // 4. ACCIONES PRINCIPALES (LIMPIAS)
          const Text("Acciones Principales", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              double w = constraints.maxWidth;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildAction(w, context, "Inspección de Prensas", "Administrar checklists industriales", Icons.build_circle_outlined),
                  _buildAction(w, context, "Inspección de Vehículos", "Gestión de flota corporativa", Icons.local_shipping_outlined),
                  _buildAction(w, context, "Inspección de Bandas", "Control de sistemas de transporte", Icons.camera_alt_outlined),
                ],
              );
            }
          ),

          const SizedBox(height: 40),

          // 5. NOTIFICACIONES DEL SISTEMA
          const NotificationPanel(
            children: [
              NotificationItem(title: "Nueva inspección asignada", subtitle: "Hace 10 min", icon: Icons.person_pin_circle_outlined, iconColor: Colors.blue),
              NotificationItem(title: "Alerta: Vehículo V-001 retrasado", subtitle: "Hace 1 hora", icon: Icons.warning_amber_rounded, iconColor: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double cardWidth = (constraints.maxWidth - 60) / 4;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          SizedBox(width: cardWidth, child: const DashboardStatsCard(value: "24", sublabel: "+12%", label: "Inspecciones Hoy", icon: Icons.assignment_outlined)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(value: "12/15", sublabel: "80%", label: "Prensas Activas", icon: Icons.settings_input_component_rounded)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(value: "8/10", sublabel: "80%", label: "Vehículos OK", icon: Icons.check_circle_outline_rounded)),
          SizedBox(width: cardWidth, child: const DashboardStatsCard(value: "3", sublabel: "-2", label: "Reportes Pendientes", icon: Icons.error_outline_rounded)),
        ],
      );
    });
  }

  Widget _buildAction(double w, BuildContext context, String title, String desc, IconData icon) {
    double cardWidth = w > 900 ? (w / 3) - 14 : w;
    return SizedBox(width: cardWidth, child: QuickActionCard(title: title, description: desc, icon: icon, onTap: () {}));
  }

  Widget _buildChartPlaceholder(String title, IconData icon) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Expanded(child: Center(child: Icon(Icons.analytics_outlined, size: 80, color: Color(0xFFFDECEA)))),
        ],
      ),
    );
  }
}

// Datos funcionales para las otras páginasñ
final _adminStats = [
  StatsModel(value: "24", label: "Totales", color: Colors.blue),
  StatsModel(value: "5", label: "Pendientes", color: Colors.orange),
  StatsModel(value: "19", label: "Completadas", color: Colors.green),
];

final _adminActions = [
  ActionCardModel(
    title: "Nueva inspección",
    description: "Crear inspección completa",
    icon: Icons.add_circle_outline,
    onTap: () {
      // navegación a formulario admin
    },
  ),
  ActionCardModel(
    title: "Asignar técnico",
    description: "Asignar inspección",
    icon: Icons.person_add_alt,
    onTap: () {},
  ),
];

final List<InspectionRowUI> _adminInspections = [
  InspectionRowUI(
    id: '001',
    equipment: 'Banda A',
    date: '01/09/2025',
    state: 'Completada',
  ),
  InspectionRowUI(
    id: '002',
    equipment: 'Prensa B',
    date: '02/09/2025',
    state: 'Pendiente',
  ),
];