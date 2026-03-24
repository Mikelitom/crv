import 'package:flutter/material.dart';

class UserSearchField extends StatelessWidget {
  final double width;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const UserSearchField({
    super.key,
    required this.width,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        // Agregamos un controlador o usamos el texto actual para el icono de borrar
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: query,
            selection: TextSelection.collapsed(offset: query.length),
          ),
        ),
        decoration: InputDecoration(
          hintText: "Buscar por nombre...",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC62828)),
          suffixIcon: query.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18, color: Colors.grey), 
                onPressed: onClear
              )
            : null,
          filled: true, 
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: BorderSide.none
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}