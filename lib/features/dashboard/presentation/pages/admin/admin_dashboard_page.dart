import 'package:crv_reprosisa/core/models/inspection_models.dart';
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
    const ReportsPage(),
    InspectionPage(stats: _adminStats, actions: _adminActions, tableHeaders: _inspectionHeaders, tableData: _inspectionData)
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

final _inspectionHeaders = [
  "ID",
  "Equipo",
  "Fecha",
  "Estado",
];

final _inspectionData = [
  ["001", "Banda A", "01/09/2025", "Completada"],
  ["002", "Prensa B", "02/09/2025", "Pendiente"],
];
