// lib/features/assets/presentation/pages/conveyor_report_detail_page.dart
import 'package:crv_reprosisa/features/assets/presentation/providers/client_actions_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConveyorReportDetailPage extends ConsumerStatefulWidget {
  final String reportId;
  const ConveyorReportDetailPage({super.key, required this.reportId});

  @override
  ConsumerState<ConveyorReportDetailPage> createState() => _ConveyorReportDetailPageState();
}

class _ConveyorReportDetailPageState extends ConsumerState<ConveyorReportDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(conveyorReportDetailProvider.notifier).fetchDetail(widget.reportId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conveyorReportDetailProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle Técnico de Banda")),
      body: state.isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCategoryCard("ZONA DE CARGA", ["Zona de impacto", "Faldón metálico", "Soportes de carga"]),
                _buildCategoryCard("CABEZA", ["Polea de cabeza", "Raspadores", "Tolva de traspaso"]),
                _buildCategoryCard("RETORNO", ["Banda de retorno", "Rodillos de retorno", "Alineación"]),
                _buildCategoryCard("CONTRAPESO", ["Polea de contrapeso", "Poleas dobladoras", "Desviador"]),
              ],
            ),
    );
  }

  Widget _buildCategoryCard(String title, List<String> components) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: components.map((comp) => ListTile(title: Text(comp))).toList(),
      ),
    );
  }
}