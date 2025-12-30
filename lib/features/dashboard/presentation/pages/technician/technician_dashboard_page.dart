import 'package:flutter/material.dart';
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_technician.dart';
import '../../widgets/header.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/notification_item.dart';
import '../../widgets/notification_panel.dart';

// ... tus imports anteriores e imports de los nuevos widgets

class TechnicianDashboardPage extends StatelessWidget {
  const TechnicianDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveDashboardLayout(
      sidebar: const SidebarTechnician(),
      content: SingleChildScrollView( // Cambiamos Padding por Scroll para que quepa todo
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WIDGET 1: HEADER
            DynamicHeader(
              title: "Bienvenido, Juan",
              icon: Icons.insights,
              onIconTap: () => print("Dashboard click"),
            ),
            
            const SizedBox(height: 32),
            const Text('Acciones Principales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // WIDGET 2: QUICK ACTIONS (SLIDER)
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  QuickActionCard(
                    title: "Inspección de Prensas",
                    description: "Realizar checklist de prensa industrial",
                    onTap: () {},
                  ),
                  QuickActionCard(
                    title: "Inspección de Unidades",
                    description: "Realizar checklist de vehículos",
                    onTap: () {},
                  ),
                  QuickActionCard(
                    title: "Bandas Transportadoras",
                    description: "Revisión de motores y bandas",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // WIDGETS 3 y 4: PANEL DE NOTIFICACIONES E ITEMS
            NotificationPanel(
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
        ),
      ),
    );
  }
}
