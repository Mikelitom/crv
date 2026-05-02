import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/inspeccion_providers.dart';
import '../../domain/entities/loan_area.dart';

const Color kRedReprosisa = Color(0xFFC62828);
const Color kHeaderGray = Color(0xFFF1F5F9);
const Color kBorderSuave = Color(0xFFD1D9E0);
const Color kTextDark = Color(0xFF0F172A);

class LoanAndInspectorSection extends ConsumerStatefulWidget {
  const LoanAndInspectorSection({super.key});

  @override
  ConsumerState<LoanAndInspectorSection> createState() => _LoanAndInspectorSectionState();
}

class _LoanAndInspectorSectionState extends ConsumerState<LoanAndInspectorSection> {
  // Controlador para manejar el texto del buscador manualmente
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inspeccionProvider);
    final notifier = ref.read(inspeccionProvider.notifier);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBorderSuave, width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: const BoxDecoration(
              color: kHeaderGray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PRÉSTAMO O DEVOLUCIÓN", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: kTextDark)),
                Text("Gestión de salida y retorno de prensa móvil", style: TextStyle(color: Colors.blueGrey, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel("ÁREA O TALLER SOLICITANTE"),
                
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textValue) {
                    final List<String> areaNames = state.loanAreas.map((a) => a.name).toList();
                    
                    // Si ya seleccionamos algo y el texto coincide, no sugerimos crear
                    if (textValue.text == '' || areaNames.contains(textValue.text)) return areaNames;
                    
                    final matches = areaNames.where((name) => 
                      name.toLowerCase().contains(textValue.text.toLowerCase())).toList();

                    // Si no hay coincidencia exacta, sugerimos crear
                    if (!areaNames.any((n) => n.toLowerCase() == textValue.text.toLowerCase())) {
                      return [...matches, '+ CREAR NUEVO: "${textValue.text}"'];
                    }
                    return matches;
                  },
                  onSelected: (String selection) {
                    if (selection.startsWith('+ CREAR NUEVO')) {
                      final RegExp regExp = RegExp(r'"([^"]*)"');
                      final match = regExp.firstMatch(selection);
                      final String cleanName = match?.group(1) ?? "";
                      
                      // Abrimos popup y le pasamos el controlador para que lo actualice al terminar
                      _showCreatePopUp(context, notifier, state.loanAreas, initialName: cleanName);
                    } else {
                      // Si seleccionó uno existente, actualizamos el texto del campo
                      _searchController.text = selection;
                      final areaObj = state.loanAreas.firstWhere((a) => a.name == selection);
                      notifier.selectLoanArea(areaObj);
                    }
                  },
                  fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                    // Sincronizamos con nuestro controlador local
                    if (_searchController.text.isNotEmpty && controller.text != _searchController.text) {
                       controller.text = _searchController.text;
                    }
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: _inputStyle(hint: "Buscar taller...", suffixIcon: Icons.search_rounded),
                    );
                  },
                ),

                const SizedBox(height: 20),
                _buildFieldLabel("NOMBRE DE QUIEN RECIBE"),
                TextField(
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: _inputStyle(hint: "Nombre completo del responsable"),
                ),

                const SizedBox(height: 20),
                _buildFieldLabel("OBSERVACIONES DEL MOVIMIENTO"),
                TextField(
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: _inputStyle(hint: "Notas adicionales..."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePopUp(BuildContext context, notifier, List<LoanArea> existingAreas, {String initialName = ""}) {
    final nameCtrl = TextEditingController(text: initialName);
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Nuevo Área o Taller", style: TextStyle(color: kRedReprosisa, fontWeight: FontWeight.w900)),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nombre del área *"),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Obligatorio";
                    if (existingAreas.any((a) => a.name.toLowerCase() == value.toLowerCase())) return "Ya existe";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Teléfono")),
                const SizedBox(height: 12),
                TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Correo")),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kRedReprosisa),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newName = nameCtrl.text;
                await notifier.createAndSelectLoanArea(
                  name: newName,
                  phone: phoneCtrl.text.isEmpty ? "N/A" : phoneCtrl.text,
                  address: emailCtrl.text.isEmpty ? "N/A" : emailCtrl.text,
                );
                
                // ACTUALIZACIÓN CLAVE: Ponemos el nombre limpio en el buscador
                setState(() {
                  _searchController.text = newName;
                });
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Taller creado con éxito"), backgroundColor: Colors.green),
                  );
                }
              }
            }, 
            child: const Text("CREAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          )
        ],
      ),
    );
  }

  InputDecoration _inputStyle({required String hint, IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true, fillColor: const Color(0xFFF8F9FA),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: kRedReprosisa, size: 18) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDE1E6))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kRedReprosisa, width: 1.5)),
    );
  }

  Widget _buildFieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
  );
}