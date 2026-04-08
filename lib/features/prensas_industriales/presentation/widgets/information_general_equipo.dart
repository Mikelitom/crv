import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../provider/inspeccion_providers.dart';

class InformationGeneralEquipo extends ConsumerStatefulWidget {
  const InformationGeneralEquipo({super.key});

  @override
  ConsumerState<InformationGeneralEquipo> createState() => _InformationGeneralEquipoState();
}

class _InformationGeneralEquipoState extends ConsumerState<InformationGeneralEquipo> {
  late TextEditingController _areaController;

  @override
  void initState() {
    super.initState();
    _areaController = TextEditingController();
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inspeccionProvider);
    // FORZAMOS EL TIPO AQUÍ PARA EVITAR EL NOSUCHMETHODERROR
    final AsyncValue<List<String>> allSeriesAsync = ref.watch(allSeriesProvider);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(state.inspectionDate);

    if (state.area.isEmpty && _areaController.text.isNotEmpty) {
      _areaController.clear();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Información General del Equipo",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 24),
              if (isMobile)
                Column(
                  children: [
                    _buildFieldsWrap(state, allSeriesAsync, formattedDate, double.infinity),
                    const SizedBox(height: 24),
                    _buildImagePreview(double.infinity, 250),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildFieldsWrap(state, allSeriesAsync, formattedDate, 300),
                    ),
                    const SizedBox(width: 20),
                    _buildImagePreview(350, 250),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldsWrap(state, AsyncValue<List<String>> allSeriesAsync, String formattedDate, double fieldWidth) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildReadOnlyField("Fecha de Inspección", formattedDate, fieldWidth),
        
        // --- BUSCADOR DE SERIE ---
        SizedBox(
          width: fieldWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Serie", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              allSeriesAsync.when(
                data: (series) => Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textValue) {
                    if (textValue.text == '') return series;
                    return series.where((s) => s.toLowerCase().contains(textValue.text.toLowerCase()));
                  },
                  onSelected: (selection) {
                    ref.read(inspeccionProvider.notifier).onSerieSelected(selection);
                  },
                  fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: (v) => ref.read(inspeccionProvider.notifier).onSerieChanged(v),
                      decoration: _inputStyle(
                        false,
                        suffixIcon: Icons.search,
                        onIconTap: () {
                          controller.clear();
                          ref.read(inspeccionProvider.notifier).onSerieChanged('');
                        }
                      ),
                    );
                  },
                ),
                loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                error: (err, stack) => const Text("Error al cargar series", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),

        _buildReadOnlyField("Modelo", state.selectedPress?.model ?? "", fieldWidth),
        _buildReadOnlyField("VOLTS", state.selectedPress?.voltz ?? "", fieldWidth),
        _buildReadOnlyField("Tipo", state.selectedPress?.type ?? "", fieldWidth),

        // --- CAMPO ÁREA ---
        SizedBox(
          width: fieldWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Área", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _areaController,
                onChanged: (v) => ref.read(inspeccionProvider.notifier).updateArea(v),
                decoration: _inputStyle(false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE1E6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/images/press.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            decoration: _inputStyle(true),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputStyle(bool readOnly, {IconData? suffixIcon, VoidCallback? onIconTap}) {
    return InputDecoration(
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: Icon(suffixIcon, color: const Color(0xFFC62828), size: 20),
              onPressed: onIconTap)
          : null,
      fillColor: readOnly ? const Color(0xFFF1F3F4) : const Color(0xFFF8F9FA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDE1E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5),
      ),
    );
  }
}