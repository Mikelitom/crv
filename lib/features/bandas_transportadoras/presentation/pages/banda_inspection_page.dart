import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../dashboard/presentation/widgets/header.dart';
import '../provider/banda_inspection_providers.dart';
import '../../widgets/banda_section_table.dart';
import '../../widgets/customer_section.dart';
import '../../widgets/general_banda.dart';
import '../../widgets/rodilleria_section.dart';
import '../../../prensas_industriales/presentation/widgets/capture_method_selector.dart';
import '../../../../core/utils/banda_pdf_generator.dart';


class BandaInspectionPage extends ConsumerStatefulWidget {
  const BandaInspectionPage({super.key});

  @override
  ConsumerState<BandaInspectionPage> createState() => _BandaInspectionPageState();
}

class _BandaInspectionPageState extends ConsumerState<BandaInspectionPage> {
  int _currentSectionIndex = 0;
  bool _mostrarRodilleria = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bandaInspectionProvider.notifier).initialLoad();
    });
  }

  void _showPreview(BuildContext context) async {
    final state = ref.read(bandaInspectionProvider);
    
    // Recolección de datos para el reporte
    final Map<String, dynamic> generalData = {
      'planta': 'PLANTA REPROSISA',
      'area': 'MANTENIMIENTO INDUSTRIAL',
      'responsable': 'JUAN SOTO',
      'fecha': DateTime.now().toString().split(' ')[0],
      'banda': 'CONTINENTAL 4-PLY',
      'transportador': 'T-101',
      'comentarios': 'Inspección técnica de rutina realizada.',
    };

    final pdfBytes = await BandaPdfGenerator.generateReport(generalData, state.sections);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("VISTA PREVIA PDF"),
            backgroundColor: const Color(0xFFB71C1C),
          ),
          body: PdfPreview(
            build: (format) => pdfBytes,
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bandaInspectionProvider);
    List<String> pasos = state.sections.map((s) => s.name).toList();
    if (_mostrarRodilleria) pasos.add("Rodillería");

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFFB71C1C))));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CustomHeader(
              title: "Inspección de Bandas", 
              actionIcon: Icons.picture_as_pdf, 
              onActionTap: () => _showPreview(context),
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

            if (state.sections.isNotEmpty)
              _buildActiveContent(state),

            const SizedBox(height: 32),
            _buildFooter(pasos.length),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveContent(dynamic state) {
    if (_mostrarRodilleria && _currentSectionIndex == state.sections.length) {
      return const RodilleriaSection();
    }
    final section = state.sections[_currentSectionIndex];
    return BandaSectionTable(
      sectionId: section.id,
      sectionTitle: section.name,
      sectionNumber: _currentSectionIndex + 1,
      items: section.components,
    );
  }

  Widget _buildStepper(List<String> pasos) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: List.generate(pasos.length, (index) {
        bool isActive = index == _currentSectionIndex;
        bool isCompleted = index < _currentSectionIndex;
        return GestureDetector(
          onTap: () => setState(() => _currentSectionIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFB71C1C) : (isCompleted ? Colors.green : Colors.white),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFCBD5E1)),
            ),
            child: Text(
              pasos[index].toUpperCase(),
              style: TextStyle(color: (isActive || isCompleted) ? Colors.white : Colors.black54, fontWeight: FontWeight.w900, fontSize: 9),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFooter(int total) {
    bool esUltimo = _currentSectionIndex == total - 1;
    
    return Row(
      children: [
        OutlinedButton(
          onPressed: _currentSectionIndex > 0 ? () => setState(() => _currentSectionIndex--) : null,
          child: const Text("ANTERIOR"),
        ),
        const Spacer(),
        
        // BOTÓN VISTA PREVIA
        ElevatedButton.icon(
          onPressed: () => _showPreview(context),
          icon: const Icon(Icons.remove_red_eye),
          label: const Text("VISTA PREVIA"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade800, foregroundColor: Colors.white),
        ),
        
        const SizedBox(width: 12),

        // BOTÓN FINALIZAR
        ElevatedButton(
          onPressed: () {
            if (!esUltimo) {
              setState(() => _currentSectionIndex++);
            } else {
              _showPreview(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB71C1C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(esUltimo ? "FINALIZAR" : "SIGUIENTE"),
        ),
      ],
    );
  }
}