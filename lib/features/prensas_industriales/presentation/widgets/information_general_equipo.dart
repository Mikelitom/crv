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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
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
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna de campos: Aumentamos el flex para que ocupen el espacio necesario sin empujar la foto lejos
              Expanded(
                flex: 4, 
                child: Wrap(
                  spacing: 16, // Espacio horizontal entre campos reducido
                  runSpacing: 16, // Espacio vertical entre filas
                  children: [
                    _buildReadOnlyField("Fecha de Inspección", formattedDate),

                    // --- BUSCADOR DE SERIE ---
                    SizedBox(
                      width: 300, // Ancho ligeramente reducido para compactar
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
                            loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator())),
                            error: (_, __) => const Text("Error"),
                          ),
                        ],
                      ),
                    ),

                    _buildReadOnlyField("Modelo", state.selectedPress?.model ?? ""),
                    _buildReadOnlyField("VOLTS", state.selectedPress?.voltz ?? ""),
                    _buildReadOnlyField("Tipo", state.selectedPress?.type ?? ""),
                    
                    // --- CAMPO ÁREA ---
                    SizedBox(
                      width: 300,
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
                ),
              ),

            
              Container(
                width: 350, // Ancho fijo para la imagen
                height: 220,
                margin: const EdgeInsets.only(left: 20), // Margen controlado
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDE1E6)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/press.png', 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return SizedBox(
      width: 300,
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
        ? IconButton(icon: Icon(suffixIcon, color: const Color(0xFFC62828), size: 20), onPressed: onIconTap) 
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