import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../provider/banda_inspection_state.dart'; 
import '../provider/banda_inspection_providers.dart';
import '../../widgets/banda_section_table.dart';
import '../../widgets/customer_section.dart';
import '../../widgets/general_banda.dart';
import '../../widgets/rodilleria_section.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../../../prensas_industriales/presentation/widgets/capture_method_selector.dart';
import '../../../../core/utils/banda_pdf_generator.dart';
import '../../../../features/evidence/presentation/providers/evidence_service_provider.dart';

class BandaInspectionPage extends ConsumerStatefulWidget {
  final bool isReadOnly; // <--- Parámetro de edición
  const BandaInspectionPage({super.key, this.isReadOnly = false});

  @override
  ConsumerState<BandaInspectionPage> createState() => _BandaInspectionPageState();
}

class _BandaInspectionPageState extends ConsumerState<BandaInspectionPage> {
  int _currentSectionIndex = 0;
  final bool _mostrarRodilleria = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bandaInspectionProvider.notifier).initialLoad();
    });
  }

  Future<void> _guardarReporte() async {
    final state = ref.read(bandaInspectionProvider);
    final evidenceService = ref.read(evidenceServiceProvider);

    if (state.selectedClient == null || state.selectedMine == null) {
      _showSnack("Selecciona cliente y mina antes de continuar", Colors.orange);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final List<Map<String, dynamic>> answers = [];

      for (var section in state.sections) {
        for (var component in section.components) {
          if (component.selectedOptionId == null) continue;

          final List<Map<String, String>> evidenceList = [];
          final allFiles = [...component.evidenceBefore, ...component.evidenceAfter];

          for (var evFile in allFiles) {
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/banda_${DateTime.now().microsecondsSinceEpoch}.jpg');
            await file.writeAsBytes(evFile.bytes);

            final uploadResult = await evidenceService.uploadEvidence(
              file: file,
              basePath: 'inspecciones/bandas',
            );

            uploadResult.fold(
              (l) => print("Error subida: ${l.message}"),
              (dto) => evidenceList.add({
                "file_path": dto.filePath,
                "file_type": dto.fileType,
                "mime_type": dto.mimeType,
                "file_size": dto.fileSize.toString(),
              }),
            );
          }

          answers.add({
            "accesory_id": component.id,
            "option_id": component.selectedOptionId,
            "recommended_action": component.observation,
            "dimentions": double.tryParse(component.dimension) ?? 0,
            "evidences": evidenceList,
          });
        }
      }

      final reportRequest = {
        "conveyor": state.conveyor.isEmpty ? "N/A" : state.conveyor, 
        "area": state.selectedMine?.name ?? "",
        "mine_id": state.selectedMine?.id ?? "",
        "inspection_date": state.inspectionDate.toIso8601String(),
        "conveyor_responsible": state.conveyorResponsible.isEmpty ? "N/A" : state.conveyorResponsible,
        "recommended_belt": state.recommendedBelt.isEmpty ? "N/A" : state.recommendedBelt,
        "material": state.material.isEmpty ? "N/A" : state.material,
        "granulometry": state.granulometry.isEmpty ? "N/A" : state.granulometry,
        "present_to": state.presentTo.isEmpty ? "N/A" : state.presentTo,
        "state": "IN_PROGRESS",
        "folio": "B-${DateTime.now().millisecondsSinceEpoch}",
        "answers": answers,
      };

      final result = await ref.read(createBandaReportUseCaseProvider).call(reportRequest);

      result.fold(
        (f) => _showSnack("Error al guardar: ${f.message}", Colors.red),
        (id) {
          _showSnack("¡Reporte de banda guardado con éxito!", Colors.green);
          ref.read(bandaInspectionProvider.notifier).initialLoad();
          Navigator.pop(context);
        }
      );
    } catch (e) {
      _showSnack("Error inesperado", Colors.red);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
  }

  void _showPreview(BuildContext context) async {
    final state = ref.read(bandaInspectionProvider);
    
    String seccionActual = "";
    if (_currentSectionIndex < state.sections.length) {
      seccionActual = state.sections[_currentSectionIndex].name;
    } else if (_mostrarRodilleria) {
      seccionActual = "RODILLERÍA";
    }

    final Map<String, dynamic> generalData = {
      'planta': state.selectedClient?.name ?? "N/A", 
      'area': state.selectedMine?.name ?? "N/A",
      'responsable': state.conveyorResponsible.isEmpty ? "N/A" : state.conveyorResponsible, 
      'fecha': state.inspectionDate.toString().split(' ')[0],
      'banda': state.recommendedBelt.isEmpty ? "N/A" : state.recommendedBelt, 
      'transportador': state.conveyor.isEmpty ? "N/A" : state.conveyor,
      'material': state.material.isEmpty ? "N/A" : "${state.material} / ${state.granulometry}",
      'elaboro': state.elaboro,
      'presentar': state.presentTo.isEmpty ? "N/A" : state.presentTo,
      'comentarios': state.generalComments,
      'seccion': seccionActual,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      final pdfBytes = await BandaPdfGenerator.generateReport(generalData, state.sections);
      
      if (context.mounted) {
        Navigator.pop(context); 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text("REPORTE TÉCNICO"), backgroundColor: const Color(0xFFB71C1C)),
              body: PdfPreview(
                build: (format) => pdfBytes,
                initialPageFormat: PdfPageFormat.letter.landscape,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showSnack("Error al generar vista previa: $e", Colors.red);
      }
    }
  }

  Widget _buildNavigationBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context), 
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD32F2F).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded, 
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bandaInspectionProvider);
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    List<String> pasos = state.sections.map((s) => s.name).toList();
    if (_mostrarRodilleria) pasos.add("RODILLERÍA");

    if (state.isLoading || _isSaving) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFFB71C1C))));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: CustomHeader(title: "Inspección de Bandas"),
                ),
                const SizedBox(width: 16),
                _buildNavigationBackButton(context),
              ],
            ),
            const SizedBox(height: 24),
            CaptureMethodSelector(onManualFill: () {}, onScan: () {}),
            const SizedBox(height: 24),
            const CustomerSection(),
            const SizedBox(height: 24),
            const GeneralBandaInfo(),
            const SizedBox(height: 32),
            _buildStepper(pasos),
            const SizedBox(height: 24),
            if (state.sections.isNotEmpty) _buildActiveContent(state),
            const SizedBox(height: 32),
            _buildFooter(pasos.length, isMobile),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveContent(BandaInspectionState state) {
    if (_mostrarRodilleria && _currentSectionIndex == state.sections.length) {
      return const RodilleriaSection();
    }
    if (_currentSectionIndex < state.sections.length) {
      final section = state.sections[_currentSectionIndex];
      return BandaSectionTable(
        sectionId: section.id,
        sectionTitle: section.name,
        sectionNumber: _currentSectionIndex + 1,
        items: section.components,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStepper(List<String> pasos) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(pasos.length, (index) {
        bool isActive = index == _currentSectionIndex;
        return InkWell(
          onTap: () => setState(() => _currentSectionIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFB71C1C) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              pasos[index].toUpperCase(),
              style: TextStyle(color: isActive ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFooter(int total, bool isMobile) {
    bool esUltimo = _currentSectionIndex == total - 1;
    if (isMobile) {
      return Column(
        children: [
          _btnSiguiente(esUltimo, true),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: _btnAnterior()), const SizedBox(width: 12), Expanded(child: _btnVistaPrevia())]),
        ],
      );
    }
    return Row(
      children: [
        _btnAnterior(),
        const Spacer(),
        _btnVistaPrevia(),
        const SizedBox(width: 12),
        _btnSiguiente(esUltimo, false),
      ],
    );
  }

  Widget _btnAnterior() => OutlinedButton(
    onPressed: _currentSectionIndex > 0 ? () => setState(() => _currentSectionIndex--) : null,
    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
    child: const Text("ANTERIOR"),
  );

  Widget _btnVistaPrevia() => ElevatedButton.icon(
    onPressed: () => _showPreview(context),
    icon: const Icon(Icons.remove_red_eye),
    label: const Text("VISTA PREVIA"),
    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade900, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
  );

  Widget _btnSiguiente(bool esUltimo, bool fullWidth) => SizedBox(
    width: fullWidth ? double.infinity : null,
    child: ElevatedButton(
      onPressed: () {
        if (!esUltimo) setState(() => _currentSectionIndex++);
        else _guardarReporte();
      },
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB71C1C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40)),
      child: Text(esUltimo ? "FINALIZAR REPORTE" : "SIGUIENTE"),
    ),
  );
}