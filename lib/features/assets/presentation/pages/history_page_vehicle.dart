import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_history_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-03-VEHICLE.dart';

import '../widgets/history_card.dart';
import 'vehicle_report_detail_page.dart';

class HistoryPage extends ConsumerStatefulWidget {
  final String assetId;
  final String title;

  const HistoryPage({
    super.key,
    required this.assetId,
    required this.title,
  });

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
    // Carga inicial al iniciar la pantalla
    Future.microtask(() => 
      ref.read(vehicleHistoryProvider.notifier).loadHistory(widget.assetId)
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primaryRed),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleHistoryProvider);

    // Lógica de filtrado
    final filteredHistory = state.history.where((item) {
      if (_startDate == null || _endDate == null) return true;
      return item.inspectionDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
             item.inspectionDate.isBefore(_endDate!.add(const Duration(days: 1)));
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: state.status == Status.loading
                ? const Center(child: CircularProgressIndicator())
                : filteredHistory.isEmpty
                    ? const Center(child: Text("No se encontraron registros."))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: filteredHistory.length,
                        itemBuilder: (_, index) {
                          final item = filteredHistory[index];
                          return HistoryCard(
                            item: item,
                            onDetailsPressed: () {
                              // Asegúrate de enviar el 'reportId' correcto para el detalle
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VehicleReportDetailPage(reportId: item.reportId),
                                ),
                              );
                            },
                            onDownloadPressed: () async {
                              final pdfBytes = await VehiculoPdfGenerator.generateEsqueleto(item.toJson());
                              await Printing.sharePdf(bytes: pdfBytes, filename: 'Reporte_${item.folio}.pdf');
                            },
                            onPrintPressed: () async {
                              final pdfBytes = await VehiculoPdfGenerator.generateEsqueleto(item.toJson());
                              await Printing.layoutPdf(onLayout: (_) => pdfBytes);
                            },
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
              child: Text(
                date == null ? 'dd / mm / aaaa' : DateFormat('dd/MM/yyyy').format(date),
                style: TextStyle(color: date == null ? Colors.grey : Colors.black),
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 18, color: primaryRed),
          ],
        ),
      ),
    );
  }
}