import 'package:flutter/material.dart';
class DialogCrearUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.person_add_alt_1, color: Color(0xFFD32F2F)),
          SizedBox(width: 12),
          Text("Crear Nuevo Usuario", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 600,
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildInput("Nombre Completo *", "Ej. Carlos Ramírez", 280),
              _buildInput("Email *", "usuario@reprosisa.com", 280),
              _buildInput("Teléfono", "+52 444...", 280),
              _buildInput("Contraseña *", "••••••••", 280, obscure: true),
              _buildDropdown("Tipo de Usuario *", ["Administrador", "Empleado"], 280),
              _buildDropdown("Área de Trabajo", ["Vehículos", "Inspecciones"], 280),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar", style: TextStyle(color: Colors.grey.shade700)),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD32F2F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text("Crear Usuario", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildInput(String label, String hint, double width, {bool obscure = false}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          SizedBox(height: 8),
          TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0xFFD32F2F))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          SizedBox(height: 8),
          DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
            ),
            items: items.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }
}