import 'dart:math' as math;
import 'package:crv_reprosisa/core/models/inspection_models.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/assets_admin_page.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/provider/report_counters_provider.dart';
import 'package:crv_reprosisa/features/inspections/presentation/pages/inspections_page.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/quick_actions_i.dart';
import 'package:crv_reprosisa/features/reports/presentation/provider/reports_provider.dart';
import 'package:crv_reprosisa/features/servicios/presentation/page/vehiculos/vehicle_service_page.dart';
import 'package:crv_reprosisa/features/servicios/presentation/page/prensas/press_service_page.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_usage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/pages/banda_inspection_page.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/pages/vehicle_inspection_page.dart';
import 'package:crv_reprosisa/features/user_management/presentation/pages/users_admin_page.dart';
import 'package:crv_reprosisa/features/profile/presentation/page/profile_page.dart';

// Imports añadidos para soportar el provider de estadísticas de reportes
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/dashboard/data/datasource/report_stats_remote_datasource.dart';
import 'package:crv_reprosisa/features/dashboard/data/model/report_stats_model.dart';
import 'package:crv_reprosisa/features/dashboard/data/repository/report_stats_repository_impl.dart';

// Widgets de layout y UI
import '../../layout/responsive_dashboard_layout.dart';
import '../../widgets/sidebar/sidebar_admin.dart';
import '../../widgets/header.dart';
import '../../widgets/notification_panel.dart';
import '../../../../reports/presentation/Pages/reports_page.dart';

const Color kPrimaryRed = Color(0xFFC62828);
const Color kCardBg = Colors.white;
const Color kDarkText = Color(0xFF1A1C1E);
const Color kGreyText = Color(0xFF757575);

// Proveedor de Datasource
final reportStatsRemoteDatasourceProvider = Provider<ReportStatsRemoteDatasource>((ref) {
  return ReportStatsRemoteDatasourceImpl(ref.watch(dioProvider));
});

// Proveedor de Repositorio
final reportStatsRepositoryProvider = Provider<ReportStatsRepository>((ref) {
  return ReportStatsRepositoryImpl(ref.watch(reportStatsRemoteDatasourceProvider));
});

// FutureProvider final para consumir las estadísticas de reportes en la UI
final reportStatsProvider = FutureProvider<List<ReportStatModel>>((ref) async {
  final repository = ref.watch(reportStatsRepositoryProvider);
  final result = await repository.getReportStats();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});

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
      _AdminHomePage(
        user: user,
        onNavigateTab: (i) => setState(() => selectedIndex = i),
      ),
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

class _AdminHomePage extends ConsumerStatefulWidget {
  final User user;
  final Function(int) onNavigateTab;

  const _AdminHomePage({required this.user, required this.onNavigateTab});

  @override
  ConsumerState<_AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<_AdminHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reportsNotifierProvider.notifier).pendingReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final countersAsync = ref.watch(reportCountersNotifierProvider);
    final reports = ref.watch(reportsNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader(
            title: "Dashboard",
            userName: widget.user.name,
            actionIcon: Icons.admin_panel_settings_rounded,
          ),
          const SizedBox(height: 16),
          const Text(
            "Estadísticas Operativas",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kDarkText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          countersAsync.when(
            data: (counters) => _buildStatsGrid(
              context,
              totalToday: counters.totalToday.toString(),
              totalPress: counters.totalPress.toString(),
              totalVehicles: counters.totalVehicles.toString(),
              totalPending: reports.pendingReports.length.toString(),
            ),
            loading: () => _buildStatsGrid(
              context,
              totalToday: "...",
              totalPress: "...",
              totalVehicles: "...",
              totalPending: "..."
            ),
            error: (_, __) => _buildStatsGrid(
              context,
              totalToday: "0",
              totalPress: "0",
              totalVehicles: "0",
              totalPending: "0"
            ),
          ),
          const SizedBox(height: 16),
          const _BuildingChartsContainer(),
          const SizedBox(height: 16),
          const Text(
            "Acciones Principales",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kDarkText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickActionGrid(context),
          const SizedBox(height: 16),
          const NotificationPanel(children: []),
        ],
      ),
    );
  }

  // Solución definitiva al desbordamiento vertical de 0.286px usando un diseño de filas/columnas explícito y seguro sin GridView
  Widget _buildStatsGrid(
    BuildContext context, {
    required String totalToday,
    required String totalPress,
    required String totalVehicles,
    required String totalPending,
  }) {
    final cards = [
      _AnimatedStatCard(
        value: totalToday,
        label: "Inspecciones Hoy",
        icon: Icons.assignment_outlined,
        onTap: () => widget.onNavigateTab(1),
      ),
      _AnimatedStatCard(
        value: totalPress,
        label: "Prensas Totales",
        icon: Icons.settings_input_component_rounded,
        onTap: () => widget.onNavigateTab(3),
      ),
      _AnimatedStatCard(
        value: totalVehicles,
        label: "Vehículos Totales",
        icon: Icons.directions_car_filled_rounded,
        onTap: () => widget.onNavigateTab(3),
      ),
      _AnimatedStatCard(
        value: totalPending,
        label: "Reportes Pendientes",
        icon: Icons.mark_email_unread_outlined,
        onTap: () => widget.onNavigateTab(2),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth >= 950;

        if (isWide) {
          // Escritorio: 4 tarjetas en una sola fila limpia
          return Row(
            children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: c))).toList(),
          );
        } else {
          // Móvil / Tablet: 2 filas con 2 tarjetas cada una, garantizando cero desbordamientos verticales
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[3]),
                ],
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
          _buildActionItem(
            context,
            "Inspección de Prensas",
            "Checklists industriales",
            Icons.build_circle_outlined,
            const PrensaInspectionPage(isReadOnly: false),
          ),
          _buildActionItem(
            context,
            "Inspección de Vehículos",
            "Gestión de flota",
            Icons.local_shipping_outlined,
            const VehicleInspectionPage(isReadOnly: false),
          ),
          _buildActionItem(
            context,
            "Inspección de Bandas",
            "Sistemas de transporte",
            Icons.camera_alt_outlined,
            const BandaInspectionPage(isReadOnly: false),
          ),
        ];

        if (isWide) {
          return IntrinsicHeight(
            child: Row(
              children: actions
                  .map(
                    (a) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: a,
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }

        return Column(
          children: actions
              .map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: a,
                ),
              )
              .toList(),
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
}

// Contenedor principal adaptable mediante Wrap para que las tarjetas se acomoden perfectamente según pantalla (Tablet y Desktop)
class _BuildingChartsContainer extends ConsumerWidget {
  const _BuildingChartsContainer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(reportStatsProvider);

    return statsAsync.when(
      data: (statsList) => LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          bool isDesktop = width >= 1250;
          double cardWidth = isDesktop ? (width - 32) / 3 : (width > 700 ? (width - 16) / 2 : width);

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: cardWidth,
                child: _InteractiveChartCard(
                  title: "1. Inspecciones por Tipo",
                  subtitle: "Distribución por tipo de activo",
                  child: _InspectionTypeChartContent(stats: statsList),
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: _InteractiveWeeklyChartCard(
                  stats: statsList,
                ),
              ),
              SizedBox(
                width: cardWidth,
                child: _InteractiveMaintenanceCard(
                  onNavigateToPress: (pressId) {},
                ),
              ),
            ],
          );
        },
      ),
      loading: () => const SizedBox(
        height: 355,
        child: Center(child: CircularProgressIndicator(color: kPrimaryRed)),
      ),
      error: (err, _) => SizedBox(
        height: 355,
        child: Center(
          child: Text(
            "Error al cargar gráficas: $err",
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
        ),
      ),
    );
  }
}

// Tarjeta 1: Inspecciones por Tipo
class _InteractiveChartCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _InteractiveChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 355,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFFFAFAFA) : kCardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isHovered ? kPrimaryRed.withOpacity(0.12) : Colors.black.withOpacity(0.04),
              blurRadius: isHovered ? 24 : 12,
              offset: Offset(0, isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: kGreyText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

// Tarjeta 2: Reportes Totales
class _InteractiveWeeklyChartCard extends StatefulWidget {
  final List<ReportStatModel> stats;

  const _InteractiveWeeklyChartCard({required this.stats});

  @override
  State<_InteractiveWeeklyChartCard> createState() => _InteractiveWeeklyChartCardState();
}

class _InteractiveWeeklyChartCardState extends State<_InteractiveWeeklyChartCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  String selectedPeriod = 'Últimos 7 días';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _InteractiveWeeklyChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats != widget.stats) {
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
    final now = DateTime.now();
    List<int> dataValues = [];
    List<String> labels = [];

    if (selectedPeriod == 'Últimos 7 días') {
      List<DateTime> days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
      
      labels = days.map((d) {
        switch (d.weekday) {
          case 1:
            return 'Lun';
          case 2:
            return 'Mar';
          case 3:
            return 'Mié';
          case 4:
            return 'Jue';
          case 5:
            return 'Vie';
          case 6:
            return 'Sáb';
          case 7:
            return 'Dom';
          default:
            return '';
        }
      }).toList();

      dataValues = days.map((day) {
        return widget.stats.where((stat) {
          return stat.inspectionDate.year == day.year &&
                 stat.inspectionDate.month == day.month &&
                 stat.inspectionDate.day == day.day;
        }).length;
      }).toList();

    } else if (selectedPeriod == 'Último mes') {
      labels = ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Actual'];
      dataValues = List.generate(5, (index) {
        int startDay = (4 - index) * 7;
        int endDay = startDay + 7;
        return widget.stats.where((stat) {
          final diff = now.difference(stat.inspectionDate).inDays;
          return diff >= startDay && diff < endDay;
        }).length;
      }).reversed.toList();

    } else {
      labels = ['Q1', 'Q2', 'Q3', 'Q4', 'Pasado', 'Actual'];
      dataValues = List.generate(6, (index) {
        return widget.stats.where((stat) {
          return stat.inspectionDate.year == now.year;
        }).length;
      });
    }

    int maxVal = dataValues.isNotEmpty ? dataValues.reduce((curr, next) => curr > next ? curr : next) : 0;
    if (maxVal == 0) maxVal = 5;
    int totalReports = dataValues.fold(0, (sum, val) => sum + val);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 355,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFFFAFAFA) : kCardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isHovered ? kPrimaryRed.withOpacity(0.12) : Colors.black.withOpacity(0.04),
              blurRadius: isHovered ? 24 : 12,
              offset: Offset(0, isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "2. Reportes Totales",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: kDarkText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedPeriod == 'Últimos 7 días' ? "Rendimiento semanal" : "Histórico por periodo",
                      style: const TextStyle(
                        fontSize: 11,
                        color: kGreyText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      icon: const Icon(Icons.arrow_drop_down, size: 16, color: kGreyText),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kDarkText),
                      items: ['Últimos 7 días', 'Último mes', 'Último año'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedPeriod = newValue;
                            _controller.forward(from: 0.0);
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dataValues.length, (index) {
                  double heightFactor = dataValues[index] / maxVal;
                  if (heightFactor > 1.0) heightFactor = 1.0;
                  if (heightFactor < 0.12 && dataValues[index] > 0) heightFactor = 0.15;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${dataValues[index]}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: kPrimaryRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            double currentHeight = 110 * heightFactor * _animation.value;
                            if (currentHeight < 4) currentHeight = 4;
                            return Container(
                              width: dataValues.length > 6 ? 11 : 15,
                              height: currentHeight,
                              decoration: BoxDecoration(
                                color: kPrimaryRed,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: kGreyText,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bar_chart_rounded, size: 14, color: kGreyText),
                      const SizedBox(width: 6),
                      Text("Total reportes: $totalReports", style: const TextStyle(color: kDarkText, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: kPrimaryRed, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      const Text("Actividad en curso", style: TextStyle(color: kGreyText, fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tarjeta 3: Mantenimientos
class _InteractiveMaintenanceCard extends ConsumerStatefulWidget {
  final Function(String pressId) onNavigateToPress;

  const _InteractiveMaintenanceCard({required this.onNavigateToPress});

  @override
  ConsumerState<_InteractiveMaintenanceCard> createState() => _InteractiveMaintenanceCardState();
}

class _InteractiveMaintenanceCardState extends ConsumerState<_InteractiveMaintenanceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(globalPendingMaintenanceProvider);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 355,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFFFAFAFA) : kCardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isHovered ? kPrimaryRed.withOpacity(0.12) : Colors.black.withOpacity(0.04),
              blurRadius: isHovered ? 24 : 12,
              offset: Offset(0, isHovered ? 8 : 4),
            ),
          ],
        ),
        child: pendingAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryRed)),
          error: (err, _) => Center(child: Text("Error: $err")),
          data: (orders) {
            final pendingOrders = orders.where((o) => o['status'] == 'PENDING').toList();
            final progressCount = orders.where((o) => o['status'] == 'IN_PROGRESS').length;
            final pendingCount = pendingOrders.length;
            
            final pressOrders = pendingOrders.where((o) => (o['press_id'] ?? '').toString().isNotEmpty).length;
            final vehicleOrders = pendingCount - pressOrders;
            final lastOrder = pendingOrders.isNotEmpty ? pendingOrders.first : null;
            final grandTotal = pendingCount + progressCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "3. Mantenimientos",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: kDarkText,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Órdenes operativas por activo",
                          style: TextStyle(
                            fontSize: 11,
                            color: kGreyText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text("ACTIVO", style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: CustomPaint(
                      painter: _MultiSegmentRingPainter(
                        pressVal: pressOrders.toDouble(),
                        vehicleVal: vehicleOrders.toDouble(),
                        progressVal: progressCount.toDouble(),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$grandTotal",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kDarkText, height: 1),
                            ),
                            const SizedBox(height: 1),
                            const Text(
                              "Total",
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: kGreyText, height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    _buildMetricRow("Prensas", pressOrders, kPrimaryRed),
                    const SizedBox(height: 6),
                    _buildMetricRow("Vehículos", vehicleOrders, const Color(0xFF37474F)),
                    const SizedBox(height: 6),
                    _buildMetricRow("En Proceso", progressCount, Colors.blueAccent),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: lastOrder != null
                      ? MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => widget.onNavigateToPress(lastOrder['press_id'] ?? ''),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: kPrimaryRed.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.warning_amber_rounded, color: kPrimaryRed, size: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Orden Prioritaria", style: TextStyle(color: kPrimaryRed, fontSize: 8, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 1),
                                        Text("#${lastOrder['order_number']}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: kDarkText)),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_rounded, size: 12, color: kPrimaryRed),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text("No hay órdenes pendientes", style: TextStyle(color: kGreyText, fontSize: 10, fontWeight: FontWeight.w700)),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: kDarkText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          "$value",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Pintor personalizado para rellenar la dona proporcionalmente según la cantidad de cada categoría
class _MultiSegmentRingPainter extends CustomPainter {
  final double pressVal;
  final double vehicleVal;
  final double progressVal;

  _MultiSegmentRingPainter({
    required this.pressVal,
    required this.vehicleVal,
    required this.progressVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 6.0;
    final Rect rect = Offset(strokeWidth / 2, strokeWidth / 2) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, backgroundPaint);

    double total = pressVal + vehicleVal + progressVal;
    if (total <= 0) return;

    double startAngle = -math.pi / 2;

    void drawSegment(double value, Color color) {
      if (value <= 0) return;
      double sweepAngle = (value / total) * 2 * math.pi;
      final Paint segmentPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, segmentPaint);
      startAngle += sweepAngle;
    }

    drawSegment(pressVal, kPrimaryRed);
    drawSegment(vehicleVal, const Color(0xFF37474F));
    drawSegment(progressVal, Colors.blueAccent);
  }

  @override
  bool shouldRepaint(covariant _MultiSegmentRingPainter oldDelegate) {
    return oldDelegate.pressVal != pressVal ||
        oldDelegate.vehicleVal != vehicleVal ||
        oldDelegate.progressVal != progressVal;
  }
}

// Widget de Inspecciones por Tipo
class _InspectionTypeChartContent extends StatelessWidget {
  final List<ReportStatModel> stats;

  const _InspectionTypeChartContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    int conveyorCount = 0;
    int vehicleCount = 0;
    int pressCount = 0;

    for (var stat in stats) {
      final type = stat.reportType.toLowerCase().trim();
      if (type.contains('conveyor') || type.contains('banda')) {
        conveyorCount++;
      } else if (type.contains('vehicle') || type.contains('vehiculo') || type.contains('vehículo')) {
        vehicleCount++;
      } else if (type.contains('press') || type.contains('prensa')) {
        pressCount++;
      }
    }

    int total = conveyorCount + vehicleCount + pressCount;
    if (total == 0) total = 1;

    double conveyorRatio = conveyorCount / total;
    double vehicleRatio = vehicleCount / total;
    double pressRatio = pressCount / total;

    double conveyorPct = (conveyorCount / total) * 100;
    double vehiclePct = (vehicleCount / total) * 100;
    double pressPct = (pressCount / total) * 100;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAssetProgressRow("Bandas de Transporte", conveyorCount, conveyorPct, conveyorRatio, kPrimaryRed),
        const SizedBox(height: 10),
        _buildAssetProgressRow("Flota de Vehículos", vehicleCount, vehiclePct, vehicleRatio, const Color(0xFF37474F)),
        const SizedBox(height: 10),
        _buildAssetProgressRow("Prensas Industriales", pressCount, pressPct, pressRatio, Colors.grey.shade500),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total de activos inspeccionados", style: TextStyle(color: kGreyText, fontSize: 10.5, fontWeight: FontWeight.w700)),
              Text("$total registros", style: const TextStyle(color: kDarkText, fontSize: 11, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetProgressRow(String title, int count, double percentage, double ratio, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: kDarkText, fontSize: 11, fontWeight: FontWeight.w800)),
            Text("$count (${percentage.toStringAsFixed(0)}%)", style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// Tarjeta estadística compacta
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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFFFAFAFA) : kCardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isHovered 
                    ? kPrimaryRed.withOpacity(0.12) 
                    : Colors.black.withOpacity(0.04),
                blurRadius: isHovered ? 16 : 8,
                offset: Offset(0, isHovered ? 5 : 2),
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
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: isHovered ? kPrimaryRed : kGreyText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: kDarkText,
                        letterSpacing: -1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isHovered ? kPrimaryRed : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: isHovered ? Colors.white : kPrimaryRed,
                  size: 14,
                ),
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