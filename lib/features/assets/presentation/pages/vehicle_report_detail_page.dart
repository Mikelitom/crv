import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vehicle_report_detail_model.dart';
import '../providers/vehicle_report_detail.dart';

class VehicleReportDetailPage extends ConsumerStatefulWidget {
  final String reportId;
  const VehicleReportDetailPage({super.key, required this.reportId});

  @override
  ConsumerState<VehicleReportDetailPage> createState() => _VehicleReportDetailPageState();
}

class _VehicleReportDetailPageState extends ConsumerState<VehicleReportDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(vehicleReportDetailProvider.notifier).fetchDetail(widget.reportId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleReportDetailProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de Inspección", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: state.isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : state.data == null 
              ? const Center(child: Text("No se pudieron cargar los datos del reporte.")) 
              : _buildContent(state.data!),
    );
  }

  Widget _buildContent(VehicleReportDetailModel data) {
    // Extraemos todas las evidencias de todas las respuestas
    final List<String> allPhotos = data.answers.expand((a) => a.evidencePaths).toList();
    
    // Obtenemos las notas de forma segura desde el mapa 'report'
    final String notes = (data.report['general_notes'] != null && data.report['general_notes'].toString().trim().isNotEmpty)
        ? data.report['general_notes'].toString()
        : "Sin observaciones adicionales.";

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Tarjeta de Notas Generales
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 20),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: const Text("Notas Generales", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(notes, style: const TextStyle(fontSize: 15)),
            ),
          ),
        ),
        
        // Galería de fotos (Solo si hay evidencias)
        if (allPhotos.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text("EVIDENCIAS FOTOGRÁFICAS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              crossAxisSpacing: 8, 
              mainAxisSpacing: 8
            ),
            itemCount: allPhotos.length,
            itemBuilder: (_, i) => InkWell(
              onTap: () => _showZoomImage(context, allPhotos[i]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  allPhotos[i], 
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.broken_image)),
                ),
              ),
            ),
          ),
        ] else
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No hay evidencias fotográficas registradas."))),
      ],
    );
  }

  // Método para ampliar la imagen
  void _showZoomImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.network(url),
        ),
      ),
    );
  }
}