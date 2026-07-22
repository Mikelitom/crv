import 'dart:math' as math;
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/inspections/presentation/provider/inspection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/layout/responsive_dashboard_layout.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/sidebar/sidebar_technician.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/header.dart';
import 'package:crv_reprosisa/features/dashboard/presentation/widgets/notification_panel.dart';
import 'package:crv_reprosisa/features/inspections/presentation/widgets/quick_actions_i.dart';
import 'package:crv_reprosisa/features/profile/presentation/page/profile_page.dart';
import 'package:crv_reprosisa/features/inspections/presentation/pages/inspections_page.dart';
import 'package:crv_reprosisa/features/reports/presentation/Pages/reports_page.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/pages/banda_inspection_page.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/Pages/prensa_inspection.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/pages/vehicle_inspection_page.dart';

const Color kPrimaryRed = Color(0xFFC62828);
const Color kCardBg = Colors.white;
const Color kDarkText = Color(0xFF1A1C1E);
const Color kGreyText = Color(0xFF757575);

final technicianInspectionsProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getMyInspectionsUseCaseProvider);
  final result = await useCase();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (inspections) => inspections,
  );
});

class TechnicianDashboardPage extends ConsumerStatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  ConsumerState<TechnicianDashboardPage> createState() =>
      _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState
    extends ConsumerState<TechnicianDashboardPage> {
  int _internalIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user;
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kPrimaryRed)),
      );
    }

    final bool isVerified = user.scope.trim().toUpperCase() != 'NONE';
    final int activeIndex = isVerified ? _internalIndex : 3;

    final pages = [
      _TechnicianHomePage(
        user: user,
        onNavigateTab: (i) => setState(() => _internalIndex = i),
      ),
      const ReportsPage(),
      const InspectionPage(
        stats: [], 
        actions: [],
      ),
      const ProfilePage(),
    ];

    return ResponsiveDashboardLayout(
      userName: user.name,
      userRole: user.role.isNotEmpty ? user.role[0] : 'Técnico',
      sidebar: SidebarTechnician(
        selectedIndex: activeIndex,
        onItemSelected: (i) {
          if (isVerified) {
            setState(() => _internalIndex = i);
          }
        },
      ),
      content: pages[activeIndex],
    );
  }
}

class _TechnicianHomePage extends ConsumerWidget {
  final User user;
  final Function(int) onNavigateTab;

  const _TechnicianHomePage({required this.user, required this.onNavigateTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionsAsync = ref.watch(technicianInspectionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader(
            title: "Dashboard",
            userName: user.name,
            actionIcon: Icons.engineering_rounded,
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
          inspectionsAsync.when(
            data: (inspections) {
              final total = inspections.length;
              final inProgress = inspections.where((i) {
                final state = (i.state ?? '').toUpperCase();
                return state == 'IN_PROGRESS' || state == 'EN PROGRESO';
              }).length;
              final inReview = inspections.where((i) {
                final state = (i.state ?? '').toUpperCase();
                return state == 'IN_REVISION' || state == 'EN REVISIÓN' || state == 'PENDING' || state == 'PENDIENTE';
              }).length;
              final approved = inspections.where((i) {
                final state = (i.state ?? '').toUpperCase();
                return state == 'COMPLETED' || state == 'COMPLETADO' || state == 'APPROVED' || state == 'APROBADO' || state == 'ACCEPTED' || state == 'ACEPTADO';
              }).length;

              final cards = [
                _AnimatedStatCard(
                  value: total.toString(),
                  label: "Total de Reportes",
                  icon: Icons.assignment_outlined,
                  onTap: () => onNavigateTab(1),
                ),
                _AnimatedStatCard(
                  value: inProgress.toString(),
                  label: "En Proceso",
                  icon: Icons.sync_rounded,
                  onTap: () => onNavigateTab(1),
                ),
                _AnimatedStatCard(
                  value: inReview.toString(),
                  label: "En Revisión",
                  icon: Icons.access_time_rounded,
                  onTap: () => onNavigateTab(1),
                ),
                _AnimatedStatCard(
                  value: approved.toString(),
                  label: "Aprobados",
                  icon: Icons.check_circle_outline_rounded,
                  onTap: () => onNavigateTab(1),
                ),
              ];

              return LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth >= 950;
                  if (isWide) {
                    return Row(
                      children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: c))).toList(),
                    );
                  } else {
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
            },
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator(color: kPrimaryRed)),
            ),
            error: (err, _) => Center(
              child: Text("Error al cargar contadores: $err", style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 16),
          inspectionsAsync.when(
            data: (inspections) => _TechnicianBuildingChartsContainer(inspections: inspections),
            loading: () => const SizedBox(height: 355, child: Center(child: CircularProgressIndicator(color: kPrimaryRed))),
            error: (_, __) => const SizedBox.shrink(),
          ),
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

class _TechnicianBuildingChartsContainer extends StatelessWidget {
  final List<dynamic> inspections;

  const _TechnicianBuildingChartsContainer({required this.inspections});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                child: _InspectionTypeChartContent(inspections: inspections),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _InteractiveWeeklyChartCard(
                inspections: inspections,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: const _InteractiveProductivityCard(),
            ),
          ],
        );
      },
    );
  }
}

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

class _InteractiveWeeklyChartCard extends StatefulWidget {
  final List<dynamic> inspections;

  const _InteractiveWeeklyChartCard({required this.inspections});

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
    if (oldWidget.inspections != widget.inspections) {
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

    // Filtrar estrictamente los reportes que estén aprobados/completados usando su inspection_date
    final approvedInspections = widget.inspections.where((item) {
      final state = (item.state ?? '').toUpperCase();
      final bool isCompleted = state == 'COMPLETED' || state == 'COMPLETADO' || state == 'APPROVED' || state == 'APROBADO' || state == 'ACCEPTED' || state == 'ACEPTADO';
      return isCompleted;
    }).toList();

    if (selectedPeriod == 'Últimos 7 días') {
      List<DateTime> days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
      
      labels = days.map((d) {
        switch (d.weekday) {
          case 1: return 'Lun';
          case 2: return 'Mar';
          case 3: return 'Mié';
          case 4: return 'Jue';
          case 5: return 'Vie';
          case 6: return 'Sáb';
          case 7: return 'Dom';
          default: return '';
        }
      }).toList();

      dataValues = days.map((day) {
        return approvedInspections.where((item) {
          try {
            final dynamic rawDate = item.inspectionDate;
            if (rawDate == null) return false;
            final dt = rawDate is DateTime ? rawDate : DateTime.parse(rawDate.toString()).toLocal();
            return dt.year == day.year && dt.month == day.month && dt.day == day.day;
          } catch (_) {
            return false;
          }
        }).length;
      }).toList();

    } else if (selectedPeriod == 'Último mes') {
      labels = ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Actual'];
      dataValues = List.generate(5, (index) {
        int startDay = (4 - index) * 7;
        int endDay = startDay + 7;
        return approvedInspections.where((item) {
          try {
            final dynamic rawDate = item.inspectionDate;
            if (rawDate == null) return false;
            final dt = rawDate is DateTime ? rawDate : DateTime.parse(rawDate.toString()).toLocal();
            final diff = now.difference(dt).inDays;
            return diff >= startDay && diff < endDay;
          } catch (_) {
            return false;
          }
        }).length;
      }).reversed.toList();

    } else {
      labels = ['Q1', 'Q2', 'Q3', 'Q4', 'Pasado', 'Actual'];
      dataValues = List.generate(6, (index) {
        return approvedInspections.where((item) {
          try {
            final dynamic rawDate = item.inspectionDate;
            if (rawDate == null) return false;
            final dt = rawDate is DateTime ? rawDate : DateTime.parse(rawDate.toString()).toLocal();
            return dt.year == now.year;
          } catch (_) {
            return false;
          }
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
                      "2. Reportes Aprobados",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: kDarkText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedPeriod == 'Últimos 7 días' ? "Basado en fecha de inspección" : "Histórico por periodo",
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
                      Text("Total aprobados: $totalReports", style: const TextStyle(color: kDarkText, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: kPrimaryRed, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      const Text("Por fecha de inspección", style: TextStyle(color: kGreyText, fontSize: 10, fontWeight: FontWeight.w600)),
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

class _InteractiveProductivityCard extends StatelessWidget {
  const _InteractiveProductivityCard();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Container(
        height: 355,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
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
                      "3. Eficiencia y Estado",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: kDarkText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Indicador de desempeño",
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
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("ACTIVO", style: TextStyle(color: Colors.blue, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: kPrimaryRed,
                  size: 44,
                ),
              ),
            ),
            Column(
              children: [
                _buildMetricRow("Calidad de entrega", "98%", Colors.green),
                const SizedBox(height: 8),
                _buildMetricRow("Tiempo promedio", "1.2 hrs", Colors.blueAccent),
                const SizedBox(height: 8),
                _buildMetricRow("Estado general", "Óptimo", kPrimaryRed),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star_rounded, color: kPrimaryRed, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Excelente ritmo de inspección registrado.",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kPrimaryRed),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
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
          value,
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

class _InspectionTypeChartContent extends StatelessWidget {
  final List<dynamic> inspections;

  const _InspectionTypeChartContent({required this.inspections});

  @override
  Widget build(BuildContext context) {
    int conveyorCount = 0;
    int vehicleCount = 0;
    int pressCount = 0;

    for (var item in inspections) {
      final type = (item.reportType ?? item.type ?? '').toString().toLowerCase().trim();
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