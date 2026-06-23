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

Future<void> _guardarReporte({required bool esFinalizar}) async {
  final state = ref.read(bandaInspectionProvider);
  final evidenceService = ref.read(evidenceServiceProvider);
  final notifier = ref.read(bandaInspectionProvider.notifier);

  if (state.selectedClient == null || state.selectedMine == null) {
    _showSnack("Selecciona cliente y mina antes de continuar", Colors.orange);
    return;
  }
  setState(() => _isSaving = true);
  notifier.setReportStatus(esFinalizar ? "COMPLETED" : "IN_PROGRESS");

  try {
    final List<Map<String, dynamic>> answers = [];

    for (var section in state.sections) {
      for (var component in section.components) {
        final fixedIds = component.selectedOptionIds
            .where((val) => component.options.any((o) => o.id == val))
            .toList();
            
        final customLabels = component.selectedOptionIds
            .where((val) => !component.options.any((o) => o.id == val))
            .toList();

        if (fixedIds.isEmpty && customLabels.isEmpty) continue;

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
          "selected_option_ids": fixedIds,      // IDs limpios
          "custom_options": customLabels,       // Textos personalizados limpios
          "recommended_action": component.observation,
          "dimentions": component.dimentions, 
          "evidences": evidenceList,
        });
      }
    }      

    final rollersData = state.isRodilleriaActive 
        ? state.rollers.map((r) => {
            "table_number": r.tableNumber, "base_number": r.baseNumber, "is_left": r.isLeft,
            "is_center": r.isCenter, "is_right": r.isRight, "is_impact": r.isImpact,
            "is_return": r.isReturn, "is_triple": r.isTriple, "is_self_aligning": r.isSelfAligning,
            "roller_type": r.rollerType,
          }).toList() 
        : null;
      
      // 1. Formatear la fecha a DDMMAA
      final now = DateTime.now();
      final formattedDate = "${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString().substring(2)}";
      
      // 2. Extraer las iniciales correctamente usando ${}
      // Aquí estamos llamando a la función y pasando el nombre de la mina de forma segura
      final mineName = state.selectedMine?.name ?? "";
      final plantaInitials = "P${_getInitials(mineName)}"; 
      
      final areaInitial = state.area.isNotEmpty ? state.area[0].toUpperCase() : "X";
      final conveyorId = state.conveyor.isNotEmpty ? state.conveyor : "000";
      
      // 3. Construir el folio
      final String folio = "$plantaInitials$formattedDate$areaInitial$conveyorId";

    final reportRequest = {
      "conveyor": state.conveyor,
      "area": state.area,
      "mine_id": state.selectedMine?.id ?? "",
      "inspection_date": state.inspectionDate.toIso8601String(),
      "section": state.seccion,
      "recommended_belt": state.recommendedBelt,
      "material": state.material,
      "granulometry": state.granulometry,
      "present_to": state.presentTo,
      "state": esFinalizar ? "COMPLETED" : "IN_PROGRESS", 
      "conveyor_responsible": state.conveyorResponsible,
      "folio": folio,
      "answers": answers,
      "rollers": rollersData,
    };

    final result = await ref.read(createBandaReportUseCaseProvider).call(reportRequest);
    
    result.fold(
      (f) => _showSnack("Error al guardar: ${f.message}", Colors.red),
      (id) {
        _showSnack("¡Reporte guardado con éxito!", Colors.green);
        ref.read(bandaInspectionProvider.notifier).initialLoad();
        Navigator.pop(context);
      }
    );

  } catch (e) {
    _showSnack("Error inesperado: $e", Colors.red);
  } finally {
    if (mounted) setState(() => _isSaving = false);
  }
}

  String _getInitials(String name) {
    if (name.isEmpty) return "GEN"; // Valor por defecto si no hay nombre
    
    // Divide por espacios y toma la primera letra de cada palabra
    List<String> words = name.trim().split(RegExp(r'\s+'));
    String initials = words.map((word) => word[0].toUpperCase()).join();
    
    // Si solo tiene una palabra (ej: "LaPerena"), toma las primeras 3 letras
    return initials.length >= 3 ? initials.substring(0, 3) : initials.padRight(3, 'X');
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
    if (state.isRodilleriaActive) pasos.add("RODILLERÍA");

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          children: [
            CustomHeader(
                title: "Inspección de Bandas",
                actionIcon: Icons.arrow_back_ios_new_rounded,
                onActionTap: () => Navigator.pop(context)),
            const SizedBox(height: 24),
            CaptureMethodSelector(onManualFill: () {}, onScan: () {}),
            const SizedBox(height: 24),
            const CustomerSection(),
            const SizedBox(height: 24),
            const GeneralBandaInfo(),
            const SizedBox(height: 32),
            _buildStepper(pasos),
            const SizedBox(height: 24),
            
            // 1. Contenedor de contenido actual
            if (state.sections.isNotEmpty)
              Container(
                key: _sectionKey,
                child: _buildActiveContent(state),
              ),

            // 2. BOTÓN CONDICIONAL: Aparece solo si no está activa la rodillería 
            // y estamos en la última sección de las predefinidas
            if (!state.isRodilleriaActive && _currentSectionIndex == state.sections.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(bandaInspectionProvider.notifier).toggleRodilleria(true);
                      // Opcional: saltar automáticamente a la nueva sección de rodillería
                      setState(() => _currentSectionIndex = state.sections.length);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("AGREGAR RODILLERÍA"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                ),
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
  // 1. Si la rodillería está activa, mostramos la sección
  if (state.isRodilleriaActive && _currentSectionIndex == state.sections.length) {
    return const RodilleriaSection();
  }

  // 2. Si es una sección normal
  if (_currentSectionIndex < state.sections.length) {
    final section = state.sections[_currentSectionIndex];
    return BandaSectionTable(
      sectionId: section.id,
      sectionTitle: section.name,
      sectionNumber: _currentSectionIndex + 1,
      items: section.components,
    );
  }

  // 3. SI NO ESTÁ ACTIVA, MOSTRAMOS EL BOTÓN PARA ACTIVARLA
  if (!state.isRodilleriaActive) {
    return Center(
      child: Column(
        children: [
          const Text("¿Deseas incluir reporte de rodillería?", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => ref.read(bandaInspectionProvider.notifier).toggleRodilleria(true),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("AGREGAR RODILLERÍA"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          ),
        ],
      ),
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
    // Si es móvil, usamos un Column para que los botones tengan espacio
    if (isMobile) {
      return Column(
        children: [
          Row(children: [_btnAnterior(), const Spacer(), _btnSiguiente(esUltimo)]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: _btnVistaPrevia()),
        ],
      );
    }
    // Si es escritorio, mantenemos el Row original
    return Row(
      children: [
        _btnAnterior(),
        const Spacer(),
        _btnVistaPrevia(),
        const SizedBox(width: 12),
        _btnSiguiente(esUltimo),
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

void _confirmarGuardado() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("¿Cómo deseas enviar el reporte?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // GUARDAR BORRADOR -> 'IN_PROGRESS'
            _guardarReporte(esFinalizar: false); 
          },
          child: const Text("GUARDAR BORRADOR"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // FINALIZAR REPORTE -> 'COMPLETED'
            _guardarReporte(esFinalizar: true); 
          },
          child: const Text("FINALIZAR REPORTE"),
        ),
      ],
    ),
  );
}
Widget _btnSiguiente(bool esUltimo) => ElevatedButton(
  onPressed: () {
    if (!esUltimo) {
      setState(() => _currentSectionIndex++);
      _scrollToSectionStart();
    } else {
      _confirmarGuardado(); 
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFB71C1C), 
    foregroundColor: Colors.white, 
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40)
  ),
  child: Text(esUltimo ? "FINALIZAR REPORTE" : "SIGUIENTE"),
);
}