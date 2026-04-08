import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'package:crv_reprosisa/core/utils/SGC-PO-MT-01-FO-08-PRESS.DART';
import '../../domain/entities/component_item.dart';
import '../provider/inspeccion_providers.dart';
import '../widgets/information_general_equipo.dart';
import '../widgets/table_componentes_press.dart';
import '../widgets/capture_method_selector.dart';
import '../widgets/prestamo_devolucion.dart';
import '../../../dashboard/presentation/widgets/header.dart';

class PrensaInspectionPage extends ConsumerStatefulWidget {
  const PrensaInspectionPage({super.key});

  @override
  ConsumerState<PrensaInspectionPage> createState() =>
      _PrensaInspectionPageState();
}

class _PrensaInspectionPageState extends ConsumerState<PrensaInspectionPage> {
  bool isScanning = false;
  bool isLoading = true;
  List<ComponentItem> templateItems = [];

  @override
  void initState() {
    super.initState();
    _fetchTemplate();
  }

  Future<void> _fetchTemplate() async {
    final repo = ref.read(inspeccionRepositoryProvider);
    final result = await repo.getInspectionTemplate();
    result.fold(
      (failure) => setState(() => isLoading = false),
      (components) => setState(() {
        templateItems = components;
        isLoading = false;
      }),
    );
  }

  void _showPdfPreview(BuildContext context) {
    final state = ref.read(inspeccionProvider);
    final String fechaActual = DateTime.now().toString().split(' ').first;

    final Map<String, dynamic> pdfData = {
      "codigo_doc": "SGC-PO-MT-01-FO-08",
      "fecha": fechaActual,
      "area": state.area,
      // MAPEAMOS LAS VARIABLES EXACTAS DE TU ENTIDAD
      "tipo": state.selectedPress?.type ?? "",
      "modelo": state.selectedPress?.model ?? "",
      "volts": state.selectedPress?.voltz ?? "",
      "serie": state.selectedPress?.serie ?? "",
      "items": templateItems
          .map(
            (item) => {
              "cant": item.quantity,
              "unidad": item.measureUnit,
              "descripcion": item.name,
              "estado": item.estado,
              "observaciones": item.observaciones,
            },
          )
          .toList(),
      "area_solicita": "Taller Solicitante",
      "obs_footer": "Ninguna",
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Vista Previa REPROSISA"),
            backgroundColor: const Color(0xFFC62828),
          ),
          body: PdfPreview(
            build: (format) => PrensaPdfGenerator.generateEsqueleto(pdfData),
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            initialPageFormat: PdfPageFormat.letter,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFC62828)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: Column(
                    children: [
                      CustomHeader(
                        title: "Inspección de Prensas",
                        actionIcon: Icons.build_rounded,
                        onActionTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 32),
                      CaptureMethodSelector(
                        onManualFill: () => setState(() => isScanning = false),
                        onScan: () => setState(() => isScanning = true),
                      ),
                      const SizedBox(height: 32),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: isScanning
                            ? _buildScannerView()
                            : _buildFormView(templateItems),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showPdfPreview(context),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("VISTA PREVIA PDF"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade700,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(200, 65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.check_circle),
                            label: const Text("FINALIZAR REPORTE"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(200, 65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildScannerView() => Container(
    height: 400,
    color: Colors.black,
    child: const Center(
      child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 80),
    ),
  );

  Widget _buildFormView(List<ComponentItem> data) => Column(
    children: [
      const InformationGeneralEquipo(),
      const SizedBox(height: 24),
      PrensaInspectionTable(items: data),
      const SizedBox(height: 24),
      const LoanAndInspectorSection(),
    ],
  );
}

