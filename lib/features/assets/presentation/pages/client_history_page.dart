
import 'package:crv_reprosisa/core/utils/conveyor_pdf_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import 'package:crv_reprosisa/features/assets/presentation/providers/conveyor_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/client_history_card.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/client_history.dart';
import 'package:crv_reprosisa/core/utils/banda_pdf_generator.dart';
import 'client_pdf_viewer_page.dart';

class ClientHistoryPage extends ConsumerStatefulWidget {
  final String clientId;
  const ClientHistoryPage({super.key, required this.clientId});

  @override
  ConsumerState<ClientHistoryPage> createState() => _ClientHistoryPageState();
}

class _ClientHistoryPageState extends ConsumerState<ClientHistoryPage> {
  final String _query = "";
  DateTime? _start;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          ref.read(clientHistoryProvider.notifier).loadHistory(widget.clientId),
    );
  }

  Map<String, List<ClientHistory>> _groupData(List<ClientHistory> history) {
    Map<String, List<ClientHistory>> grouped = {};
    for (var item in history) {
      if (!grouped.containsKey(item.folio)) grouped[item.folio] = [];
      grouped[item.folio]!.add(item);
    }
    return grouped;
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientHistoryProvider);
    final filtered = state.history
        .where(
          (h) =>
              h.folio.toLowerCase().contains(_query.toLowerCase()) &&
              (_start == null || h.inspectionDate.isAfter(_start!)),
        )
        .toList();
    final grouped = _groupData(filtered);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          "Expediente Digital",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: state.status == Status.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: grouped.entries
                        .map(
                          (e) => ClientHistoryCard(
                            versions: e.value,
                            onPdfView: (versionId) async {
                              final pdfData = await ConveyorPdfProcessor.getPdfData(
                                ref,
                                versionId,
                              );
                            
                              if (pdfData == null || !mounted) return;
                            
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ClientPdfViewerPage(
                                    folio: e.key,
                                    pdfGenerator: () => BandaPdfGenerator.generateReport(
                                      pdfData.datosNormalizados,
                                      pdfData.sections,
                                      pdfData.rodillos,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onDownload: (versionId) async {
                              final pdf =
                                  await ConveyorPdfProcessor.generatePdfFromVersionId(
                                ref,
                                versionId,
                              );
                            
                              if (pdf == null) return;
                            
                              await Printing.sharePdf(
                                bytes: pdf,
                                filename: 'Reporte_${e.key}.pdf',
                              );
                            },
                            onPrint: (versionId) async {
                              final pdfBytes =
                                  await ConveyorPdfProcessor.generatePdfFromVersionId(
                                ref,
                                versionId,
                              );
                              if (pdfBytes == null) return;
                              await Printing.layoutPdf(
                                onLayout: (_) async => pdfBytes,
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
