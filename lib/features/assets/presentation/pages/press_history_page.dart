import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

import '../providers/press_history_provider.dart';
import '../providers/press_report_detail_provider.dart';
import '../widgets/press_history_card.dart';
import '../../presentation/states/status.dart';
import '../pages/pdf_viewer_page.dart';
import '../../domain/entities/press_history.dart';
import '../../../../core/utils/SGC-PO-MT-01-FO-08-PRESS.dart';
import '../../../../core/config/dio_client.dart';
import 'package:dio/dio.dart' as dio_package;

class PressHistoryPage extends ConsumerStatefulWidget {
  final String pressId;
  final String title;

  const PressHistoryPage({super.key, required this.pressId, required this.title});

  @override
  ConsumerState<PressHistoryPage> createState() => _PressHistoryPageState();
}

class _PressHistoryPageState extends ConsumerState<PressHistoryPage> {
  
  final List<String> ordenOficial = [
    "NIVELES DE ACEITE", "MANOMETRO EN CERO", "PRENSA EN MODO MANUAL", 
    "PRENSA EN MODO AUTOMÁTICO", "PRENSA TEMPERATURA AMBIENTE AL INICIAR",
    "DE 10-30 MINUTOS TEMPERATURA A 140-160 C°", "MANGUERAS DE ACEITE", 
    "CABLEADO", "RUIDOS INUSUALES", "CAJA DE CONTROL Y/O CABEZAS DE CONTROL", 
    "PLATO SUPERIOR", "PLATO INFERIOR", "CÁMARA DE PRESIÓN Y/O ACOPLE RÁPIDO", 
    "CALIBRADO DE PRESIÓN Y/O MANGUERA DE LLENADO", "TORNILLOS Y/O PERNOS", 
    "PLATOS DE COMPENSADORES DE CALOR", "RIELES", "MANGUERAS PARA ENFRIAMIENTO", 
    "SEGUROS DE RIELES", "SISTEMA DE PRESIÓN: BOMBA /COMPRESOR", 
    "LIMPIEZA", "ESTRUCTURA/ SOLDADURA", "CABLES TERMOPARES Y LECTOR"
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pressHistoryProvider.notifier).loadHistory(widget.pressId));
  }

  // --- AGRUPAR VERSIONES POR FOLIO (V1, V2...) ---
  Map<String, List<PressHistory>> _groupVersions(List<PressHistory> history) {
    Map<String, List<PressHistory>> grouped = {};
    for (var item in history) {
      if (!grouped.containsKey(item.folio)) grouped[item.folio] = [];
      grouped[item.folio]!.add(item);
    }
    return grouped;
  }

  Future<Uint8List?> _downloadImageBytes(String url) async {
    try {
      final dio = ref.read(dioProvider); 
      final response = await dio.get(url, options: dio_package.Options(responseType: dio_package.ResponseType.bytes));
      return response.statusCode == 200 ? Uint8List.fromList(response.data) : null;
    } catch (e) {
      debugPrint("Error descargando imagen: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getReportData(PressHistory item) async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    
    await ref.read(pressReportDetailProvider.notifier).fetchDetail(item.versionId);
    final state = ref.read(pressReportDetailProvider);
    
    if (state.data == null) {
      if (mounted) Navigator.pop(context);
      return null;
    }

    List<Map<String, dynamic>> itemsOrdenados = [];
    List<dynamic> respuestasPendientes = List.from(state.data!.answers);

    for (var nombre in ordenOficial) {
      var index = respuestasPendientes.indexWhere((a) => 
        a.componentName.toUpperCase().trim() == nombre.toUpperCase().trim()
      );
      if (index != -1) {
        itemsOrdenados.add(await _mapAnswerToMap(respuestasPendientes.removeAt(index)));
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

  Future<Map<String, dynamic>> _mapAnswerToMap(dynamic answer) async {
    Uint8List? bytesAntes;
    Uint8List? bytesDespues;
    if (answer.evidencePaths.length >= 1) bytesAntes = await _downloadImageBytes(answer.evidencePaths[0]);
    if (answer.evidencePaths.length >= 2) bytesDespues = await _downloadImageBytes(answer.evidencePaths[1]);

    return {
      'name': answer.componentName, 
      'status': answer.status,
      'observation': (answer.observation == "Notaas" || answer.observation.isEmpty) ? '' : answer.observation,
      'measureUnit': answer.measureUnit,
      'quantity': answer.quantity,
      'foto_antes_bytes': bytesAntes,
      'foto_despues_bytes': bytesDespues 
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pressHistoryProvider);
    
    // Agrupamos el historial por folio para construir los dropdowns en la tarjeta
    final groupedFolios = _groupVersions(state.history);
    final foliosKeys = groupedFolios.keys.toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: state.status == Status.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: foliosKeys.length,
              itemBuilder: (context, index) {
                final folioKey = foliosKeys[index];
                final versionsList = groupedFolios[folioKey]!;
                
                // Versión activa actual por defecto
                final currentItem = versionsList.firstWhere(
                  (v) => v.isCurrent == true, 
                  orElse: () => versionsList.first
                );

                return PressHistoryCard(
                  versions: versionsList,
                  onDetailsPressed: (versionId) async {
                    final targetItem = versionsList.firstWhere((v) => v.versionId == versionId, orElse: () => currentItem);
                    final data = await _getReportData(targetItem);
                    if (data != null) {
                      final pdfBytes = await PrensaPdfGenerator.generateEsqueleto(data);
                      await Printing.sharePdf(bytes: pdfBytes, filename: 'Reporte_${data['folio']}.pdf');
                    }
                  },
                  onPdfPreviewPressed: (versionId) async {
                    final targetItem = versionsList.firstWhere((v) => v.versionId == versionId, orElse: () => currentItem);
                    final data = await _getReportData(targetItem);
                    if (data != null && mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerPage(datos: data)));
                  },
                  onPrintPressed: (versionId) async {
                    final targetItem = versionsList.firstWhere((v) => v.versionId == versionId, orElse: () => currentItem);
                    final data = await _getReportData(targetItem);
                    if (data != null) {
                      final pdfBytes = await PrensaPdfGenerator.generateEsqueleto(data);
                      await Printing.layoutPdf(onLayout: (_) => pdfBytes);
                    }
                  },
                );
              },
            ),
    );
  }
}