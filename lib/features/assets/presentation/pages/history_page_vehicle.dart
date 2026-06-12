import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle_report_detail_entity.dart';

import '../widgets/history_card.dart';

class HistoryPage extends ConsumerStatefulWidget {
  final String assetId;
  final String title;

  const HistoryPage({super.key, required this.assetId, required this.title});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  static const Color primaryRed = Color(0xFFC62828);

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(vehicleHistoryProvider.notifier).loadHistory(widget.assetId),
    );
  }

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200 ? response.bodyBytes : null;
    } catch (e) { return null; }
  }

  // --- AGRUPAR VERSIONES POR FOLIO (V1, V2...) ---
  Map<String, List<dynamic>> _groupVersions(List<dynamic> history) {
    Map<String, List<dynamic>> grouped = {};
    for (var item in history) {
      if (!grouped.containsKey(item.folio)) grouped[item.folio] = [];
      grouped[item.folio]!.add(item);
    }
    return grouped;
  }

  // --- TRADUCTOR DE ENTIDAD A MAPA CON NORMALIZACIÓN DE ESTADOS ---
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

  // --- LÓGICA ASÍNCRONA PARA OBTENER BYTES DE PDF POBLADOS CON IMÁGENES ---
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

  Future<void> _viewPdfPreview(item) async {
    final pdfBytes = await _generatePdfBytes(item.versionId);
    if (pdfBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al cargar detalle")));
      return;
    }

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(title: const Text("Vista Previa PDF"), backgroundColor: primaryRed),
      body: PdfPreview(build: (format) => pdfBytes),
    )));
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: primaryRed)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() { if (isStart) _startDate = picked; else _endDate = picked; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleHistoryProvider);
    final filteredHistory = state.history.where((item) {
      if (_startDate == null || _endDate == null) return true;
      return item.inspectionDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          item.inspectionDate.isBefore(_endDate!.add(const Duration(days: 1)));
    }).toList();

    final groupedFolios = _groupVersions(filteredHistory);
    final foliosKeys = groupedFolios.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: state.status == Status.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: foliosKeys.length,
                    itemBuilder: (_, index) {
                      final folioKey = foliosKeys[index];
                      final versionsList = groupedFolios[folioKey]!;
                      
                      final currentItem = versionsList.firstWhere(
                        (v) => v.isCurrent == true, 
                        orElse: () => versionsList.first
                      );

                      return HistoryCard(
                        versions: versionsList,
                        onDownloadPressed: () async {
                          final pdfBytes = await _generatePdfBytes(currentItem.versionId);
                          if (pdfBytes != null && mounted) {
                            await Printing.sharePdf(bytes: pdfBytes, filename: 'Reporte_${currentItem.folio}.pdf');
                          }
                        },
                        onPrintPressed: () async {
                          final pdfBytes = await _generatePdfBytes(currentItem.versionId);
                          if (pdfBytes != null && mounted) {
                            await Printing.layoutPdf(onLayout: (_) => pdfBytes);
                          }
                        },
                        onPdfPreviewPressed: () => _viewPdfPreview(currentItem),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _dateField(_startDate, () => _selectDate(context, true))),
          const SizedBox(width: 10),
          Expanded(child: _dateField(_endDate, () => _selectDate(context, false))),
        ],
      ),
    );
  }

  Widget _dateField(DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(date == null ? 'dd / mm / aaaa' : DateFormat('dd/MM/yyyy').format(date)),
            ),
            const Icon(Icons.calendar_today_outlined, size: 18, color: primaryRed),
          ],
        ),
      ),
    );
  }
}