
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'package:crv_reprosisa/core/utils/press_pdf_processor.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/pdf_viewer_page.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/dialogs/press/complete_service_dialog.dart';
import 'package:crv_reprosisa/features/servicios/presentation/dialogs/press/start_service_dialog.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_create_order_dialog.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/evidence.dart';

import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

class PressServiceDetailView extends ConsumerStatefulWidget {
  final Press press;

  const PressServiceDetailView({super.key, required this.press});

  @override
  ConsumerState<PressServiceDetailView> createState() =>
      _PressServiceDetailViewState();
}

class _PressServiceDetailViewState
    extends ConsumerState<PressServiceDetailView> {
  final List<String> ordenOficial = [
    "NIVELES DE ACEITE",
    "MANOMETRO EN CERO",
    "PRENSA EN MODO MANUAL",
    "PRENSA EN MODO AUTOMÁTICO",
    "PRENSA TEMPERATURA AMBIENTE AL INICIAR",
    "DE 10-30 MINUTOS TEMPERATURA A 140-160 C°",
    "MANGUERAS DE ACEITE",
    "CABLEADO",
    "RUIDOS INUSUALES",
    "CAJA DE CONTROL Y/O CABEZAS DE CONTROL",
    "PLATO SUPERIOR",
    "PLATO INFERIOR",
    "CÁMARA DE PRESIÓN Y/O ACOPLE RÁPIDO",
    "CALIBRADO DE PRESIÓN Y/O MANGUERA DE LLENADO",
    "TORNILLOS Y/O PERNOS",
    "PLATOS DE COMPENSADORES DE CALOR",
    "RIELES",
    "MANGUERAS PARA ENFRIAMIENTO",
    "SEGUROS DE RIELES",
    "SISTEMA DE PRESIÓN: BOMBA /COMPRESOR",
    "LIMPIEZA",
    "ESTRUCTURA/ SOLDADURA",
    "CABLES TERMOPARES Y LECTOR",
  ];

  String? _loadingPdfId; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllData();
    });
  }

  void _refreshAllData() {
    ref
        .read(pressItemNotifierProvider.notifier)
        .loadPendingItems(widget.press.id);
    ref
        .read(pressIncidenceNotifierProvider.notifier)
        .loadIncidences(widget.press.id);
    ref
        .read(pressServiceOrderNotifierProvider.notifier)
        .loadOrders(widget.press.id);
    ref.read(pressHistoryProvider.notifier).loadHistory(widget.press.id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pressAttachItemsNotifierProvider, (previous, next) {
      if (next.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Componentes agregados con éxito"), backgroundColor: Colors.green),
        );
      } else if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${next.error ?? "Ocurrió un error"}"), backgroundColor: Colors.red),
        );
      }
    });

    final orderState = ref.watch(pressServiceOrderNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: LayoutBuilder(builder: (context, constraints) {
        int columns = constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 800 ? 2 : 1);
        double itemWidth = (constraints.maxWidth - (16 * (columns + 1))) / columns;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildContainer(child: _buildHeader(widget.press)),
              const SizedBox(height: 16),
              _buildSummarySection(orderState.orders),
              const SizedBox(height: 16),
              
              // Fila de 3 columnas para secciones superiores
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: itemWidth,
                    height: 450,
                    child: _buildSectionContainer("COMPONENTES", _buildComponentesList(), height: 450),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: 450,
                    child: _buildSectionContainer("INCIDENTES", _buildRecurrenciaSection(), height: 450),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: 450,
                    child: _buildSectionContainer("INSPECCIONES", _buildInspeccionesList(), height: 450),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // ÓRDENES DE SERVICIO a todo lo ancho
              _buildSectionContainer(
                "ÓRDENES DE SERVICIO",
                _buildOrdenServicioCard(orderState.orders, context, ref),
                height: 450,
              ),

              const SizedBox(height: 16),
              // GESTIÓN DE EVIDENCIAS
              _buildSectionContainer(
                "GESTIÓN DE EVIDENCIAS",
                _buildEvidenciasList(orderState.orders),
                height: 250,
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- ESTRUCTURA ---
  Widget _buildContainer({required Widget child}) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );

  Widget _buildSectionContainer(
    String title,
    Widget content, {
    double height = 300,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const Divider(height: 24),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildComponentesList() {
    final state = ref.watch(pressItemNotifierProvider);

    if (state.status == Status.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: Color(0xFFC62828)),
        ),
      );
    }

    if (state.data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("Sin componentes pendientes", style: TextStyle(color: Colors.grey, fontSize: 13))),
      );
    }

    final Map<String, dynamic> infoMap = {};
    for (var item in state.data) {
      infoMap[item.componentName] = {
        'count': (infoMap[item.componentName]?['count'] ?? 0) + 1,
        'status': item.status,
      };
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      itemCount: infoMap.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final name = infoMap.keys.elementAt(index);
        final data = infoMap[name]!;
        final int count = data['count'];
        final String rawStatus = data['status'];
        
        String statusText = rawStatus.toUpperCase();
        if (statusText == "PENDING") statusText = "PENDIENTE";
        if (statusText == "CRITICAL") statusText = "CRÍTICO";
        if (statusText == "ATTENTION") statusText = "ATENCIÓN";

        final Color color = _getColorForStatus(statusText);

        return MouseRegion(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(_getIconForPressComponent(name), size: 18, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Incidencias: $count",
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorForStatus(String status) {
    switch (status.toUpperCase()) {
      case 'CRÍTICO':
      case 'MALAS': return const Color.fromARGB(255, 233, 18, 2);
      case 'ATENCIÓN': return const Color.fromARGB(255, 255, 102, 0);
      case 'PENDIENTE': return const Color.fromARGB(255, 16, 52, 209);
      default: return Colors.grey;
    }
  }

  IconData _getIconForPressComponent(String name) {
    final n = name.toLowerCase();
    if (n.contains("aceite")) return Icons.oil_barrel;
    if (n.contains("manometro")) return Icons.speed;
    if (n.contains("manual") || n.contains("automatico") || n.contains("automático")) return Icons.settings_suggest;
    if (n.contains("temperatura") || n.contains("termopares")) return Icons.thermostat;
    if (n.contains("mangueras")) return Icons.water_drop;
    if (n.contains("cableado") || n.contains("cables")) return Icons.electrical_services;
    if (n.contains("ruidos")) return Icons.volume_up;
    if (n.contains("control")) return Icons.developer_board;
    if (n.contains("plato")) return Icons.layers;
    if (n.contains("presión") || n.contains("camara")) return Icons.compress;
    if (n.contains("tornillos") || n.contains("pernos")) return Icons.hardware;
    if (n.contains("rieles") || n.contains("seguros")) return Icons.view_stream;
    if (n.contains("bomba") || n.contains("compresor")) return Icons.air;
    if (n.contains("limpieza")) return Icons.cleaning_services;
    if (n.contains("estructura") || n.contains("soldadura")) return Icons.carpenter;
    return Icons.settings;
  }

  // Header responsivo adaptado para evitar desbordamientos en pantallas pequeñas
  Widget _buildHeader(Press p) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        bool isVeryNarrow = constraints.maxWidth < 420;

        if (isVeryNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: const Icon(Icons.print, size: 26, color: Colors.grey),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${p.model} - ${p.serie}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: p.isActive ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                p.operationState,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          PressCreateOrderDialog(pressId: widget.press.id),
                    ).then((value) {
                      if (value == true) {
                        _refreshAllData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Orden creada correctamente"),
                          ),
                        );
                      }
                    });
                  },
                  icon: const Icon(Icons.add, size: 14),
                  label: const Text("ORDEN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: const Icon(Icons.print, size: 30, color: Colors.grey),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${p.model} - ${p.serie}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: p.isActive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          p.operationState,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) =>
                      PressCreateOrderDialog(pressId: widget.press.id),
                ).then((value) {
                  if (value == true) {
                    _refreshAllData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Orden creada correctamente"),
                      ),
                    );
                  }
                });
              },
              icon: const Icon(Icons.add, size: 14),
              label: const Text("ORDEN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    ),
  );

  Widget _buildSummarySection(List<PressServiceOrderModel> orders) {
    final total = orders.length;
    final pendientes = orders.where((o) => o.status == "PENDING").length;
    final enProceso = orders.where((o) => o.status == "IN_PROGRESS").length;
    final completados = orders.where((o) => o.status == "COMPLETED").length;

    final items = [
      {
        "value": "$total",
        "label": "Totales",
        "color": Colors.red,
        "icon": Icons.bar_chart
      },
      {
        "value": "$pendientes",
        "label": "Pendientes",
        "color": Colors.blue,
        "icon": Icons.pending_actions_rounded
      },
      {
        "value": "$enProceso",
        "label": "En Proceso",
        "color": Colors.orange,
        "icon": Icons.assignment_turned_in_outlined
      },
      {
        "value": "$completados",
        "label": "Completados",
        "color": Colors.green,
        "icon": Icons.check_circle_outline
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 16.0;
        int columns = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
        double width = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) => SizedBox(
            width: width,
            child: _counterCard(
              item["value"] as String,
              item["label"] as String,
              item["color"] as Color,
              item["icon"] as IconData,
            ),
          )).toList(),
        );
      },
    );
  }

  Widget _counterCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildInspeccionesList() {
    final historyState = ref.watch(pressHistoryProvider);
    final brandColor = const Color(0xFFC62828);

    if (historyState.status == Status.loading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CircularProgressIndicator(color: brandColor),
        ),
      );
    }

    if (historyState.history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Sin inspecciones registradas", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      itemCount: historyState.history.length,
      itemBuilder: (context, index) {
        final h = historyState.history[index];
        final isLast = index == historyState.history.length - 1;
        final isLoading = _loadingPdfId == h.versionId;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: brandColor, shape: BoxShape.circle),
                ),
                if (!isLast)
                  Container(width: 2, height: 70, color: Colors.grey.shade200),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${h.inspectionDate.day}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black87),
                          ),
                          Text(
                            _getMonthAbbr(h.inspectionDate.month),
                            style: TextStyle(fontSize: 9, color: brandColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Inspección general", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Por: ${h.responsibleName}", 
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFC62828)))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _actionButton(
                              Icons.visibility, 
                              Colors.grey.shade600, 
                              () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Generando vista previa del PDF..."),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                setState(() => _loadingPdfId = h.versionId);
                                
                                final data = await PressPdfProcessor.generatePdfFromVersionId(ref, h.versionId);
                                if (mounted) setState(() => _loadingPdfId = null);

                                if (data != null && mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PdfViewerPage(datos: data),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 4),
                            _actionButton(
                              Icons.download, 
                              brandColor, 
                              () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Descargando reporte PDF..."),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                setState(() => _loadingPdfId = h.versionId);

                                final data = await PressPdfProcessor.generatePdfFromVersionId(ref, h.versionId);
                                if (mounted) setState(() => _loadingPdfId = null);

                                if (data != null) {
                                  final pdfBytes = await PrensaPdfGenerator.generateEsqueleto(data);
                                  await Printing.sharePdf(
                                    bytes: pdfBytes,
                                    filename: 'Reporte_${data['folio']}.pdf',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08), 
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const months = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
    return months[month - 1];
  }

  Widget _buildOrdenServicioCard(List<PressServiceOrderModel> orders, BuildContext context, WidgetRef ref) {
    final pending = orders.where((o) => o.status == "PENDING").toList();
    final inProgress = orders.where((o) => o.status == "IN_PROGRESS").toList();
    final completed = orders.where((o) => o.status == "COMPLETED").toList();

    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 800;

      if (isMobile) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey.shade500,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                  ),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  tabs: const [
                    Tab(text: "Pendientes"),
                    Tab(text: "Proceso"),
                    Tab(text: "Completas"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOrderList(pending, context, ref),
                    _buildOrderList(inProgress, context, ref),
                    _buildOrderList(completed, context, ref),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildOrderColumn("PENDIENTES", pending, const Color.fromARGB(255, 194, 24, 21), context, ref)),
          const SizedBox(width: 12),
          Expanded(child: _buildOrderColumn("EN PROCESO", inProgress, Colors.orange, context, ref)),
          const SizedBox(width: 12),
          Expanded(child: _buildOrderColumn("COMPLETADAS", completed, Colors.green, context, ref)),
        ],
      );
    });
  }

  Widget _buildOrderList(List<PressServiceOrderModel> orders, BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) {
      return const Center(child: Text("Sin órdenes", style: TextStyle(color: Colors.grey, fontSize: 11)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildServiceOrderItem(orders[index], context, ref),
    );
  }

  Widget _buildOrderColumn(String title, List<PressServiceOrderModel> orders, Color color, BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text("${orders.length}", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
              )
            ],
          ),
        ),
        const Divider(height: 1),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: orders.length,
            itemBuilder: (context, index) => _buildServiceOrderItem(orders[index], context, ref),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceOrderItem(
    PressServiceOrderModel order,
    BuildContext context,
    WidgetRef ref,
  ) {
    final isPending = order.status == "PENDING";
    final isInProgress = order.status == "IN_PROGRESS";
    final isCompleted = order.status == "COMPLETED";

    final completeState = ref.watch(completeServiceNotifierProvider);

    final buttonText = isPending ? "INICIAR" : (isInProgress ? "COMPLETAR" : "COMPLETADA");
    final statusColor = isCompleted ? Colors.green : (isInProgress ? Colors.orange : const Color.fromARGB(255, 227, 18, 18));

    final String displayId = order.id.length >= 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase();
    final String displayReportId = order.reportId.isNotEmpty ? (order.reportId.length >= 6 ? order.reportId.substring(0, 6) : order.reportId) : "N/A";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(displayId, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: statusColor)),
              ),
              Row(
                children: [
                  _iconActionButton(Icons.add_box_outlined, Colors.green, () => _showAddItemsDialog(context, ref, order.id), isCompleted),
                  const SizedBox(width: 4),
                  _iconActionButton(Icons.list_alt_outlined, Colors.blue, () => _showServiceItemsDialog(context, ref, order.id), false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text("Obs: ${order.observation}", style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rep: $displayReportId", style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
              Text("${order.date.day}/${order.date.month}/${order.date.year}", style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: isCompleted || completeState.loading ? null : () async {
                if (isPending) {
                  await showDialog(
                    context: context,
                    builder: (_) => StartPressServiceDialog(
                      order: order,
                      onStarted: () async => _refreshAllData(),
                    ),
                  );
                } else if (isInProgress) {
                  showDialog(
                    context: context, 
                    builder: (_) => CompleteServiceDialog(
                      order: order, 
                      pressId: order.pressId, 
                      onCompleted: () async => _refreshAllData(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.grey.shade100 : statusColor,
                foregroundColor: isCompleted ? Colors.grey.shade600 : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: completeState.loading && !isCompleted
                  ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(buttonText, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconActionButton(IconData icon, Color color, VoidCallback onPressed, bool disabled) {
    return IconButton(
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 18, color: disabled ? Colors.grey.shade300 : color),
      onPressed: disabled ? null : onPressed,
    );
  }

  Widget _buildEvidenciasList(List<PressServiceOrderModel> orders) {
    final servicesWithEvidence = orders.where((s) => s.evidences.isNotEmpty).toList();

    if (servicesWithEvidence.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off_outlined, size: 32, color: Colors.redAccent),
            SizedBox(height: 8),
            Text("Sin evidencias registradas", style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      itemCount: servicesWithEvidence.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final service = servicesWithEvidence[index];
        
        return InkWell(
          onTap: () => _showServiceEvidenceDialog(context, service),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade50),
              boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.folder_shared_outlined, color: Color(0xFFC62828), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                      Text("${service.evidences.length} archivos asociados", style: TextStyle(fontSize: 10, color: Colors.red.shade400, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.redAccent),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showServiceEvidenceDialog(BuildContext context, PressServiceOrderModel service) {
    final groupedData = _groupEvidences(service.evidences);
    final dates = groupedData.keys.toList();
    final String displayReportId = service.reportId.isNotEmpty 
        ? (service.reportId.length >= 6 ? service.reportId.substring(0, 6).toUpperCase() : service.reportId.toUpperCase()) 
        : "N/A";

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar",
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: Curves.easeInOut.transform(animation.value),
          child: Opacity(
            opacity: animation.value,
            child: Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                constraints: const BoxConstraints(maxWidth: 450, maxHeight: 520),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC62828).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.folder_special, color: Color(0xFFC62828), size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.description,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black87),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Folio / Reporte: $displayReportId",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dates.length,
                        itemBuilder: (_, index) {
                          final date = dates[index];
                          final files = groupedData[date]!;

                          return ExpansionTile(
                            iconColor: const Color(0xFFC62828),
                            textColor: const Color(0xFFC62828),
                            collapsedTextColor: Colors.black87,
                            collapsedIconColor: Colors.grey,
                            leading: const Icon(Icons.calendar_month_outlined, size: 20),
                            title: Text("Subido el $date", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text("${files.length} archivos", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            children: files.map((evidence) {
                              final isImage = evidence.mimeType.contains("image") || _isImageExtension(evidence.fileName);
                              final fileIcon = _getFileIconForEvidence(evidence.fileName, evidence.mimeType);
                              final fileColor = _getFileColor(evidence.fileName, evidence.mimeType);

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                leading: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: fileColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: fileColor.withValues(alpha: 0.3)),
                                  ),
                                  child: isImage && evidence.signedUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(evidence.signedUrl!, fit: BoxFit.cover),
                                        )
                                      : Icon(fileIcon, color: fileColor, size: 22),
                                ),
                                title: Text(
                                  evidence.fileName,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  _getFileTypeText(evidence.fileName),
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                ),
                                onTap: () => _openEvidence(evidence),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cerrar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isImageExtension(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ["png", "jpg", "jpeg", "gif", "webp", "bmp", "heic"].contains(ext);
  }

  IconData _getFileIconForEvidence(String fileName, String mimeType) {
    final ext = fileName.split('.').last.toLowerCase();
    if (mimeType.contains("pdf") || ext == "pdf") return Icons.picture_as_pdf;
    if (_isImageExtension(fileName) || mimeType.contains("image")) return Icons.image;
    return Icons.insert_drive_file;
  }

  Color _getFileColor(String fileName, String mimeType) {
    final ext = fileName.split('.').last.toLowerCase();
    if (mimeType.contains("pdf") || ext == "pdf") return const Color(0xFFD32F2F);
    if (_isImageExtension(fileName) || mimeType.contains("image")) return const Color(0xFF7B1FA2);
    return const Color(0xFF546E7A);
  }

  String _getFileTypeText(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case "pdf": return "Documento PDF";
      case "png":
      case "jpg":
      case "jpeg":
      case "webp": return "Imagen";
      default: return "Archivo adjunto";
    }
  }

  Future<void> _openEvidence(Evidence evidence) async {
    if (evidence.signedUrl == null || evidence.signedUrl!.isEmpty) return;
    final uri = Uri.parse(evidence.signedUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Map<String, List<Evidence>> _groupEvidences(List<Evidence> evidences) {
    final sortedEvidences = List<Evidence>.from(evidences)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    final Map<String, List<Evidence>> grouped = {};
    for (var e in sortedEvidences) {
      final dateKey = "${e.createdAt.day}/${e.createdAt.month}/${e.createdAt.year}";
      if (!grouped.containsKey(dateKey)) grouped[dateKey] = [];
      grouped[dateKey]!.add(e);
    }
    return grouped;
  }

  void _showAddItemsDialog(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) {
    final Set<String> selectedIds = {};
    
    Future.microtask(() {
      ref.read(pressItemNotifierProvider.notifier).loadPendingItems(widget.press.id);
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final pendingState = ref.watch(pressItemNotifierProvider);

          return Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420, maxHeight: 600),
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Seleccionar componentes",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (pendingState.status == Status.loading && pendingState.data.isEmpty)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFFC62828)),
                      ),
                    ),

                  if (pendingState.data.isNotEmpty)
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: pendingState.data.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final item = pendingState.data[i];
                          final isSelected = selectedIds.contains(item.id);
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => setDialogState(
                              () => isSelected
                                  ? selectedIds.remove(item.id)
                                  : selectedIds.add(item.id),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFC62828).withValues(alpha: 0.05)
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFC62828)
                                      : Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: isSelected
                                        ? const Color(0xFFC62828)
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item.componentName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  if (pendingState.status != Status.loading && pendingState.data.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          "No hay componentes pendientes",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: selectedIds.isEmpty
                            ? null
                            : () async {
                                await ref
                                    .read(pressAttachItemsNotifierProvider.notifier)
                                    .attachItems(
                                      serviceId,
                                      selectedIds.toList(),
                                    );

                                _refreshAllData();

                                if (context.mounted) Navigator.pop(context);
                              },
                        child: const Text(
                          "Confirmar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showServiceItemsDialog(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) {
    ref.read(pressServiceItemsNotifierProvider.notifier).loadServiceItems(serviceId);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar",
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: Curves.easeInOut.transform(animation.value),
          child: Opacity(
            opacity: animation.value,
            child: Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 480),
                padding: const EdgeInsets.all(24),
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(pressServiceItemsNotifierProvider);

                    if (state.status == Status.loading) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFFC62828)),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Componentes adjuntos",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (state.items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Esta orden no tiene componentes adjuntos",
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final model = state.items[index];

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFFC62828),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.description,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Estado: ${model.status}",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cerrar",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecurrenciaSection() {
    final state = ref.watch(pressIncidenceNotifierProvider);

    if (state.status == Status.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(color: Color(0xFFC62828)),
        ),
      );
    }

    if (state.incidences.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Sin incidencias registradas", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      itemCount: state.incidences.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = state.incidences[index];
        final double progress = (item.incidenceCount / 10).clamp(0.0, 1.0);
        final Color brandColor = const Color(0xFFC62828);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.componentName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${item.incidenceCount} veces",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: brandColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}