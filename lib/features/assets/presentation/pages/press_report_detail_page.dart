import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/press_report_detail_provider.dart';

class PressReportDetailPage extends ConsumerStatefulWidget {
  final String reportId;
  const PressReportDetailPage({super.key, required this.reportId});

  @override
  ConsumerState<PressReportDetailPage> createState() => _PressReportDetailPageState();
}

class _PressReportDetailPageState extends ConsumerState<PressReportDetailPage> {
  @override
  void initState() {
    super.initState();
    // Carga automática del detalle al entrar a la página
    Future.microtask(() => 
        ref.read(pressReportDetailProvider.notifier).fetchDetail(widget.reportId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pressReportDetailProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Reporte")),
      body: state.isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : state.data == null 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No se encontró información"),
                      TextButton(
                        onPressed: () => ref.read(pressReportDetailProvider.notifier).fetchDetail(widget.reportId),
                        child: const Text("Reintentar"),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderInfo(state.data!),
                      const SizedBox(height: 20),
                      const Text("COMPONENTES INSPECCIONADOS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 10),
                      ...state.data!.answers.map((answer) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(answer.componentName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(answer.observation.isEmpty ? "Sin observaciones" : answer.observation),
                          trailing: _buildStatusBadge(answer.status),
                        ),
                      )),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeaderInfo(data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Responsable: ${data.responsibleName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Folio: ${data.report['folio'] ?? 'N/A'}", style: const TextStyle(fontSize: 14)),
        Text("Área: ${data.report['area'] ?? 'N/A'}", style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == "GOOD" ? Colors.green : (status == "BAD" ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}