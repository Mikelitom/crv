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
bool _validarDatosGenerales() {
  final state = ref.read(bandaInspectionProvider);
  
  if (state.selectedClient == null || state.selectedMine == null) {
    _showSnack("Error: Debe seleccionar Cliente y Planta", Colors.red);
    return false;
  }
  
  if (state.area.length < 2 || 
      state.conveyor.length < 2 || 
      state.material.length < 2 || 
      state.granulometry.length < 2 || 
      state.presentTo.length < 2) {
    _showSnack("Error: Área, Transportador, Material, Granulometría y Presentar a deben tener al menos 2 caracteres", Colors.red);
    return false;
  }
  
  return true;
}
Future<void> _guardarReporte({required bool esFinalizar}) async {
  final state = ref.read(bandaInspectionProvider);
  final evidenceService = ref.read(evidenceServiceProvider);
  final notifier = ref.read(bandaInspectionProvider.notifier);

  // 1. VALIDACIÓN PREVENTIVA DE CAMPOS (Evita el error string_too_short)
  if (state.selectedClient == null || state.selectedMine == null) {
    _showSnack("Selecciona cliente y mina antes de continuar", Colors.orange);
    return;
  }
  
  if (state.area.length < 2 || 
      state.conveyor.length < 2 || 
      state.material.length < 2 || 
      state.granulometry.length < 2 || 
      state.presentTo.length < 2) {
    _showSnack("Error: Área, Transportador, Material, Granulometría y Presentar a deben tener al menos 2 caracteres.", Colors.red);
    return;
  }
  
  setState(() => _isSaving = true);
  notifier.setReportStatus(esFinalizar ? "COMPLETED" : "IN_PROGRESS");

  try {
    final List<Map<String, dynamic>> answers = [];

    for (var section in state.sections) {
      for (var component in section.components) { 
        final validOptionIds = component.options.map((o) => o.id).toSet();
        
        final fixedIds = component.selectedOptionIds
            .where((val) => validOptionIds.contains(val))
            .toList();
            
        final customLabels = component.selectedOptionIds
            .where((val) => !validOptionIds.contains(val))
            .toList();

        // Se agregó la validación para incluir el componente si tiene comment
        if (fixedIds.isEmpty && customLabels.isEmpty && component.observation.isEmpty && component.comment.isEmpty) continue;

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
            (l) => debugPrint("Error subida: ${l.message}"),
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
          "selected_option_ids": fixedIds,
          "custom_options": customLabels,
          "recommended_action": component.observation,
          "dimentions": component.dimentions, 
          "comment": component.comment, // Campo agregado
          "evidences": evidenceList,
        });
      }
    }      

    final List<Map<String, dynamic>> filteredRollers = state.rollers
        .where((r) => 
            (r.tableNumber > 0 || r.baseNumber > 0 || 
             r.isLeft || r.isCenter || r.isRight || 
             r.isImpact || r.isReturn || r.observation.isNotEmpty)
        )
        .map((r) => {
            "table_number": r.tableNumber, 
            "base_number": r.baseNumber, 
            "is_left": r.isLeft ? 1 : 0,
            "is_center": r.isCenter ? 1 : 0,
            "is_right": r.isRight ? 1 : 0,
            "is_impact": r.isImpact ? 1 : 0,
            "is_return": r.isReturn ? 1 : 0,
            "is_triple": r.isTriple ? 1 : 0,
            "is_self_aligning": r.isSelfAligning ? 1 : 0,
            "observation": r.observation
        })
        .toList();

    final rollersData = (state.isRodilleriaActive && filteredRollers.isNotEmpty) 
        ? {
            "roller_notes": state.rollerNotes,
            "rollers": filteredRollers
          } 
        : null;
      
    if (esFinalizar && answers.isEmpty && filteredRollers.isEmpty) {
      _showSnack("El reporte está vacío. Agrega datos antes de finalizar.", Colors.orange);
      setState(() => _isSaving = false);
      return;
    }

    final now = DateTime.now();
    final folio = "P${_getInitials(state.selectedMine?.name ?? "")}${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString().substring(2)}${state.area.isNotEmpty ? state.area[0].toUpperCase() : "X"}${state.conveyor.isNotEmpty ? state.conveyor : "000"}";

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
      "rollers_data": rollersData,
    };

    final result = await ref.read(createBandaReportUseCaseProvider).call(reportRequest);
    
    result.fold(
      (failure) {
        // Mejor manejo de error para mostrar al usuario
        String msg = failure.message.contains("string_too_short") 
            ? "Campos incompletos: Asegúrate de llenar Área, Transportador, Material y Granulometría con al menos 2 letras." 
            : "Error: ${failure.message}";
        _showSnack(msg, Colors.red);
      },
      (id) {
        _showSnack("¡Reporte guardado con éxito!", Colors.green);
        ref.read(bandaInspectionProvider.notifier).initialLoad();
        Navigator.pop(context);
      }
    );

  } catch (e, stacktrace) {
    debugPrint("Error inesperado: $e\n$stacktrace");
    _showSnack("Error inesperado: $e", Colors.red);
  } finally {
    if (mounted) setState(() => _isSaving = false);
  }
}
  String _getInitials(String name) {
    if (name.isEmpty) return "GEN"; // Valor por defecto si no hay nombre
    
    List<String> words = name.trim().split(RegExp(r'\s+'));
    String initials = words.map((word) => word[0].toUpperCase()).join();
    
    return initials.length >= 3 ? initials.substring(0, 3) : initials.padRight(3, 'X');
  }

  void _showSnack(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
  }

Future<void> _showPreview(BuildContext context) async {
    // 1. Validar antes de iniciar cualquier proceso
    if (!_validarDatosGenerales()) return;

    // 2. Mostrar indicador de carga mejorado
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Generando PDF, por favor espere..."),
            ],
          ),
        ),
      ),
    );

    try {
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
        'comentarios': state.generalComments,
      };

      // 3. Generación del reporte
      final pdfBytes = await BandaPdfGenerator.generateReport(
        generalData,
        state.sections,
        state.rollers,
      );

      // 4. Navegación a la vista previa
      if (context.mounted) {
        Navigator.pop(context); // Cierra el diálogo de carga
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text("REPORTE TÉCNICO"),
                backgroundColor: const Color(0xFFB71C1C),
              ),
              body: PdfPreview(
                build: (format) => pdfBytes,
                initialPageFormat: PdfPageFormat.letter.landscape,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // 5. Manejo de errores
      if (context.mounted) {
        Navigator.pop(context); // Cierra el diálogo de carga en caso de error
        _showSnack("Error al generar vista previa: $e", Colors.red);
      }
    }
  }
@override
  Widget build(BuildContext context) {
    final state = ref.watch(bandaInspectionProvider);
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    // 1. Calculamos los pasos dinámicamente
    List<String> pasos = state.sections.map((s) => s.name).toList();
    if (state.isRodilleriaActive) pasos.add("RODILLERÍA");

    // 2. Seguridad: Si eliminamos la rodillería y el índice actual era el de rodillería,
    // ajustamos el índice a la última sección disponible.
    if (_currentSectionIndex >= pasos.length) {
      _currentSectionIndex = pasos.isNotEmpty ? pasos.length - 1 : 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          children: [
            CustomHeader(
              title: "Inspección de Bandas",
              actionIcon: Icons.arrow_back_ios_new_rounded,
              onActionTap: () => Navigator.pop(context),
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
            
            // Contenido activo
            if (state.sections.isNotEmpty || state.isRodilleriaActive)
              Container(
                key: _sectionKey,
                child: _buildActiveContent(state),
              ),

            // Botón para agregar rodillería solo si no está activa y estamos al final
            if (!state.isRodilleriaActive && _currentSectionIndex == state.sections.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(bandaInspectionProvider.notifier).toggleRodilleria(true);
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
  // 1. Caso: Rodillería Activa y estamos en su pestaña
  if (state.isRodilleriaActive && _currentSectionIndex == state.sections.length) {
    return Column(
      children: [
        const RodilleriaSection(),
        const SizedBox(height: 20),
        // Botón de eliminar sección de rodillería
        TextButton.icon(
          onPressed: _desactivarRodilleria,
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          label: const Text(
            "ELIMINAR SECCIÓN DE RODILLERÍA",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // 2. Caso: Sección normal (Tabla de componentes)
  if (_currentSectionIndex < state.sections.length) {
    final section = state.sections[_currentSectionIndex];
    return BandaSectionTable(
      sectionId: section.id,
      sectionTitle: section.name,
      sectionNumber: _currentSectionIndex + 1,
      items: section.components,
    );
  }

  // 3. Caso: Rodillería Inactiva (Botón para agregarla)
  if (!state.isRodilleriaActive) {
    return Center(
      child: Column(
        children: [
          const Text(
            "¿Deseas incluir reporte de rodillería?",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(bandaInspectionProvider.notifier).toggleRodilleria(true);
              // Opcional: mover el stepper automáticamente al nuevo índice
              setState(() => _currentSectionIndex = state.sections.length);
            },
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
  // Determinamos si la sección actual es la última, basándonos en el total de pasos
  // Esto se ajustará automáticamente cuando elimines la rodillería y el 'total' disminuya
  bool esUltimo = _currentSectionIndex == total - 1;

  if (isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _btnAnterior()),
            const SizedBox(width: 12),
            Expanded(child: _btnSiguiente(esUltimo)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: _btnVistaPrevia()),
      ],
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      _btnAnterior(),
      const SizedBox(width: 12),
      _btnVistaPrevia(),
      const SizedBox(width: 12),
      _btnSiguiente(esUltimo),
    ],
  );
}
Widget _btnAnterior() => OutlinedButton(
    onPressed: _currentSectionIndex > 0 && !_isSaving 
        ? () { setState(() => _currentSectionIndex--); _scrollToSectionStart(); } 
        : null,
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      minimumSize: const Size(120, 56), // Tamaño mínimo para ser táctil
    ),
    child: const Text("ANTERIOR"),
  );

 Widget _btnVistaPrevia() => ElevatedButton.icon(
    // Si _isSaving es true, el botón se deshabilita (null)
    onPressed: _isSaving 
        ? null 
        : () async {
            if (_validarDatosGenerales()) {
              await _showPreview(context);
            }
          },
    // Cambiamos el icono por un indicador de carga si está guardando
    icon: _isSaving
        ? const SizedBox(
            width: 16, height: 16, 
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          )
        : const Icon(Icons.remove_red_eye),
    label: Text(_isSaving ? "GENERANDO..." : "VISTA PREVIA"),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey.shade900, 
      foregroundColor: Colors.white, 
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20)
    ),
  );

Future<void> _confirmarGuardado() async {
  // Ajuste de lógica si es necesario
  const bool estaCompleto = true; 

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // 1. Responsividad: Limitamos el ancho al 90% de la pantalla
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Expanded( // 2. Expanded evita el overflow si el título es largo
            child: Text(
              "Confirmar Envío",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: const Text(
        "¿Deseas enviar el reporte como COMPLETADO o guardarlo como BORRADOR?",
        style: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      // 3. Usamos actions con un Wrap para que los botones fluyan responsivamente
      actions: [
        Wrap(
          spacing: 8.0, // Espacio horizontal entre botones
          runSpacing: 4.0, // Espacio vertical si se apilan
          alignment: WrapAlignment.end,
          children: [
            // BOTÓN BORRADOR
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                _guardarReporte(esFinalizar: false); 
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("BORRADOR"),
            ),
              ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _guardarReporte(esFinalizar: true); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("FINALIZAR"),
            ),
          ],
        ),
      ],
    ),
  );
}
void _desactivarRodilleria() {
    // 1. Desactivamos en el provider
    ref.read(bandaInspectionProvider.notifier).toggleRodilleria(false);
    
    // 2. Regresamos el índice al final de las secciones normales
    final state = ref.read(bandaInspectionProvider);
    setState(() {
      _currentSectionIndex = state.sections.length - 1;
    });
    
    _showSnack("Sección de rodillería eliminada", Colors.grey);
  }
Widget _btnSiguiente(bool esUltimo) => ElevatedButton(
    onPressed: _isSaving
        ? null
        : () {
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
      // Igualamos el padding para que tengan la misma altura y forma
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      // Eliminamos el minimumSize fijo y dejamos que se ajuste al contenido
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Radio igual al de tu botón ANTERIOR
      ),
      elevation: 0,
    ),
    child: _isSaving && esUltimo
        ? const SizedBox(
            width: 20, height: 20, 
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          )
        : Text(
            esUltimo ? "FINALIZAR" : "SIGUIENTE", // Redujimos el texto
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 13 // Letra un poco más chica
            ),
          ),
  );
}