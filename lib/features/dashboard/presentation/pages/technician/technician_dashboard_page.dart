import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/layout/responsive_dashboard_layout.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/sidebar/sidebar_technician.dart';
import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:crv_reprosisa/features/inspections/pages/inspections_page.dart';
import 'package:crv_reprosisa/features/reports/Pages/reports_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../widgets/stats_card_dash_e.dart';
import '../../widgets/notification_panel.dart';
import '../../widgets/notification_item.dart';
import '../../../../inspections/Widgets/quick_actions_i.dart';

class TechnicianDashboardPage extends StatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  int selectedIndex = 0;

  final pages = [
    const _TechnicianDashboardPage(),
    InspectionPage(stats: _testStats, actions: _testActions, inspections: _testInspections),
    const ReportsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveDashboardLayout(
      sidebar: SidebarTechnician(
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

class _TechnicianDashboardPage extends StatelessWidget {
  // ignore: unused_element_parameter
  const _TechnicianDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material( // Solución global al error "No Material widget found"
      color: const Color(0xFFF8F9FA),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER DINÁMICO CON SALUDO
            const CustomHeader(
              title: "Dashboard",
              userName: "Juan",
              actionIcon: Icons.insights_rounded,
            ),

            const SizedBox(height: 32),

            // 2. ESTADÍSTICAS SEGUIDAS
            const Text("Estadísticas", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
            const SizedBox(height: 16),
            LayoutBuilder(builder: (context, constraints) {
              double spacing = 20.0;
              // Divide el ancho entre 3 restando los espacios para que queden seguidas
              double cardWidth = (constraints.maxWidth - (spacing * 2)) / 3;
              
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(width: cardWidth, child: const DashboardStatsCard(
                    value: "8", sublabel: "Este mes", label: "Mis Reportes", icon: Icons.bar_chart_rounded)),
                  SizedBox(width: cardWidth, child: const DashboardStatsCard(
                    value: "2", sublabel: "Por completar", label: "Pendientes", icon: Icons.access_time_rounded)),
                  SizedBox(width: cardWidth, child: const DashboardStatsCard(
                    value: "6", sublabel: "Este mes", label: "Aprobados", icon: Icons.check_box_outlined)),
                ],
              );
            }),

            const SizedBox(height: 40),

            // 3. ACCIONES PRINCIPALES (LIMPIAS, SIN AMARILLO)
            const Text("Acciones Principales", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E))),
            const SizedBox(height: 16),
            
            LayoutBuilder(builder: (context, constraints) {
              double width = constraints.maxWidth;
              return Wrap(
              
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildActionCard(width, "Inspección de Prensas", "Realizar checklist de prensa industrial", Icons.build_circle_outlined),
                  _buildActionCard(width, "Inspección de Vehículos", "Realizar checklist de flota vehicular", Icons.local_shipping_outlined),
                  _buildActionCard(width, "Inspección de Bandas", "Realizar checklist de bandas transportadoras", Icons.camera_alt_outlined),
                ],
              );

            } 
            ),

            const SizedBox(height: 40),

            // 4. PANEL DE NOTIFICACIONES
            const NotificationPanel(
              children: [
                NotificationItem(
                  title: "Checklist P-001 completado", 
                  subtitle: "Sistema • Hace 15 min", 
                  icon: Icons.camera_alt_outlined, 
                  iconColor: Colors.blue
                ),
                NotificationItem(
                  title: "Vehículo V-001 requiere correcciones", 
                  subtitle: "Supervisor • Hace 40 min", 
                  icon: Icons.local_shipping_outlined, 
                  iconColor: Colors.orange
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(double w, String title, String desc, IconData icon) {
    double cardWidth = w > 900 ? (w / 3) - 14 : w;
    return SizedBox(
      width: cardWidth,
      child: QuickActionCard(
        title: title,
        description: desc,
        icon: icon,
        onTap: () {},
      ),
    );
  }
}

final _testStats = [
  StatsModel(value: "24", label: "Totales", color: Colors.blue),
  StatsModel(value: "5", label: "Pendientes", color: Colors.orange),
  StatsModel(value: "19", label: "Completadas", color: Colors.green),
];

final _testActions = [
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

final List<InspectionRowUI> _testInspections = [
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