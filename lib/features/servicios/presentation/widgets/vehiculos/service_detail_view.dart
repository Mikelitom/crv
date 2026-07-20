import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/service_item_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/evidence.dart';
import 'package:crv_reprosisa/features/servicios/presentation/dialogs/vehicle/complete_service_dialog.dart';
import 'package:crv_reprosisa/features/servicios/presentation/dialogs/vehicle/start_service_dialog.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_component_provider_v.dart';
import 'package:crv_reprosisa/features/servicios/presentation/utils/pdf_report_processor.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/vehiculos/create_order_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_report_detail.dart';
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
  String? _loadingPdfId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAllData();
    });
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
  ref.listen(attachItemsNotifierProvider, (previous, next) {
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
          content: Text("Error: ${next.error}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  });

  final state = ref.watch(serviceListNotifierProvider);

  return Scaffold(
    backgroundColor: const Color(0xFFF5F5F7),
    // Usamos LayoutBuilder para obtener el ancho real disponible
    body: LayoutBuilder(builder: (context, constraints) {
      // Definimos la lógica de columnas: 3 para escritorio, 2 para tablets, 1 para móvil
      int columns = constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 800 ? 2 : 1);
      double itemWidth = (constraints.maxWidth - (16 * (columns + 1))) / columns;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Header
            _buildContainer(child: _buildHeader(widget.vehicle)),
            const SizedBox(height: 16),

            // 2. Contadores
            _buildSummarySection(state.services),
            const SizedBox(height: 16),

            // 3. Paneles Superiores (Diseño Responsivo con Wrap)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: itemWidth, 
                  height: 450, 
                  child: _buildSectionContainer("COMPONENTES", _buildComponentesList(), height: 450)
                ),
                SizedBox(
                  width: itemWidth, 
                  height: 450, 
                  child: _buildSectionContainer("INCIDENTES", _buildRecurrenciaSection(), height: 450)
                ),
                SizedBox(
                  width: itemWidth, 
                  height: 450, 
                  child: _buildSectionContainer("INSPECCIONES", _buildInspeccionesList(), height: 450)
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Órdenes de Servicio
            _buildSectionContainer(
              "ÓRDENES DE SERVICIO",
              _buildOrdenServicioCard(state.services, context, ref),
              height: 450,
            ),
            
            const SizedBox(height: 16),

            // 5. Gestión de Evidencias
            _buildSectionContainer(
              "GESTIÓN DE EVIDENCIAS",
              _buildEvidenciasList(state.services),
              height: 250,
            ),
          ],
        ),
      );
    }),
  );
}
 

Widget _buildEvidenciasList(List<ServiceOrderModel> services) {
  final servicesWithEvidence = services.where((s) => s.evidences.isNotEmpty).toList();

  if (servicesWithEvidence.isEmpty) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off_outlined, size: 32, color: Colors.redAccent), // Rojo sutil
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
            border: Border.all(color: Colors.red.shade50), // Borde rojo tenue
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

void _showServiceEvidenceDialog(BuildContext context, ServiceOrderModel service) {
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

// Helpers ultra precisos para detección de iconos, colores oficiales y formatos
bool _isImageExtension(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  return ["png", "jpg", "jpeg", "gif", "webp", "bmp", "heic"].contains(ext);
}

IconData _getFileIconForEvidence(String fileName, String mimeType) {
  final ext = fileName.split('.').last.toLowerCase();
  
  if (mimeType.contains("pdf") || ext == "pdf") {
    return Icons.picture_as_pdf;
  }
  if (ext == "xlsx" || ext == "xls" || ext == "csv" || mimeType.contains("sheet") || mimeType.contains("excel") || mimeType.contains("spreadsheet")) {
    return Icons.table_chart; 
  }
  if (ext == "pptx" || ext == "ppt" || mimeType.contains("presentation") || mimeType.contains("powerpoint")) {
    return Icons.slideshow; 
  }
  if (ext == "docx" || ext == "doc" || mimeType.contains("word") || mimeType.contains("document")) {
    return Icons.description; 
  }
  if (ext == "mp4" || ext == "mov" || ext == "avi" || ext == "mkv" || mimeType.contains("video")) {
    return Icons.video_file;
  }
  if (ext == "zip" || ext == "rar" || mimeType.contains("zip")) {
    return Icons.folder_zip;
  }
  if (_isImageExtension(fileName) || mimeType.contains("image")) {
    return Icons.image;
  }
  return Icons.insert_drive_file;
}

Color _getFileColor(String fileName, String mimeType) {
  final ext = fileName.split('.').last.toLowerCase();

  if (mimeType.contains("pdf") || ext == "pdf") {
    return const Color(0xFFD32F2F); // Rojo PDF
  }
  if (ext == "xlsx" || ext == "xls" || ext == "csv" || mimeType.contains("sheet") || mimeType.contains("excel") || mimeType.contains("spreadsheet")) {
    return const Color(0xFF2E7D32); // Verde Excel
  }
  if (ext == "pptx" || ext == "ppt" || mimeType.contains("presentation") || mimeType.contains("powerpoint")) {
    return const Color(0xFFD84315); // Naranja PowerPoint
  }
  if (ext == "docx" || ext == "doc" || mimeType.contains("word") || mimeType.contains("document")) {
    return const Color(0xFF1565C0); // Azul Word
  }
  if (_isImageExtension(fileName) || mimeType.contains("image")) {
    return const Color(0xFF7B1FA2); // Morado Imagen
  }
  if (ext == "mp4" || ext == "mov" || mimeType.contains("video")) {
    return const Color(0xFFC2185B); // Rosa Video
  }
  return const Color(0xFF546E7A); // Gris neutro genérico
}

String _getFileTypeText(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  switch (ext) {
    case "pdf": return "Documento PDF";
    case "xlsx":
    case "xls":
    case "csv": return "Hoja de cálculo (Excel)";
    case "pptx":
    case "ppt": return "Presentación (PowerPoint)";
    case "docx":
    case "doc": return "Documento (Word)";
    case "png":
    case "jpg":
    case "jpeg":
    case "webp": return "Imagen";
    case "mp4":
    case "mov": return "Video";
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

  Widget _buildSectionContainer(
    String title,
    Widget content, {
    double height = 300,
  }) {
    return Container(
      width: double.infinity,
      height: height, // Altura fija que delimita el espacio
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
          // Header del contenedor sin el icono '+' inactivo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Al usar Expanded, el contenido (ListView) se limita al espacio sobrante.
          Expanded(child: content),
        ],
      ),
    );
  }

  Future<void> _viewPdfPreview(String versionId) async {
    try {
      final pdfBytes = await PdfReportProcessor.generatePdfFromVersionId(
        ref,
        versionId,
      );

      if (!mounted) return;

      if (pdfBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo generar la vista previa")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Vista Previa PDF")),
            body: PdfPreview(build: (format) => pdfBytes),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al generar la vista previa: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingPdfId = null);
      }
    }
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
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
  }

Widget _buildSummarySection(List<ServiceOrderModel> services) {
  final total = services.length;
  final pendientes = services.where((s) => s.status == "PENDING").length;
  final enProceso = services.where((s) => s.status == "IN_PROGRESS").length;
  final completados = services.where((s) => s.status == "COMPLETED").length;

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

  return LayoutBuilder(builder: (context, constraints) {
    double spacing = 16;
    int columns = (constraints.maxWidth > 1000) ? 4 : ((constraints.maxWidth > 600) ? 2 : 1);
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
  });
}

Widget _counterCard(String value, String label, Color color, IconData icon) {
  return StatefulBuilder(builder: (context, setSt) {
    return MouseRegion(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  });
}

Widget _buildComponentesList() {
  final state = ref.watch(pendingComponentNotifierProvider);

  if (state.isLoading) {
    return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Colors.red)));
  }

  if (state.error != null) {
    return Center(child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red)));
  }

  if (state.data.isEmpty) {
    return const Padding(padding: EdgeInsets.all(20), child: Center(child: Text("Sin componentes")));
  }

  final sortedData = List.from(state.data)..sort((a, b) {
    int getPriority(String status) {
      switch (status.toUpperCase()) {
        case 'CRÍTICO': return 1;
        case 'ATENCIÓN': return 2;
        case 'PENDIENTE': return 3;
        default: return 4;
      }
    }
    return getPriority(a.status).compareTo(getPriority(b.status));
  });

  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    itemCount: sortedData.length,
    separatorBuilder: (_, _) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final item = sortedData[index];
      final color = _getColorForStatus(item.status);

      return StatefulBuilder(builder: (context, setSt) {
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
                  child: Icon(_getIconForComponent(item.componentName), size: 18, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.componentName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      Text("Incidencias: ${item.incidenciasPrevias}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(item.status.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 9)),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

  IconData _getIconForComponent(String name) {
    final n = name.toLowerCase();
    if (n.contains("cables")) return Icons.electrical_services;
    if (n.contains("anticongelante")) return Icons.water_drop;
    if (n.contains("frenos")) return Icons.speed;
    if (n.contains("aceite")) return Icons.oil_barrel;
    if (n.contains("bujías")) return Icons.bolt;
    if (n.contains("golpes") || n.contains("carroceria")) return Icons.car_crash;
    if (n.contains("vidrios")) return Icons.crop_portrait;
    if (n.contains("espejos")) return Icons.visibility;
    if (n.contains("suspensión")) return Icons.settings_input_component;
    if (n.contains("llantas") || n.contains("llanta")) return Icons.tire_repair;
    if (n.contains("luces") || n.contains("foco") || n.contains("direccionales")) return Icons.lightbulb;
    if (n.contains("torreta")) return Icons.emergency_share;
    if (n.contains("cinturones")) return Icons.airline_seat_recline_normal;
    if (n.contains("herramienta") || n.contains("gato")) return Icons.build;
    if (n.contains("extintor")) return Icons.fire_extinguisher;
    if (n.contains("botiquín")) return Icons.medical_services;
    return Icons.settings;
  }

void _showAddItemsDialog(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) {
    final Set<String> selectedIds = {};

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
              child: StatefulBuilder(
                builder: (context, setDialogState) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 520),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Seleccionar componentes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: ref.watch(pendingComponentNotifierProvider).data.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final pendingState = ref.watch(pendingComponentNotifierProvider);
                              final item = pendingState.data[i];
                              final isSelected = selectedIds.contains(item.id);

                              return InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    if (isSelected) {
                                      selectedIds.remove(item.id);
                                    } else {
                                      selectedIds.add(item.id);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFC62828).withValues(alpha: 0.08)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFC62828)
                                          : Colors.grey.shade300,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: isSelected
                                            ? const Color(0xFFC62828)
                                            : Colors.grey.shade400,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.componentName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            color: isSelected ? const Color(0xFFC62828) : Colors.black87,
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedIds.isEmpty 
                                      ? Colors.grey.shade300 
                                      : const Color(0xFFC62828),
                                  foregroundColor: selectedIds.isEmpty 
                                      ? Colors.grey.shade600 
                                      : Colors.white,
                                  elevation: selectedIds.isEmpty ? 0 : 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: selectedIds.isEmpty
                                    ? null
                                    : () async {
                                        await ref
                                            .read(attachItemsNotifierProvider.notifier)
                                            .attachItems(
                                              serviceId,
                                              selectedIds.toList(),
                                            );
                                        _refreshAllData();
                                        if (context.mounted) Navigator.pop(context);
                                      },
                                child: const Text(
                                  "Confirmar",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

Widget _buildOrdenServicioCard(List<ServiceOrderModel> services, BuildContext context, WidgetRef ref) {
  final pending = services.where((s) => s.status == "PENDING").toList();
  final inProgress = services.where((s) => s.status == "IN_PROGRESS").toList();
  final completed = services.where((s) => s.status == "COMPLETED").toList();

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

Widget _buildOrderList(List<ServiceOrderModel> orders, BuildContext context, WidgetRef ref) {
  if (orders.isEmpty) {
    return const Center(child: Text("Sin órdenes", style: TextStyle(color: Colors.grey, fontSize: 11)));
  }
  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    itemCount: orders.length,
    itemBuilder: (context, index) => _buildServiceOrderItem(orders[index], context, ref),
  );
}

Widget _buildOrderColumn(String title, List<ServiceOrderModel> orders, Color color, BuildContext context, WidgetRef ref) {
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
  ServiceOrderModel order,
  BuildContext context,
  WidgetRef ref,
) {
  final isPending = order.status == "PENDING";
  final isInProgress = order.status == "IN_PROGRESS";
  final isCompleted = order.status == "COMPLETED";

  final completeState = ref.watch(completeVehicleServiceNotifierProvider);

  final buttonText = isPending ? "INICIAR" : (isInProgress ? "COMPLETAR" : "COMPLETADA");
  final statusColor = isCompleted ? Colors.green : (isInProgress ? Colors.orange : const Color.fromARGB(255, 227, 18, 18));

  final String displayId = order.id.length >= 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase();
  final String displayReportId = order.reportId.isNotEmpty ? (order.reportId.length >= 6 ? order.reportId.substring(0, 6) : order.reportId) : "N/A";

  return StatefulBuilder(builder: (context, setSt) {
    return MouseRegion(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [],
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
                    await _showStartServiceDialog(context, order);
                  } else if (isInProgress) {
                    showDialog(
                      context: context, 
                      builder: (_) => CompleteServiceDialog(
                        order: order, 
                        vehicleId: order.vehicleId, 
                        onCompleted: () async => _refreshAllData()
                      )
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
      ),
    );
  });
}

Widget _iconActionButton(IconData icon, Color color, VoidCallback onPressed, bool disabled) {
  return IconButton(
    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    padding: EdgeInsets.zero,
    icon: Icon(icon, size: 18, color: disabled ? Colors.grey.shade300 : color),
    onPressed: disabled ? null : onPressed,
  );
}

void _showServiceItemsDialog(
    BuildContext context,
    WidgetRef ref,
    String serviceId,
  ) {
    ref.read(serviceItemsNotifierProvider.notifier).loadServiceItems(serviceId);

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
                    final state = ref.watch(serviceItemsNotifierProvider);

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
                              final model = state.items[index] as ServiceItemModel;

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: model.statusColor,
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
                                            "Estado: ${model.statusTranslated}",
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

  Future<void> _showStartServiceDialog(
    BuildContext context,
    ServiceOrderModel order,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          StartServiceDialog(order: order, vehicleId: widget.vehicle.vehicleId),
    );
  }

Widget _buildInspeccionesList() {
  final historyState = ref.watch(vehicleHistoryProvider);

  if (historyState.status == Status.loading) {
    return const Center(child: CircularProgressIndicator(color: Colors.red));
  }

  if (historyState.history.isEmpty) {
    return const Center(child: Text("Sin inspecciones registradas"));
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
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text("${h.inspectionDate.day}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      Text(_getSpanishMonth(h.inspectionDate.month), style: const TextStyle(fontSize: 9, color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Inspección general", 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                  Row(
                    children: [
                      isLoading 
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 16, 
                              height: 16, 
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red)
                            ),
                          )
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
                                  await _viewPdfPreview(h.versionId);
                                  if (mounted) setState(() => _loadingPdfId = null);
                                },
                              ),
                              const SizedBox(width: 4),
                              _actionButton(
                                Icons.download, 
                                Colors.red, 
                                () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Descargando reporte PDF..."),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  setState(() => _loadingPdfId = h.versionId);
                                  await _showPdf(h.versionId);
                                  if (mounted) setState(() => _loadingPdfId = null);
                                },
                              ),
                            ],
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
        borderRadius: BorderRadius.circular(8)
      ),
      child: Icon(icon, size: 16, color: color),
    ),
  );
}

String _getSpanishMonth(int month) {
  const months = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
  return months[month - 1];
}

Widget _buildHeader(Vehicle v) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
          ),
          child: const Icon(Icons.directions_car, size: 30, color: Colors.grey),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${v.brand} ${v.model} - ${v.plate}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Km: ${v.mileage}",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
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
              builder: (_) => CreateOrderDialog(vehicleId: v.vehicleId),
            ).then((_) => _refreshAllData());
          },
          icon: const Icon(Icons.add, size: 14),
          label: const Text("ORDEN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

Widget _buildRecurrenciaSection() {
  final state = ref.watch(incidenceNotifierProvider);

  if (state.status == Status.loading) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: Colors.red),
      ),
    );
  }

  if (state.error != null) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Error: ${state.error}",
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  if (state.incidences.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          "Sin incidencias registradas",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    itemCount: state.incidences.length,
    itemBuilder: (context, index) {
      final incidencia = state.incidences[index];
      final progress = (incidencia.incidenceCount / 10).clamp(0.0, 1.0);

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    incidencia.componentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${incidencia.incidenceCount} veces",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.red,
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
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
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

  void _refreshAllData() {
    final vehicleId = widget.vehicle.vehicleId;
    ref.read(serviceListNotifierProvider.notifier).loadServices(vehicleId);
    ref.read(vehicleHistoryProvider.notifier).loadHistory(vehicleId);
    ref
        .read(pendingComponentNotifierProvider.notifier)
        .loadPendingComponents(vehicleId);
    ref.read(incidenceNotifierProvider.notifier).loadIncidences(vehicleId);
  }
}