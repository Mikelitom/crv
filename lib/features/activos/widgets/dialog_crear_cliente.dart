import 'package:flutter/material.dart';
class DialogCrearCliente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("Crear Nuevo Cliente", 
        style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField("Nombre Completo", "Ej. Juan Pérez"),
            _buildTextField("Empresa", "Nombre de la minera/compañía"),
            _buildTextField("Teléfono", "+52..."),
            _buildTextField("Email", "cliente@empresa.com"),
            _buildTextField("Dirección / Minas", "Separar minas por comas", maxLines: 3),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
        ElevatedButton(
          onPressed: () {},
          child: Text("Registrar Cliente"),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD32F2F)),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
          ),
        ),
      ),
    );
  }
}