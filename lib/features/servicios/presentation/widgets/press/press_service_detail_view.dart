import 'dart:typed_data';

import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/pdf_viewer_page.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_create_order_dialog.dart';
import 'package:dio/dio.dart' as dio_package;

import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press_history.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_report_detail_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escucha el estado del notifier para mostrar retroalimentación al usuario
    ref.listen(pressAttachItemsNotifierProvider, (previous, next) {
      if (next.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Componentes agregados con éxito"),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${next.error ?? "Ocurrió un error"}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 850;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildContainer(child: _buildHeader(widget.press)),
                const SizedBox(height: 16),
                _buildSummarySection(),
                const SizedBox(height: 16),
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildLeftColumn()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildRightColumn()),
                        ],
                      )
                    : Column(
                        children: [
                          _buildLeftColumn(),
                          const SizedBox(height: 16),
                          _buildRightColumn(),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeftColumn() => Column(
    children: [
      _buildSectionContainer(
        "COMPONENTES",
        _buildComponentesList(),
        height: 300,
      ),
      const SizedBox(height: 16),
      _buildSectionContainer(
        "INCIDENTES",
        _buildRecurrenciaSection(),
        height: 250,
      ),
    ],
  );

  Widget _buildRightColumn() => Column(
    children: [
      _buildSectionContainer(
        "INSPECCIONES",
        _buildInspeccionesList(),
        height: 300,
      ),
      const SizedBox(height: 16),
      _buildSectionContainer(
        "ORDEN ABIERTA",
        _buildOrdenServicioCard(),
        height: 300,
      ),
    ],
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
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text("Sin componentes pendientes"),
      );
    }

    // Lógica de agrupamiento
    final Map<String, int> conteoIncidencias = {};
    for (var item in state.data) {
      conteoIncidencias[item.componentName] =
          (conteoIncidencias[item.componentName] ?? 0) + 1;
    }

    // CORRECCIÓN: Quitamos shrinkWrap y physics para que el scroll nativo tome el control
    return ListView.separated(
      padding:
          EdgeInsets.zero, // Ajuste estético para evitar espacios en blanco
      itemCount: conteoIncidencias.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final name = conteoIncidencias.keys.elementAt(index);
        final count = conteoIncidencias[name]!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Incidencias detectadas: $count",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$count Veces",
                  style: const TextStyle(
                    color: Colors.red,
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

  Widget _buildSummarySection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    // Usamos MainAxisAlignment.spaceEvenly para que se distribuyan solos
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _counterCard("0", "Alertas", Colors.red)),
        const SizedBox(width: 8),
        Expanded(child: _counterCard("0", "Abierta", Colors.orange)),
        const SizedBox(width: 8),
        Expanded(child: _counterCard("0", "Total", Colors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _counterCard("0", "Insp.", Colors.green)),
      ],
    ),
  );

  Widget _counterCard(String value, String label, Color color) => Container(
    // Aumentamos el padding vertical para que no se vea tan aplastado
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16), // Bordes más redondeados
      border: Border.all(
        color: color.withValues(alpha: 0.3),
      ), // Borde un poco más visible
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _buildInspeccionesList() {
    final historyState = ref.watch(pressHistoryProvider);

    if (historyState.status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyState.history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Sin inspecciones"),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: historyState.history.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final h = historyState.history[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "${h.inspectionDate.day}/${h.inspectionDate.month}/${h.inspectionDate.year}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Por: ${h.responsibleName}",
            style: const TextStyle(fontSize: 10),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: "Ver",
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () async {
                  final data = await _getReportData(h);
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
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                onPressed: () async {
                  final data = await _getReportData(h);
                  if (data != null) {
                    final pdfBytes = await PrensaPdfGenerator.generateEsqueleto(
                      data,
                    );
                    await Printing.sharePdf(
                      bytes: pdfBytes,
                      filename: 'Reporte_${data['folio']}.pdf',
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdenServicioCard() {
    final state = ref.watch(pressServiceOrderNotifierProvider);

    if (state.status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.orders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No hay órdenes abiertas"),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: state.orders.length,
      separatorBuilder: (_, _) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Divider(thickness: 1),
      ),
      itemBuilder: (context, index) {
        final order = state.orders[index];

        // Formateo del ID
        final String displayId = order.id.length >= 8
            ? order.id.substring(0, 8).toUpperCase()
            : order.id.toUpperCase();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFC62828),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_box, color: Colors.green),
                      tooltip: "Agregar componentes",
                      onPressed: () =>
                          _showAddPressItemsDialog(context, ref, order.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.list_alt, color: Colors.blue),
                      tooltip: "Ver componentes adjuntos",
                      onPressed: () =>
                          _showPressServiceItemsDialog(context, ref, order.id),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              order.description,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "Fecha: ${order.formattedDate}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes llamar a tu lógica de completar orden
                  // ref.read(completePressServiceNotifierProvider.notifier).completeService(order.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("COMPLETAR ORDEN"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddPressItemsDialog(
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
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
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
  void _showPressServiceItemsDialog(
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
                            separatorBuilder: (_, __) => const Divider(),
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
    // Observamos el estado del nuevo provider de incidencias
    final state = ref.watch(pressIncidenceNotifierProvider);

    // 1. Estados de carga o error
    if (state.status == Status.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
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

    // 2. CORRECCIÓN: ListView.separated sin shrinkWrap ni physics
    // Esto permite el scroll nativo dentro del contenedor limitado.
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: state.incidences.length,
      separatorBuilder: (_, _) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final item = state.incidences[index];
        // Normalizamos el progreso (asumiendo un máximo de 10 para visualización)
        final progress = (item.incidenceCount / 10).clamp(0.0, 1.0);

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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${item.incidenceCount} veces",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              color: Colors.purple,
              backgroundColor: Colors.purple.withValues(alpha: 0.1),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _getReportData(PressHistory item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await ref
        .read(pressReportDetailProvider.notifier)
        .fetchDetail(item.versionId);
    final state = ref.read(pressReportDetailProvider);

    if (state.data == null) {
      if (mounted) Navigator.pop(context);
      return null;
    }

    List<Map<String, dynamic>> itemsOrdenados = [];
    List<dynamic> respuestasPendientes = List.from(state.data!.answers);

    for (var nombre in ordenOficial) {
      var index = respuestasPendientes.indexWhere(
        (a) =>
            a.componentName.toUpperCase().trim() == nombre.toUpperCase().trim(),
      );
      if (index != -1) {
        itemsOrdenados.add(
          await _mapAnswerToMap(respuestasPendientes.removeAt(index)),
        );
      }
    }

    for (var answer in respuestasPendientes) {
      itemsOrdenados.add(await _mapAnswerToMap(answer));
    }

    if (mounted) Navigator.pop(context);

    return {
      'fecha': DateFormat('yyyy-MM-dd').format(item.inspectionDate),
      'tipo': state.data!.press['type'] ?? 'N/A',
      'modelo': state.data!.press['model'] ?? 'N/A',
      'volts': state.data!.press['voltz'] ?? 'N/A',
      'serie': state.data!.press['serie'] ?? 'N/A',
      'folio': state.data!.report['folio'] ?? 'N/A',
      'area': (state.data!.report['area'] ?? 'N/A').toString(),
      'area_solicita': state.data!.report['loan_area'] ?? '',
      'nombre_recibe': state.data!.report['loan_received_by'] ?? '',
      'observaciones_footer': state.data!.report['general_notes'] ?? '',
      'items': itemsOrdenados,
    };
  }

  Future<Uint8List?> _downloadImageBytes(String url) async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        url,
        options: dio_package.Options(
          responseType: dio_package.ResponseType.bytes,
        ),
      );
      return response.statusCode == 200
          ? Uint8List.fromList(response.data)
          : null;
    } catch (e) {
      debugPrint("Error descargando imagen: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> _mapAnswerToMap(dynamic answer) async {
    Uint8List? bytesAntes;
    Uint8List? bytesDespues;
    if (answer.evidencePaths.length >= 1)
      bytesAntes = await _downloadImageBytes(answer.evidencePaths[0]);
    if (answer.evidencePaths.length >= 2)
      bytesDespues = await _downloadImageBytes(answer.evidencePaths[1]);

    return {
      'name': answer.componentName,
      'status': answer.status,
      'observation':
          (answer.observation == "Notaas" || answer.observation.isEmpty)
          ? ''
          : answer.observation,
      'measureUnit': answer.measureUnit,
      'quantity': answer.quantity,
      'foto_antes_bytes': bytesAntes,
      'foto_despues_bytes': bytesDespues,
    };
  }
}
