import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/activos/page/assets_admin_page.dart';
import 'package:crv_reprosisa/features/gesti%C3%B3n_usuarios/pages/users_admin_page.dart';
import 'package:crv_reprosisa/features/inspections/models/inspector_row_ui.dart';
import 'package:flutter/material.dart';
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_admin.dart';
import '../../../../reports/Pages/reports_page.dart';
import '../../../../inspections/pages/inspections_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int selectedIndex = 0;

  final pages = [
    const _AdminHomePage(),
    InspectionPage(stats: _adminStats, actions: _adminActions, inspections: _adminInspections),
    const ReportsPage(),
    const AssetsAdminPage(),
    const UsersAdminPage()
  ];

  @override
  Widget build(BuildContext context) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Panel de Administración',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),
        Expanded(
          child: Center(child: Text('Estadísticas generales')),
        ),
      ],
    );
  }
}

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
