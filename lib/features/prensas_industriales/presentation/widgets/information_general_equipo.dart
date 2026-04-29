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
    final allSeriesAsync = ref.watch(allSeriesProvider);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(state.inspectionDate);

    if (state.area.isEmpty && _areaController.text.isNotEmpty) {
      _areaController.clear();
    }

    return LayoutBuilder(builder: (context, constraints) {
      // Umbral para modo computadora (escritorio)
      bool isDesktop = constraints.maxWidth >= 1000;
      bool isMobile = constraints.maxWidth < 700;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), 
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Información General del Equipo",
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                fontSize: isMobile ? 18 : 22,
                color: const Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 24),
            
            // Si es computadora, usamos un Row para separar campos de imagen
            if (isDesktop) 
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lado izquierdo: Rejilla de campos (4 columnas)
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildField("Fecha de Inspección", _buildReadOnlyTextField(formattedDate))),
                            const SizedBox(width: 16),
                            Expanded(child: _buildSerieAutocomplete(allSeriesAsync)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildField("Modelo", _buildReadOnlyTextField(state.selectedPress?.model ?? "---"))),
                            const SizedBox(width: 16),
                            Expanded(child: _buildField("VOLTS", _buildReadOnlyTextField(state.selectedPress?.voltz ?? "---"))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildField("Tipo", _buildReadOnlyTextField(state.selectedPress?.type ?? "---"))),
                            const SizedBox(width: 16),
                            Expanded(child: _buildAreaField()),
                            const SizedBox(width: 16),
                            const Spacer(flex: 2), // Espacio vacío para mantener alineación
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Lado derecho: Foto de la prensa
                  Expanded(
                    flex: 3,
                    child: _buildPressImage(false),
                  ),
                ],
              )
            else
              // Si es Tablet o Móvil, usamos la vista de Wrap anterior
              Column(
                children: [
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildField("Fecha de Inspección", _buildReadOnlyTextField(formattedDate), width: isMobile ? constraints.maxWidth : 280),
                      _buildSerieAutocomplete(allSeriesAsync, width: isMobile ? constraints.maxWidth : 280),
                      _buildField("Modelo", _buildReadOnlyTextField(state.selectedPress?.model ?? "---"), width: isMobile ? constraints.maxWidth : 280),
                      _buildField("VOLTS", _buildReadOnlyTextField(state.selectedPress?.voltz ?? "---"), width: isMobile ? constraints.maxWidth : 280),
                      _buildField("Tipo", _buildReadOnlyTextField(state.selectedPress?.type ?? "---"), width: isMobile ? constraints.maxWidth : 280),
                      _buildAreaField(width: isMobile ? constraints.maxWidth : 280),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(child: _buildPressImage(true)),
                ],
              ),
          ],
        ),
      );
    });
  }

  // --- WIDGETS DE APOYO ---

  Widget _buildSerieAutocomplete(AsyncValue allSeriesAsync, {double? width}) {
    return _buildField(
      "Número de Serie",
      allSeriesAsync.when(
        data: (series) => Autocomplete<String>(
          optionsBuilder: (TextEditingValue textValue) {
            if (textValue.text == '') return series;
            return series.where((s) => s.toLowerCase().contains(textValue.text.toLowerCase()));
          },
          onSelected: (selection) => ref.read(inspeccionProvider.notifier).onSerieSelected(selection),
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (v) => ref.read(inspeccionProvider.notifier).onSerieChanged(v),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: _inputStyle(false, hint: "Buscar serie...", suffixIcon: Icons.search_rounded),
            );
          },
        ),
        loading: () => const LinearProgressIndicator(color: Color(0xFFC62828)),
        error: (_, __) => const Text("Error"),
      ),
      width: width,
    );
  }

  Widget _buildAreaField({double? width}) {
    return _buildField(
      "Área de Ubicación",
      TextField(
        controller: _areaController,
        onChanged: (v) => ref.read(inspeccionProvider.notifier).updateArea(v),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: _inputStyle(false, hint: "Ej: Taller 1"),
      ),
      width: width,
    );
  }

  Widget _buildField(String label, Widget child, {double? width}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF444444))),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildReadOnlyTextField(String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1C1E)),
      decoration: _inputStyle(true),
    );
  }

  Widget _buildPressImage(bool isCentered) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Image.asset(
          'assets/images/press.png', 
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(bool readOnly, {IconData? suffixIcon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFFC62828), size: 18) : null,
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