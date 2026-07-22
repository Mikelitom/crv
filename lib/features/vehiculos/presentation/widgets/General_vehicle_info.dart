import 'package:crv_reprosisa/features/vehiculos/presentation/provider/vehicle_inspection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _showError = false;

  @override
  void dispose() {
    _unitController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  // Método público o de acceso para validar antes de enviar
  bool validateMileage() {
    final state = ref.read(vehicleInspectionProvider);
    final mileageValue = double.tryParse(state.mileage) ?? 0.0;

    if (mileageValue <= 0) {
      setState(() {
        _showError = true;
      });
      return false;
    }

    setState(() {
      _showError = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
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

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): () {
          validateMileage();
        },
      },
      child: LayoutBuilder(
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
                      _buildPlateAutocomplete(allPlatesAsync),
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
                      Expanded(child: _buildPlateAutocomplete(allPlatesAsync)),
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
      ),
    );
  }

  Widget _buildUnitTextField() {
    return TextField(
      controller: _unitController,
      readOnly: true,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1C1E)),
      decoration: _inputStyle(readOnly: true),
    );
  }

  Widget _buildPlateAutocomplete(AsyncValue<List<String>> allPlatesAsync) {
    return _buildField(
      "Placas",
      allPlatesAsync.when(
        data: (plates) => Autocomplete<String>(
          optionsBuilder: (TextEditingValue textValue) {
            if (textValue.text == '') {
              return plates;
            }
            return plates.where((p) => p.toUpperCase().contains(textValue.text.toUpperCase()));
          },
          onSelected: (selection) {
            ref.read(vehicleInspectionProvider.notifier).onPlateSelected(selection);
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: _inputStyle(
                readOnly: false, 
                hint: "Escribe o selecciona...", 
                suffixIcon: Icons.arrow_drop_down_circle_outlined
              ),
            );
          },
        ),
        loading: () => const LinearProgressIndicator(color: Color(0xFFC62828)),
        error: (_, __) => const Text("Error al cargar unidades"),
      ),
    );
  }

  Widget _buildMileageField() {
    // Verificación en tiempo real para activar la alerta visual inmediatamente si borran el valor o ponen 0
    final state = ref.watch(vehicleInspectionProvider);
    final val = double.tryParse(state.mileage) ?? 0.0;
    final bool hasError = _showError || val <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(
          "Kilometraje",
          TextField(
            controller: _mileageController,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              ref.read(vehicleInspectionProvider.notifier).updateMileage(v);
              setState(() {
                // Actualiza el estado visual al escribir
                final parsed = double.tryParse(v) ?? 0.0;
                _showError = parsed <= 0;
              });
            },
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: _inputStyle(
              readOnly: false, 
              hint: "0", 
              isError: hasError,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.error_outline_rounded, color: Color(0xFFC62828), size: 14),
              SizedBox(width: 4),
              Text(
                "ERROR KILOMETRAJE TIENE QUE SER MAYOR A 0",
                style: TextStyle(
                  color: Color(0xFFC62828),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return _buildField(label, TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      decoration: _inputStyle(readOnly: true),
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

  InputDecoration _inputStyle({
    required bool readOnly, 
    IconData? suffixIcon, 
    String? hint, 
    bool isError = false,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFFC62828), size: 18) : null,
      fillColor: readOnly ? const Color(0xFFF1F3F4) : const Color(0xFFF8F9FA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(
          color: isError ? const Color(0xFFC62828) : const Color(0xFFDDE1E6),
          width: isError ? 2.0 : 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(
          color: isError ? const Color(0xFFC62828) : const Color(0xFFC62828), 
          width: 2.0,
        ),
      ),
    );
  }
}