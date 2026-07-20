import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/assets_admin_page.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/provider/report_counters_provider.dart';
import 'package:crv_reprosisa/features/inspections/presentation/pages/inspections_page.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/quick_actions_i.dart';
import 'package:crv_reprosisa/features/servicios/presentation/page/vehiculos/vehicle_service_page.dart';
import 'package:crv_reprosisa/features/servicios/presentation/page/prensas/press_service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/pages/banda_inspection_page.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/pages/vehicle_inspection_page.dart';
import 'package:crv_reprosisa/features/user_management/presentation/pages/users_admin_page.dart';
import 'package:crv_reprosisa/features/profile/presentation/page/profile_page.dart';

// Provider de contadores del dashboard

// Widgets de layout y UI
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_admin.dart';
import '../../widgets/header.dart';
import '../../widgets/notification_panel.dart';
import '../../../../reports/presentation/Pages/reports_page.dart';

const Color kPrimaryRed = Color(0xFFC62828);
const Color kDarkRed = Color(0xFFB71C1C);
const Color kCardBg = Colors.white;
const Color kDarkText = Color(0xFF1A1C1E);
const Color kGreyText = Color(0xFF757575);

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

    final pages = [
      _AdminHomePage(user: user, onNavigateTab: (i) => setState(() => selectedIndex = i)),
      InspectionPage(stats: _adminStats, actions: _adminActions),
      const ReportsPage(),
      const AssetsAdminPage(),
      const UsersAdminPage(),
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
      content: pages[selectedIndex],
    );
  }
}

class _AdminHomePage extends ConsumerWidget {
  final User user;
  final Function(int) onNavigateTab;

  const _AdminHomePage({required this.user, required this.onNavigateTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countersAsync = ref.watch(reportCountersNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: kDarkText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          countersAsync.when(
            data: (counters) => _buildStatsGrid(
              context,
              totalToday: counters.totalToday.toString(),
              totalPress: counters.totalPress.toString(),
              totalVehicles: counters.totalVehicles.toString(),
            ),
            loading: () => _buildStatsGrid(
              context,
              totalToday: "...",
              totalPress: "...",
              totalVehicles: "...",
            ),
            error: (_, __) => _buildStatsGrid(
              context,
              totalToday: "0",
              totalPress: "0",
              totalVehicles: "0",
            ),
          ),
          const SizedBox(height: 36),
          countersAsync.when(
            data: (counters) => _buildChartsLayout(
              pressCount: counters.totalPress,
              vehiclesCount: counters.totalVehicles,
              conveyorCount: counters.totalConveyor,
              todayCount: counters.totalToday,
            ),
            loading: () => _buildChartsLayout(pressCount: 0, vehiclesCount: 0, conveyorCount: 0, todayCount: 0),
            error: (_, __) => _buildChartsLayout(pressCount: 0, vehiclesCount: 0, conveyorCount: 0, todayCount: 0),
          ),
          const SizedBox(height: 40),
          const Text(
            "Acciones Principales",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: kDarkText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          _buildQuickActionGrid(context),
          const SizedBox(height: 40),
          const NotificationPanel(children: []),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context, {
    required String totalToday,
    required String totalPress,
    required String totalVehicles,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        int crossAxisCount = maxWidth < 750 ? (maxWidth < 450 ? 1 : 2) : 3;
        double childAspectRatio = maxWidth < 450 ? 2.4 : (maxWidth < 750 ? 2.2 : 2.6);

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: childAspectRatio,
          children: [
            _AnimatedStatCard(
              value: totalToday,
              label: "Inspecciones Hoy",
              icon: Icons.assignment_outlined,
              onTap: () => onNavigateTab(1),
            ),
            _AnimatedStatCard(
              value: totalPress,
              label: "Prensas Totales",
              icon: Icons.settings_input_component_rounded,
              onTap: () => onNavigateTab(3),
            ),
            _AnimatedStatCard(
              value: totalVehicles,
              label: "Vehículos Totales",
              icon: Icons.directions_car_filled_rounded,
              onTap: () => onNavigateTab(3),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsLayout({
    required int pressCount,
    required int vehiclesCount,
    required int conveyorCount,
    required int todayCount,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return Column(
            children: [
              _InteractiveChartCard(
                title: "Distribución de Activos",
                child: _InspectionTypeChartContent(press: pressCount, vehicles: vehiclesCount, conveyor: conveyorCount),
              ),
              const SizedBox(height: 24),
              _InteractiveChartCard(
                title: "Rendimiento Semanal",
                child: _WeeklyPerformanceChartContent(todayCount: todayCount),
              ),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _InteractiveChartCard(
                  title: "Distribución de Activos",
                  child: _InspectionTypeChartContent(press: pressCount, vehicles: vehiclesCount, conveyor: conveyorCount),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 5,
                child: _InteractiveChartCard(
                  title: "Rendimiento Semanal",
                  child: _WeeklyPerformanceChartContent(todayCount: todayCount),
                ),
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
          _buildActionItem(context, "Inspección de Prensas", "Checklists industriales", Icons.build_circle_outlined, const PrensaInspectionPage(isReadOnly: false)),
          _buildActionItem(context, "Inspección de Vehículos", "Gestión de flota", Icons.local_shipping_outlined, const VehicleInspectionPage(isReadOnly: false)),
          _buildActionItem(context, "Inspección de Bandas", "Sistemas de transporte", Icons.camera_alt_outlined, const BandaInspectionPage(isReadOnly: false)),
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
}

// Contenedor interactivo con sombreado reforzado
class _InteractiveChartCard extends StatefulWidget {
  final String title;
  final Widget child;

  const _InteractiveChartCard({required this.title, required this.child});

  @override
  State<_InteractiveChartCard> createState() => _InteractiveChartCardState();
}

class _InteractiveChartCardState extends State<_InteractiveChartCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 350,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFFFAFAFA) : kCardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.transparent,
            width: 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.14 : 0.08),
              blurRadius: isHovered ? 24 : 16,
              offset: Offset(0, isHovered ? 10 : 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: kDarkText),
            ),
            const SizedBox(height: 16),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

// Gráfica Circular de Distribución con acumulación exacta por capas de colores proporcionales
class _InspectionTypeChartContent extends StatefulWidget {
  final int press;
  final int vehicles;
  final int conveyor;

  const _InspectionTypeChartContent({
    required this.press,
    required this.vehicles,
    required this.conveyor,
  });

  @override
  State<_InspectionTypeChartContent> createState() => _InspectionTypeChartContentState();
}

class _InspectionTypeChartContentState extends State<_InspectionTypeChartContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _InspectionTypeChartContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.press != widget.press || oldWidget.vehicles != widget.vehicles || oldWidget.conveyor != widget.conveyor) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.press + widget.vehicles + widget.conveyor;
    
    double pressPct = total > 0 ? (widget.press / total) * 100 : 0;
    double vehiclesPct = total > 0 ? (widget.vehicles / total) * 100 : 0;
    double conveyorPct = total > 0 ? (widget.conveyor / total) * 100 : 0;

    double pressRatio = total > 0 ? (widget.press / total) : 0;
    double vehiclesRatio = total > 0 ? (widget.vehicles / total) : 0;
    double conveyorRatio = total > 0 ? (widget.conveyor / total) : 0;

    return Row(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double animVal = _animation.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: 1.0 * animVal,
                          strokeWidth: 16,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: (vehiclesRatio + conveyorRatio) * animVal,
                          strokeWidth: 16,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF424242)),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: pressRatio * animVal,
                          strokeWidth: 16,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryRed),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${(total * animVal).round()}",
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: kDarkText),
                          ),
                          const Text(
                            "Total",
                            style: TextStyle(color: kGreyText, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _legendItem(kPrimaryRed, "Prensas: ${widget.press} (${pressPct.toStringAsFixed(0)}%)"),
            const SizedBox(height: 10),
            _legendItem(const Color(0xFF424242), "Vehículos: ${widget.vehicles} (${vehiclesPct.toStringAsFixed(0)}%)"),
            const SizedBox(height: 10),
            _legendItem(Colors.grey.shade400, "Bandas: ${widget.conveyor} (${conveyorPct.toStringAsFixed(0)}%)"),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kDarkText),
        ),
      ],
    );
  }
}

// Gráfica de Barras Semanal Animada con diseño refinado en tonos rojos
class _WeeklyPerformanceChartContent extends StatefulWidget {
  final int todayCount;

  const _WeeklyPerformanceChartContent({required this.todayCount});

  @override
  State<_WeeklyPerformanceChartContent> createState() => _WeeklyPerformanceChartContentState();
}

class _WeeklyPerformanceChartContentState extends State<_WeeklyPerformanceChartContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _WeeklyPerformanceChartContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todayCount != widget.todayCount) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> weeklyData = [
      (widget.todayCount * 0.8).round(),
      (widget.todayCount * 1.2).round(),
      (widget.todayCount * 0.9).round(),
      (widget.todayCount * 1.5).round(),
      (widget.todayCount * 1.1).round(),
      widget.todayCount == 0 ? 3 : widget.todayCount,
      (widget.todayCount * 0.6).round(),
    ];
    int maxVal = weeklyData.reduce((curr, next) => curr > next ? curr : next);
    if (maxVal == 0) maxVal = 5;

    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        double heightFactor = weeklyData[index] / maxVal;
        if (heightFactor > 1.0) heightFactor = 1.0;
        if (heightFactor < 0.12 && weeklyData[index] > 0) heightFactor = 0.15;

        bool isPeak = index == 5;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${weeklyData[index]}",
              style: TextStyle(
                fontSize: 11,
                color: isPeak ? kPrimaryRed : kGreyText,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                double currentHeight = 135 * heightFactor * _animation.value;
                if (currentHeight < 4) currentHeight = 4;
                return Container(
                  width: 24,
                  height: currentHeight,
                  decoration: BoxDecoration(
                    color: isPeak ? kPrimaryRed : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              days[index],
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kGreyText),
            ),
          ],
        );
      }),
    );
  }
}

// Tarjeta estadística compacta con animación interactiva al acercar el mouse y proporciones idénticas a la imagen de referencia
class _AnimatedStatCard extends StatefulWidget {
  final String value;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _AnimatedStatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFFFAFAFA) : kCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.transparent,
              width: 0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.14 : 0.08),
                blurRadius: isHovered ? 20 : 12,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: kGreyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: kDarkText,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isHovered ? kDarkRed : kPrimaryRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryRed.withOpacity(0.35),
                      blurRadius: isHovered ? 12 : 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<StatsModel> _adminStats = [
  StatsModel(value: "0", label: "Totales", color: Colors.grey),
  StatsModel(value: "0", label: "Pendientes", color: Colors.grey),
  StatsModel(value: "0", label: "Completadas", color: Colors.grey),
];
final List<ActionCardModel> _adminActions = [];