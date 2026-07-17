import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'package:crv_reprosisa/core/utils/press_pdf_processor.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/pdf_viewer_page.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/dialogs/press/complete_service_dialog.dart';
import 'package:crv_reprosisa/features/servicios/presentation/dialogs/press/start_service_dialog.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_create_order_dialog.dart';

import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContainer(child: _buildHeader(widget.press)),
            const SizedBox(height: 16),
            _buildSummarySection(),
            const SizedBox(height: 16),
            
            // Fila de 3 columnas para secciones superiores
            LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1000;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildColumn1()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildColumn2()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildColumn3()),
                      ],
                    )
                  : Column(
                      children: [_buildColumn1(), const SizedBox(height: 16), _buildColumn2(), const SizedBox(height: 16), _buildColumn3()],
                    );
            }),

            const SizedBox(height: 16),
            // ÓRDENES DE SERVICIO a todo lo ancho
            _buildSectionContainer(
              "ÓRDENES DE SERVICIO",
              _buildOrdenServicioCard(),
              height: 400,
            ),
          ],
        ),
      ),
    );
  }

  // Columnas de 3 vías para la parte central
  Widget _buildColumn1() => _buildSectionContainer(
        "COMPONENTES",
        _buildComponentesList(),
        height: 580,
      );

  Widget _buildColumn2() => _buildSectionContainer(
        "INCIDENTES",
        _buildRecurrenciaSection(),
        height: 580,
      );

  Widget _buildColumn3() => _buildSectionContainer(
        "INSPECCIONES",
        _buildInspeccionesList(),
        height: 580,
      );
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
              fontSize: 14,
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
      child: Center(child: Text("Sin componentes pendientes")),
    );
  }

  // Agrupamos y obtenemos estados (asumiendo que quieres el estado más reciente o representativo)
  final Map<String, dynamic> infoMap = {};
  for (var item in state.data) {
    // Si necesitas mostrar un estado específico por componente, ajusta esta lógica
    infoMap[item.componentName] = {
      'count': (infoMap[item.componentName]?['count'] ?? 0) + 1,
      'status': item.status, // Aquí tomará el status del último item
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
      final String status = data['status'];
      
      final Color color = _getColorForStatus(status);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Borde muy redondeado
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono en círculo con fondo suave
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIconForComponent(name), size: 20, color: color),
            ),
            const SizedBox(width: 16),
            // Información principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "Incidencias: $count",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Etiqueta de estado tipo "Píldora"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Helpers necesarios
Color _getColorForStatus(String status) {
  switch (status.toUpperCase()) {
    case 'ATENCIÓN': return Colors.orange;
    case 'PENDIENTE': return Colors.blue;
    case 'MALAS': return Colors.red;
    default: return Colors.grey;
  }
}

IconData _getIconForComponent(String name) {
  if (name.toLowerCase().contains('freno')) return Icons.speed;
  if (name.toLowerCase().contains('aire')) return Icons.settings;
  if (name.toLowerCase().contains('aceite')) return Icons.water_drop;
  return Icons.settings;
}
  // --- HEADER Y KPI ---
  Widget _buildHeader(Press p) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${p.model} - ${p.serie}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: p.isActive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        p.operationState,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Abrimos el diálogo de creación
                showDialog(
                  context: context,
                  builder: (_) =>
                      PressCreateOrderDialog(pressId: widget.press.id),
                ).then((value) {
                  // Si el diálogo devuelve 'true', recargamos las órdenes
                  if (value == true) {
                    ref
                        .read(pressServiceOrderNotifierProvider.notifier)
                        .loadOrders(widget.press.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Orden creada correctamente"),
                      ),
                    );
                  }
                });
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text("ORDEN"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildInfoChip(Icons.bolt, p.volts),
            _buildInfoChip(Icons.aspect_ratio, p.size),
            _buildInfoChip(Icons.category, p.type),
            if (p.currentLocation != null)
              _buildInfoChip(Icons.location_on, p.currentLocation!),
          ],
        ),
      ],
    ),
  );

  // Widget auxiliar para mantener el código limpio
  Widget _buildInfoChip(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
        ),
      ],
    ),
  );

Widget _buildSummarySection() {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Definimos el espacio entre tarjetas
      const double spacing = 16.0;
      // Calculamos el ancho basado en si es una pantalla amplia o móvil
      // Si es muy estrecho (móvil), mostramos uno debajo de otro, si no, 3 en fila.
      final bool isWide = constraints.maxWidth > 800;
      final double cardWidth = isWide 
          ? (constraints.maxWidth - (spacing * 2)) / 3 
          : constraints.maxWidth;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          SizedBox(width: cardWidth, child: _counterCard("339", "Totales", Colors.red, Icons.bar_chart)),
          SizedBox(width: cardWidth, child: _counterCard("115", "En Proceso", Colors.orange, Icons.assignment_turned_in_outlined)),
          SizedBox(width: cardWidth, child: _counterCard("224", "Completados", Colors.green, Icons.check_circle_outline)),
        ],
      );
    },
  );
}

Widget _counterCard(String value, String label, Color color, IconData icon) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      // Borde sutil para darle definición sobre el fondo gris
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
        // Columna de texto
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
        
        // Icono en círculo con fondo muy suave (el estilo que buscas)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08), // Color muy suave
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
    return const Center(
        child: CircularProgressIndicator(color: Color(0xFFC62828)));
  }

  if (historyState.history.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text("Sin inspecciones"),
      ),
    );
  }

  return Stack(
    children: [
      // Línea vertical que simula la línea de tiempo
      Positioned(
        left: 24,
        top: 0,
        bottom: 0,
        child: Container(width: 2, color: brandColor.withValues(alpha: 0.3)),
      ),
      ListView.separated(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
        itemCount: historyState.history.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final h = historyState.history[index];

          return Row(
            children: [
              // Punto rojo de la línea de tiempo
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: brandColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Tarjeta de inspección
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Fecha (Día y Mes)
                      Column(
                        children: [
                          Text(
                            "${h.inspectionDate.day}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            _getMonthAbbr(h.inspectionDate.month),
                            style: TextStyle(
                                color: brandColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Título y responsable
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Inspección general",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              "Por: ${h.responsibleName}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Botones de acción
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: "Ver",
                            icon: Icon(Icons.visibility,
                                size: 18, color: Colors.grey.shade600),
                            onPressed: () async {
                              final data =
                                  await PressPdfProcessor.generatePdfFromVersionId(
                                ref,
                                h.versionId,
                              );
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
                          IconButton(
                            tooltip: "PDF",
                            icon: Icon(Icons.file_download,
                                size: 18, color: brandColor),
                            onPressed: () async {
                              final data =
                                  await PressPdfProcessor.generatePdfFromVersionId(
                                ref,
                                h.versionId,
                              );
                              if (data != null) {
                                final pdfBytes =
                                    await PrensaPdfGenerator.generateEsqueleto(
                                        data);
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
      ),
    ],
  );
}

// Helper para obtener el mes abreviado
String _getMonthAbbr(int month) {
  const months = [
    "ENE", "FEB", "MAR", "ABR", "MAY", "JUN",
    "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"
  ];
  return months[month - 1];
}

  Widget _buildOrdenServicioCard() {
    final state = ref.watch(pressServiceOrderNotifierProvider);

    if (state.status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pendingOrders = state.orders
        .where((o) => o.status == "PENDING")
        .toList();

    final inProgressOrders = state.orders
        .where((o) => o.status == "IN_PROGRESS")
        .toList();

    final completedOrders = state.orders
        .where((o) => o.status == "COMPLETED")
        .toList();

    if (pendingOrders.isEmpty &&
        inProgressOrders.isEmpty &&
        completedOrders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No hay órdenes de servicio"),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (pendingOrders.isNotEmpty) ...[
          _buildSectionTitle("ÓRDENES PENDIENTES", Colors.blue),
          ...pendingOrders.map((o) => _buildServiceOrderItem(o, context, ref)),
        ],

        if (inProgressOrders.isNotEmpty) ...[
          _buildSectionTitle("ÓRDENES EN PROGRESO", Colors.orange),
          ...inProgressOrders.map(
            (o) => _buildServiceOrderItem(o, context, ref),
          ),
        ],

        if (completedOrders.isNotEmpty) ...[
          _buildSectionTitle("ÓRDENES COMPLETADAS", Colors.green),
          ...completedOrders.map(
            (o) => _buildServiceOrderItem(o, context, ref),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
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

    final String displayId = order.id.length >= 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();

    final buttonText = isPending
        ? "INICIAR ORDEN"
        : isInProgress
        ? "COMPLETAR ORDEN"
        : "COMPLETADA";

    final buttonColor = isPending
        ? Colors.blue
        : isInProgress
        ? Colors.orange
        : Colors.green;

    final displayReportId = order.reportId.length >= 6
        ? order.reportId.substring(0, 6)
        : order.reportId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayId,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isCompleted
                    ? Colors.green
                    : isInProgress
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_box, color: Colors.green),
                  tooltip: "Agregar componentes",
                  onPressed: isCompleted
                      ? null
                      : () => _showAddItemsDialog(context, ref, order.id),
                ),
                IconButton(
                  icon: const Icon(Icons.list_alt, color: Colors.blue),
                  tooltip: "Ver componentes adjuntos",
                  onPressed: () =>
                      _showServiceItemsDialog(context, ref, order.id),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          order.description,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 4),

        Text(
          "Obs: ${order.observation}",
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reporte: $displayReportId",
              style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
            ),
            Text(
              "Apertura: ${order.date.day}/${order.date.month}/${order.date.year}",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isCompleted
                ? null
                : completeState.loading
                ? null
                : () async {
                  if (isPending) {
                    await showDialog(
                      context: context,
                      builder: (_) => StartPressServiceDialog(
                        order: order,
                        onStarted: () async {
                          _refreshAllData();
                        },
                      ),
                    );
                  } else if (isInProgress) {
                      await showDialog(
                        context: context,
                        builder: (_) => CompleteServiceDialog(
                          order: order,
                          pressId: order.pressId,
                          onCompleted: () async {
                            _refreshAllData();
                          },
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: completeState.loading && !isCompleted
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(buttonText),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(thickness: 1),
        ),
      ],
    );
  }

  void _showAddItemsDialog(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) {
    final Set<String> selectedIds = {};
    // Cargamos los pendientes actuales de la prensa
    ref
        .read(pressItemNotifierProvider.notifier)
        .loadPendingItems(widget.press.id);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final pendingState = ref.watch(pressItemNotifierProvider);

          return Dialog(
            backgroundColor: Colors.white,
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),

                  // FIX: El loading debe ocupar el espacio disponible de forma controlada
                  if (pendingState.status == Status.loading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  // FIX: Solo mostramos la lista si NO está cargando y hay datos
                  if (pendingState.status != Status.loading &&
                      pendingState.data.isNotEmpty)
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: pendingState.data.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final item = pendingState.data[i];
                          final isSelected = selectedIds.contains(item.id);
                          return InkWell(
                            onTap: () => setDialogState(
                              () => isSelected
                                  ? selectedIds.remove(item.id)
                                  : selectedIds.add(item.id),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.red.withValues(alpha: 0.05)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.red
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
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    item.componentName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Mensaje si está vacío
                  if (pendingState.status != Status.loading &&
                      pendingState.data.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text("No hay componentes pendientes"),
                      ),
                    ),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                        ),
                        onPressed: selectedIds.isEmpty
                            ? null
                            : () async {
                                await ref
                                    .read(
                                      pressAttachItemsNotifierProvider.notifier,
                                    )
                                    .attachItems(
                                      serviceId,
                                      selectedIds.toList(),
                                    );

                                ref
                                    .read(pressItemNotifierProvider.notifier)
                                    .loadPendingItems(widget.press.id);
                                ref
                                    .read(
                                      pressServiceOrderNotifierProvider
                                          .notifier,
                                    )
                                    .loadOrders(widget.press.id);

                                if (context.mounted) Navigator.pop(context);
                              },
                        child: const Text("Confirmar"),
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

  // 2. DIÁLOGO PARA VER COMPONENTES ADJUNTOS
  void _showServiceItemsDialog(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) {
    // IMPORTANTE: Asegúrate de que este método en el notifier llame al endpoint correcto
    ref
        .read(pressServiceItemsNotifierProvider.notifier)
        .loadServiceItems(serviceId);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          padding: const EdgeInsets.all(24),
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(pressServiceItemsNotifierProvider);

              if (state.status == Status.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Componentes adjuntos",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  // Se usa Flexible para que la lista no rompa el diseño del diálogo
                  Flexible(
                    child: state.items.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("Sin componentes adjuntos"),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.items.length,
                            separatorBuilder: (_, _) => const Divider(),
                            itemBuilder: (context, index) {
                              final item = state.items[index];

                              // DEBUG: Si esto imprime "null" o "" en la consola, ahí está el problema
                              debugPrint(
                                "Ítem $index: Desc=${item.description}, Status=${item.status}",
                              );

                              return ListTile(
                                title: Text(
                                  item.description.isNotEmpty
                                      ? item.description
                                      : "Sin descripción",
                                ),
                                subtitle: Text("Estado: ${item.status}"),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cerrar"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
        child: Text("Sin incidencias registradas"),
      ),
    );
  }

  return ListView.separated(
    padding: EdgeInsets.zero,
    itemCount: state.incidences.length,
    separatorBuilder: (_, _) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      final item = state.incidences[index];
      // Normalizamos el progreso: máximo de 10 incidencias para el ancho visual
      final double progress = (item.incidenceCount / 10).clamp(0.0, 1.0);
      final Color brandColor = const Color(0xFFC62828);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.componentName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Píldora de contador personalizada
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
          // Barra de progreso personalizada con bordes redondeados
          Stack(
            children: [
              // Fondo de la barra
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Barra de progreso activa
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
