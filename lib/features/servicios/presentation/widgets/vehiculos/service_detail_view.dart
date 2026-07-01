import 'dart:typed_data';


import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/service_item_model.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/pending_component_notifier_v.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_component_provider_v.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/create_order_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle_report_detail_entity.dart';
import 'package:crv_reprosisa/features/assets/presentation/pages/vehicle_report_detail_page.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_report_detail.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/v_service_order.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../../core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';

class ServiceDetailView extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const ServiceDetailView({super.key, required this.vehicle});

  @override
  ConsumerState<ServiceDetailView> createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends ConsumerState<ServiceDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serviceListNotifierProvider.notifier).loadServices(widget.vehicle.vehicleId);
      ref.read(vehicleHistoryProvider.notifier).loadHistory(widget.vehicle.vehicleId);
      ref.read(pendingComponentNotifierProvider.notifier).loadPendingComponents(widget.vehicle.vehicleId);
      ref.read(incidenceNotifierProvider.notifier).loadIncidences(widget.vehicle.vehicleId);
    });
  }

  Future<void> _showDetail(String versionId) async {
    await ref.read(vehicleReportDetailProvider.notifier).fetchDetail(versionId);

    if (!mounted) return;

    final state = ref.read(vehicleReportDetailProvider);

    if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!)));
      return;
    }

    if (state.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo obtener el reporte.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleReportDetailPage(reportData: state.data!),
      ),
    );
  }

  Future<void> _showPdf(String versionId) async {
    // Descargar el reporte
    await ref.read(vehicleReportDetailProvider.notifier).fetchDetail(versionId);

    if (!mounted) return;

    final state = ref.read(vehicleReportDetailProvider);

    // Si hubo error
    if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!)));
      return;
    }

    if (state.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo obtener el reporte")),
      );
      return;
    }

    // Convertir al formato del PDF
    final pdfData = VehiculoPdfGenerator.mapDetailModelToPdfData(state.data!);

    // Obtener Dio
    final dio = ref.read(dioProvider);

    // Descargar imágenes
    await VehiculoPdfGenerator.precargarImagenes(dio, pdfData);

    // Generar PDF
    final pdf = await VehiculoPdfGenerator.generateEsqueleto(pdfData);

    // Abrir visor PDF
    await Printing.layoutPdf(
      name: VehiculoPdfGenerator.generateFileName(pdfData),
      onLayout: (_) async => pdf,
    );
  }
@override
  Widget build(BuildContext context) {
    // Escucha global para feedback visual de adjuntar componentes
    ref.listen(attachItemsNotifierProvider, (previous, next) {
      if (next.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Componentes agregados con éxito"), backgroundColor: Colors.green));
      } else if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${next.error}"), backgroundColor: Colors.red));
      }
    });

    final state = ref.watch(serviceListNotifierProvider);
    final v = widget.vehicle;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContainer(child: _buildHeader(v)),
            const SizedBox(height: 16),
            _buildSummarySection(state.services),
            const SizedBox(height: 16),
            _buildSectionContainer("COMPONENTES", _buildComponentesList()),
            const SizedBox(height: 16),
            _buildSectionContainer("INSPECCIONES", _buildInspeccionesList()),
            const SizedBox(height: 16),
            _buildSectionContainer("ORDEN ABIERTA", _buildOrdenServicioCard(state.services, context, ref)),
            const SizedBox(height: 16),
            _buildSectionContainer("INCIDENTES", _buildRecurrenciaSection()),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS DE ESTRUCTURA ---
  Widget _buildContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Future<Uint8List?> _generatePdfBytes(String versionId) async {
    try {
      final result = await ref
          .read(getVehicleReportDetailUseCaseProvider)
          .call(versionId);

      Uint8List? generatedBytes;
      
      await result.fold(
        (l) async => generatedBytes = null,
        (data) async {
          for (var ans in data.answers) {
            if (ans.evidencePaths.isNotEmpty) {
              ans.evidenceBytes = await _downloadImage(ans.evidencePaths[0]);
            }
          }
          final pdfData = _mapEntityToPdfMap(data);
          // Se espera a que el generador asíncrono devuelva el resultado
          generatedBytes = await VehiculoPdfGenerator.generateEsqueleto(pdfData);
        }
      );
      return generatedBytes;
    } catch (e) {
      debugPrint("Error al procesar PDF de vehículo: $e");
      return null;
    }
  }

  Map<String, dynamic> _mapEntityToPdfMap(VehicleReportDetailEntity data) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var ans in data.answers) {
      String code = ans.optionName.toLowerCase();
      String status = "UNKNOWN";
      if (code.contains("buen")) status = "GOOD";
      else if (code.contains("mal")) status = "BAD";
      else if (code.contains("repos")) status = "REPOSITION";
      else if (code.contains("repa")) status = "REPARATION";

      grouped.putIfAbsent(ans.sectionName, () => []).add({
        "name": ans.componentName,
        "status": status, 
        "observation": ans.observation,
        "foto_antes_bytes": ans.evidenceBytes,
        "foto_despues_bytes": null,
      });
    }

    return {
      "unidad": "${data.vehicle.brand} ${data.vehicle.model}",
      "fecha": data.report['inspection_date']?.toString().split('T')[0] ?? "",
      "placas": data.vehicle.plate,
      "kilometraje": data.report['mileage'] ?? 0,
      "requiere_servicio": data.report['requires_service'] ?? false,
      "notas": data.report['general_notes'] ?? "",
      "secciones": grouped.entries.map((e) => {"name": e.key, "items": e.value}).toList(),
    };
  }

  Future<void> _viewPdfPreview(item) async {
    final pdfBytes = await _generatePdfBytes(item);
    if (pdfBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al cargar detalle")));
      return;
    }

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(title: const Text("Vista Previa PDF"), backgroundColor: Color(0xFFC62828)),
      body: PdfPreview(build: (format) => pdfBytes),
    )));
  }

  Widget _buildSectionContainer(String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
          content,
        ],
      ),
    );
  }

  // --- CONTADORES ---
  Widget _buildSummarySection(List<ServiceOrder> services) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          SizedBox(width: 80, child: _counterCard("3", "Alertas", Colors.red)),
          SizedBox(
            width: 80,
            child: _counterCard(
              "${services.where((s) => s.isActive).length}",
              "Abierta",
              Colors.orange,
            ),
          ),
          SizedBox(
            width: 80,
            child: _counterCard("${services.length}", "Total", Colors.blue),
          ),
          SizedBox(width: 80, child: _counterCard("12", "Insp.", Colors.green)),
        ],
      ),
    );
  }

  Widget _counterCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 3),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

// --- MÉTODOS DE ESTRUCTURA ---

Widget _buildComponentesList() {
  final state = ref.watch(pendingComponentNotifierProvider);

  if (state.isLoading) {
    return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
  }

  if (state.error != null) {
    return Center(child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red)));
  }

  if (state.data.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("Sin componentes pendientes"),
    );
  }

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: state.data.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (context, index) {
      final item = state.data[index];
      final color = _getColorForStatus(item.status);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.componentName, 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("Incidencias previas: ${item.incidenciasPrevias}", 
                       style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.status.toUpperCase(),
                style: TextStyle(
                  color: color, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 10
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
void _showAddItemsDialog(BuildContext context, WidgetRef ref, String serviceId) {
  final Set<String> selectedIds = {};

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
      final pendingState = ref.watch(pendingComponentNotifierProvider);
      
      return Dialog(
        backgroundColor: Colors.white, // Fondo blanco puro
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Seleccionar componentes", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87)
              ),
              const SizedBox(height: 24),
              
              // Lista estilizada
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: pendingState.data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = pendingState.data[i];
                    final isSelected = selectedIds.contains(item.id);
                    
                    return InkWell(
                      onTap: () => setDialogState(() => isSelected ? selectedIds.remove(item.id) : selectedIds.add(item.id)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFC62828).withOpacity(0.05) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? const Color(0xFFC62828) : Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, 
                                 color: isSelected ? const Color(0xFFC62828) : Colors.grey.shade400),
                            const SizedBox(width: 16),
                            Text(item.componentName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botones minimalistas
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: const Text("Cancelar", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    onPressed: selectedIds.isEmpty ? null : () async {
                      await ref.read(attachItemsNotifierProvider.notifier).attachItems(serviceId, selectedIds.toList());
                      ref.read(pendingComponentNotifierProvider.notifier).loadPendingComponents(widget.vehicle.vehicleId);
                      ref.read(serviceListNotifierProvider.notifier).loadServices(widget.vehicle.vehicleId);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text("Confirmar selección", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }),
  );
}
Widget _buildOrdenServicioCard(List<ServiceOrderModel> services, BuildContext context, WidgetRef ref) {
  final activeOrders = services.where((s) => s.isActive).toList();

  if (activeOrders.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text("No hay órdenes abiertas", style: TextStyle(color: Colors.grey)),
    );
  }

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: activeOrders.length,
    separatorBuilder: (_, __) => const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(thickness: 1),
    ),
    itemBuilder: (context, index) {
      final order = activeOrders[index];

      final String displayId = order.id.length >= 8 
          ? order.id.substring(0, 8).toUpperCase() 
          : order.id.toUpperCase();

      final String displayReportId = order.reportId != null && order.reportId!.length >= 6 
          ? order.reportId!.substring(0, 6) 
          : (order.reportId ?? "N/A");

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayId,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFC62828)),
              ),
              // Aquí mantenemos tu diseño original con los dos iconos
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_box, color: Colors.green),
                    tooltip: "Agregar componentes",
                    onPressed: () => _showAddItemsDialog(context, ref, order.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list_alt, color: Colors.blue),
                    tooltip: "Ver componentes adjuntos",
                    onPressed: () => _showServiceItemsDialog(context, ref, order.id),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Obs: ${order.observation}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Reporte: $displayReportId...", style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
              Text("Apertura: ${order.date.day}/${order.date.month}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("COMPLETAR ORDEN"),
            ),
          ),
        ],
      );
    },
  );
}

// Método para mostrar los ítems ya adjuntos - DISEÑO Y LÓGICA CORREGIDOS
void _showServiceItemsDialog(BuildContext context, WidgetRef ref, String serviceId) {
  // Cargamos los ítems antes de abrir el diálogo
  ref.read(serviceItemsNotifierProvider.notifier).loadServiceItems(serviceId);
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Consumer(builder: (context, ref, _) {
          final state = ref.watch(serviceItemsNotifierProvider);
          
          if (state.status == Status.loading) {
            return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
          }
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Componentes adjuntos", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              
              if (state.items.isEmpty) 
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Esta orden no tiene componentes adjuntos"),
                ),
              
              // Mapeo utilizando el modelo para acceder a los getters de traducción y color
              ...state.items.map((item) {
                // Realizamos el cast al modelo para acceder a nuestros getters personalizados
                final model = item as ServiceItemModel; 
                
                return ListTile(
                  leading: Icon(Icons.check_circle, color: model.statusColor), 
                  title: Text(model.description),
                  subtitle: Text("Estado: ${model.statusTranslated}"), // Traducción al español
                );
              }),
              
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text("Cerrar")
              ),
            ],
          );
        }),
      ),
    ),
  );
}

  Widget _buildInspeccionesList() {
    final historyState = ref.watch(vehicleHistoryProvider);
    if (historyState.status == Status.loading)
      return const Center(child: CircularProgressIndicator());
    if (historyState.history.isEmpty) return const Text("Sin inspecciones");
    return Column(
      children: historyState.history
          .map(
            (h) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "${h.inspectionDate.day}/${h.inspectionDate.month}/${h.inspectionDate.year}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
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
                    icon: const Icon(Icons.visibility),
                    onPressed: () => _viewPdfPreview(h.versionId),
                  ),
                  IconButton(
                    tooltip: "PDF",
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () => _showPdf(h.versionId),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200 ? response.bodyBytes : null;
    } catch (e) { return null; }
  }


// 2. Método _buildHeader actualizado
Widget _buildHeader(Vehicle v) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${v.brand} ${v.model} - ${v.plate}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Km: ${v.mileage} | Última: 26/06/2026",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC62828),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CreateOrderDialog(vehicleId: v.vehicleId),
            ).then((_) {
              ref.read(serviceListNotifierProvider.notifier).loadServices(v.vehicleId);
              
              ref.read(pendingComponentNotifierProvider.notifier).loadPendingComponents(v.vehicleId);
              
              ref.read(vehicleHistoryProvider.notifier).loadHistory(v.vehicleId);
            });
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text("ORDEN"),
        ),
      ],
    ),
  );
}

Widget _buildRecurrenciaSection() {
  // Observamos el estado del nuevo provider de incidencias
  final state = ref.watch(incidenceNotifierProvider);

  // 1. Estados de carga o error
  if (state.status == Status.loading) {
    return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
  }

  if (state.error != null) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red)),
    );
  }

  if (state.incidences.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("Sin incidencias registradas"),
    );
  }

  // 2. Renderizado dinámico de la lista
  return Column(
    children: state.incidences.map((incidencia) {
      // Normalizamos el progreso (asumimos un máximo de 10 para la escala visual)
      final progress = (incidencia.incidenceCount / 10).clamp(0.0, 1.0);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(incidencia.componentName, 
                     style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Text("${incidencia.incidenceCount} veces", 
                     style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: progress, 
              color: Colors.purple,
              backgroundColor: Colors.purple.withOpacity(0.1),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
  Color _getColorForStatus(String status) {
    switch (status.toUpperCase()) {
      case 'CRÍTICO': 
        return const Color.fromARGB(255, 233, 18, 2);
      case 'ATENCIÓN': 
        return const Color.fromARGB(255, 255, 102, 0);
      case 'PENDIENTE': 
        return const Color.fromARGB(255, 16, 52, 209);
      default: 
        return Colors.grey;
    }
  }
}
