import 'package:flutter/material.dart';
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_technician.dart';
// Asegúrate de que las rutas de tus componentes sean las correctas
import '../../widgets/header.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/notification_panel.dart';

class TechnicianDashboardPage extends StatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  int selectedIndex = 0;

  final pages = [const _TechnicianDashboardPage()];

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
  const _TechnicianDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- WIDGET 1: HEADER DINÁMICO ---
        // En esta página pasamos 'userName' para que active el saludo.
        // En otras páginas, simplemente no pases ese parámetro.
        const CustomHeader(
          title: "Dashboard",
          userName: "Juan",
          actionIcon: Icons.insights,
          onActionTap: null, // Puedes pasar una función aquí
        ),

        const SizedBox(height: 32),
        const Text(
          'Acciones Principales',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // --- WIDGET 2: QUICK ACTIONS (SLIDER) ---
        SizedBox(
          height: 170, // Ajustado para dar espacio al botón
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              QuickActionCard(
                title: "Inspección de Prensas",
                description: "Realizar checklist de prensa industrial",
                onTap: () => print("Navegando a Prensas"),
              ),
              QuickActionCard(
                title: "Inspección de Unidades",
                description: "Realizar checklist de vehículos",
                onTap: () => print("Navegando a Unidades"),
              ),
              QuickActionCard(
                title: "Bandas Transportadoras",
                description: "Revisión de motores y bandas",
                onTap: () => print("Navegando a Bandas"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // --- WIDGETS 3 y 4: PANEL DE NOTIFICACIONES E ITEMS ---
        const NotificationPanel(
          children: [
            NotificationItem(
              title: "Checklist P-001 completado",
              subtitle: "Sistema • Hace 15 min",
              icon: Icons.camera_alt_outlined,
              iconColor: Colors.blue,
            ),
            NotificationItem(
              title: "Vehículo V-001 requiere correcciones",
              subtitle: "Supervisor • Hace 40 min",
              icon: Icons.local_shipping_outlined,
              iconColor: Colors.orange,
            ),
            NotificationItem(
              title: "Checklist B-002 rechazado",
              subtitle: "Alfredo Olivas • Hace 3 hr",
              icon: Icons.build_circle_outlined,
              iconColor: Colors.red,
            ),
          ],
        ),
      ],
    );
  }
}
