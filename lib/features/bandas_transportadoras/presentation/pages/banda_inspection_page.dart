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
  final bool isReadOnly;
  const BandaInspectionPage({super.key, this.isReadOnly = false});

  @override
  ConsumerState<BandaInspectionPage> createState() => _BandaInspectionPageState();
}

class _BandaInspectionPageState extends ConsumerState<BandaInspectionPage> {
  int _currentSectionIndex = 0;
  final bool _mostrarRodilleria = true;
  bool _isSaving = false;

  // 🔹 Llave global para identificar el inicio de la tabla/sección
  final GlobalKey _sectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bandaInspectionProvider.notifier).initialLoad();
    });
  }

  // 🔹 Función para desplazar la vista exactamente al inicio de la sección
  void _scrollToSectionStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _sectionKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.0, // Alinea el widget al top
        );
      }
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

      final List<Map<String, dynamic>> rollersData = state.rollers.map((r) => {
        "table_number": r.tableNumber,
        "base_number": r.baseNumber,
        "is_left": r.isLeft ?? false,
        "is_center": r.isCenter ?? false,
        "is_right": r.isRight ?? false,
        "is_impact": r.isImpact ?? false,
        "is_return": r.isReturn ?? false,
        "is_triple": r.isTriple ?? false,
        "is_self_aligning": r.isSelfAligning ?? false,
        "roller_type": r.rollerType ?? "",
      }).toList();

      final reportRequest = {
        "conveyor": state.conveyor.isEmpty ? "" : state.conveyor, 
        "area": state.area,
        "mine_id": state.selectedMine?.id ?? "",
        "inspection_date": state.inspectionDate.toIso8601String(),
        "section": state.seccion.isEmpty ? "" : state.seccion,
        "recommended_belt": state.recommendedBelt.isEmpty ? "" : state.recommendedBelt,
        "material": state.material.isEmpty ? "" : state.material,
        "granulometry": state.granulometry.isEmpty ? "" : state.granulometry,
        "present_to": state.presentTo.isEmpty ? "" : state.presentTo,
        "state": "IN_PROGRESS",
        "conveyor_responsible": state.conveyorResponsible,
        "folio": "B-${DateTime.now().millisecondsSinceEpoch}",
        "answers": answers,
        "rollers": rollersData,
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
    final Map<String, dynamic> generalData = {
      'planta': state.selectedMine?.name ?? "N/A", 
      'area': state.area,
      'responsable': state.conveyorResponsible,
      'seccion': state.seccion,
      'fecha': state.inspectionDate.toString().split(' ')[0],
      'transportador': state.conveyor, 
      'banda': state.recommendedBelt,
      'material': "${state.material} / ${state.granulometry}",
      'elaboro': state.elaboro,
      'presentar': state.presentTo,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("REPORTE TÉCNICO"), backgroundColor: const Color(0xFFB71C1C)),
          body: PdfPreview(build: (format) => pdfBytes, initialPageFormat: PdfPageFormat.letter.landscape),
        )));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showSnack("Error al generar vista previa: $e", Colors.red);
      }
    }
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
            CustomHeader(title: "Inspección de Bandas", actionIcon: Icons.arrow_back_ios_new_rounded, onActionTap: () => Navigator.pop(context)),
            const SizedBox(height: 24),
            CaptureMethodSelector(onManualFill: () {}, onScan: () {}),
            const SizedBox(height: 24),
            const CustomerSection(),
            const SizedBox(height: 24),
            const GeneralBandaInfo(),
            const SizedBox(height: 32),
            _buildStepper(pasos),
            const SizedBox(height: 24),
            // 🔹 El widget activo se envuelve en un Container con la llave para el scroll
            if (state.sections.isNotEmpty)
              Container(
                key: _sectionKey, 
                child: _buildActiveContent(state),
              ),
            const SizedBox(height: 32),
            _buildFooter(pasos.length, isMobile),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveContent(BandaInspectionState state) {
    if (_mostrarRodilleria && _currentSectionIndex == state.sections.length) return const RodilleriaSection();
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
          onTap: () {
            setState(() => _currentSectionIndex = index);
            _scrollToSectionStart();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFB71C1C) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(pasos[index].toUpperCase(), style: TextStyle(color: isActive ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 10)),
          ),
        );
      }),
    );
  }

  Widget _buildFooter(int total, bool isMobile) {
    bool esUltimo = _currentSectionIndex == total - 1;
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
    onPressed: _currentSectionIndex > 0 ? () { setState(() => _currentSectionIndex--); _scrollToSectionStart(); } : null,
    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
    child: const Text("ANTERIOR"),
  );

  Widget _btnVistaPrevia() => ElevatedButton.icon(
    onPressed: () => _showPreview(context),
    icon: const Icon(Icons.remove_red_eye),
    label: const Text("VISTA PREVIA"),
    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade900, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
  );

  Widget _btnSiguiente(bool esUltimo, bool fullWidth) => ElevatedButton(
    onPressed: () {
      if (!esUltimo) { setState(() => _currentSectionIndex++); } else { _guardarReporte(); }
      _scrollToSectionStart();
    },
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB71C1C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40)),
    child: Text(esUltimo ? "FINALIZAR REPORTE" : "SIGUIENTE"),
  );
}