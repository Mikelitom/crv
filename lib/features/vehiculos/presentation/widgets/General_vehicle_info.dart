import 'package:crv_reprosisa/features/vehiculos/presentation/provider/vehicle_inspection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../provider/vehicle_inspection_provider.dart';

class GeneralVehicleInfo extends ConsumerStatefulWidget {
  const GeneralVehicleInfo({super.key});

  @override
  ConsumerState<GeneralVehicleInfo> createState() => _GeneralVehicleInfoState();
}

class _GeneralVehicleInfoState extends ConsumerState<GeneralVehicleInfo> {
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();

  @override
  void dispose() {
    _unitController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios de estado para actualizar los controladores de texto
    ref.listen<VehicleInspectionState>(vehicleInspectionProvider, (previous, next) {
      if (next.selectedVehicle != null) {
        final v = next.selectedVehicle!;
        final detail = "${v.brand} ${v.model} ${v.year}";
        if (_unitController.text != detail) {
          _unitController.text = detail;
        }
      } else {
        if (_unitController.text != "---") {
          _unitController.text = "---";
        }
      }

      if (_mileageController.text != next.mileage) {
        _mileageController.text = next.mileage;
      }
    });

    final state = ref.watch(vehicleInspectionProvider);
    final allPlatesAsync = ref.watch(allPlatesProvider);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(state.inspectionDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Información General de la Unidad Móvil",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 24),
              if (isMobile)
                Column(
                  children: [
                    _buildPlateAutocomplete(allPlatesAsync, constraints.maxWidth),
                    const SizedBox(height: 16),
                    _buildField("Unidad (Marca Modelo Año)", _buildUnitTextField()),
                    const SizedBox(height: 16),
                    _buildReadOnlyField("Fecha", formattedDate),
                    const SizedBox(height: 16),
                    _buildMileageField(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildPlateAutocomplete(allPlatesAsync, constraints.maxWidth / 4)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildField("Unidad (Marca Modelo Año)", _buildUnitTextField())),
                    const SizedBox(width: 16),
                    Expanded(child: _buildReadOnlyField("Fecha", formattedDate)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMileageField()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitTextField() {
    return TextField(
      controller: _unitController,
      readOnly: true,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1C1E)),
      decoration: _inputStyle(true),
    );
  }

  Widget _buildPlateAutocomplete(AsyncValue<List<String>> allPlatesAsync, double width) {
    return _buildField(
      "Placas",
      allPlatesAsync.when(
        data: (plates) => Autocomplete<String>(
          optionsBuilder: (TextEditingValue textValue) {
            if (textValue.text == '') return const Iterable<String>.empty();
            return plates.where((p) => p.toUpperCase().contains(textValue.text.toUpperCase()));
          },
          onSelected: (selection) {
            // Esto dispara el Notifier y ref.listen lo detectará arriba
            ref.read(vehicleInspectionProvider.notifier).onPlateSelected(selection);
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: _inputStyle(false, hint: "Buscar placa...", suffixIcon: Icons.search_rounded),
            );
          },
        ),
        loading: () => const LinearProgressIndicator(color: Color(0xFFC62828)),
        error: (_, __) => const Text("Error"),
      ),
    );
  }

  Widget _buildMileageField() {
    return _buildField(
      "Kilometraje",
      TextField(
        controller: _mileageController,
        keyboardType: TextInputType.number,
        onChanged: (v) => ref.read(vehicleInspectionProvider.notifier).updateMileage(v),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: _inputStyle(false, hint: "0"),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return _buildField(label, TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      decoration: _inputStyle(true),
    ));
  }

  Widget _buildField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF444444))),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputStyle(bool readOnly, {IconData? suffixIcon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFFC62828), size: 18) : null,
      fillColor: readOnly ? const Color(0xFFF1F3F4) : const Color(0xFFF8F9FA),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDE1E6))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFC62828), width: 1.5)),
    );
  }
}