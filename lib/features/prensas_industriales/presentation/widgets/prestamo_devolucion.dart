import 'package:flutter/material.dart';

const Color kRedReprosisa = Color(0xFFC62828);
const Color kHeaderGray = Color(0xFFF1F5F9); 
const Color kBorderSuave = Color(0xFFD1D9E0); 
const Color kTextDark = Color(0xFF0F172A);

class LoanAndInspectorSection extends StatefulWidget {
  const LoanAndInspectorSection({super.key});

  @override
  State<LoanAndInspectorSection> createState() => _LoanAndInspectorSectionState();
}

class _LoanAndInspectorSectionState extends State<LoanAndInspectorSection> {
  bool _isCreatingArea = false;
  String? _selectedArea;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorderSuave, width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          // CABECERA INTEGRADA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: const BoxDecoration(
              color: kHeaderGray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PRÉSTAMO O DEVOLUCIÓN", 
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: kTextDark, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                const Text("Gestión de salida y retorno de prensa móvil", 
                  style: TextStyle(color: Colors.blueGrey, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SELECTOR DE ÁREA CON OPCIÓN DINÁMICA
                _buildFieldLabel("ÁREA O TALLER SOLICITANTE"),
                _buildAreaDropdown(),

                // PANEL DE CREACIÓN ("TAP" PARA CREAR NUEVO)
                if (_isCreatingArea) ...[
                  const SizedBox(height: 12),
                  _buildNewAreaForm(),
                ],

                const SizedBox(height: 20),
                _buildFieldLabel("NOMBRE DE QUIEN RECIBE"),
                _buildTextField(hint: "Nombre completo del responsable", isMandatory: true),

                const SizedBox(height: 20),
                _buildFieldLabel("OBSERVACIONES DEL MOVIMIENTO"),
                _buildTextField(hint: "Notas sobre el estado de la prensa...", maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown con lógica de "Crear Nuevo"
  Widget _buildAreaDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedArea,
      decoration: _inputDecoration(hint: "Busque o seleccione área"),
      items: [
        const DropdownMenuItem(value: "Taller A", child: Text("Taller A - Mantenimiento")),
        const DropdownMenuItem(value: "Taller B", child: Text("Taller B - Operaciones")),
        DropdownMenuItem(
          value: "CREATE_NEW", 
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline, size: 18, color: kRedReprosisa),
              const SizedBox(width: 8),
              Text("¿No existe? Crear nuevo", 
                style: TextStyle(color: kRedReprosisa, fontWeight: FontWeight.w900, fontSize: 12)),
            ],
          )
        ),
      ],
      onChanged: (val) {
        setState(() {
          if (val == "CREATE_NEW") {
            _isCreatingArea = true;
            _selectedArea = null;
          } else {
            _isCreatingArea = false;
            _selectedArea = val;
          }
        });
      },
    );
  }

  // Formulario expandible para nueva área
  Widget _buildNewAreaForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kHeaderGray.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kRedReprosisa.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("REGISTRO DE NUEVA ÁREA", 
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: kRedReprosisa)),
          const SizedBox(height: 12),
          _buildTextField(hint: "Nombre del área (Obligatorio)", isMandatory: true),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField(hint: "Teléfono (Opcional)")),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField(hint: "Dirección (Opcional)")),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(() => _isCreatingArea = false),
              icon: const Icon(Icons.check_circle, size: 16, color: Colors.green),
              label: const Text("LISTO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.green)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, int maxLines = 1, bool isMandatory = false}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      decoration: _inputDecoration(hint: hint, isMandatory: isMandatory),
    );
  }

  InputDecoration _inputDecoration({required String hint, bool isMandatory = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.normal),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), 
        borderSide: BorderSide(color: isMandatory ? kRedReprosisa.withOpacity(0.3) : kBorderSuave, width: 1.2)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), 
        borderSide: const BorderSide(color: kRedReprosisa, width: 1.8)
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
    );
  }
}