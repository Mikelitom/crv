import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/client_mine.dart';
import '../presentation/provider/banda_inspection_providers.dart';// Asegúrate de importar Mine

class GeneralBandaInfo extends ConsumerWidget {
  const GeneralBandaInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bandaInspectionProvider);
    
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 800;
      
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Información General del Reporte", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildDropdownMine(ref, state, isMobile, constraints.maxWidth),
                _buildField("AREA", isMobile, constraints.maxWidth),
                _buildField("RESPONSABLE", isMobile, constraints.maxWidth),
                _buildField("SECCIÓN", isMobile, constraints.maxWidth),
                _buildField("FECHA", isMobile, constraints.maxWidth, initialValue: state.inspectionDate.toString().split(' ')[0]),
                _buildField("TRANSPORTADOR", isMobile, constraints.maxWidth),
                _buildField("BANDA RECOMENDADA", isMobile, constraints.maxWidth),
                _buildField("MATERIAL Y GRANULOMETRÍA", isMobile, constraints.maxWidth),
                _buildField("ELABORÓ", isMobile, constraints.maxWidth, initialValue: state.elaboro),
                _buildField("PRESENTAR", isMobile, constraints.maxWidth),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDropdownMine(WidgetRef ref, dynamic state, bool isMobile, double width) {
    double fieldWidth = isMobile ? width : (width / 2) - 52;
    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("PLANTA (MINA)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(),
            value: state.selectedMine?.id,
            items: state.filteredMines.map<DropdownMenuItem<String>>((Mine mine) {
              return DropdownMenuItem<String>(value: mine.id, child: Text(mine.name));
            }).toList(),
            onChanged: (id) {
              if (id != null) {
                final mine = state.filteredMines.firstWhere((m) => m.id == id);
                ref.read(bandaInspectionProvider.notifier).selectMine(mine);
              }
            },
            hint: const Text("Seleccione Planta"),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, bool isMobile, double maxWidth, {String initialValue = ""}) {
    double fieldWidth = isMobile ? maxWidth : (maxWidth / 2) - 52;
    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF8F9FA),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDE1E6))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5)),
  );
}