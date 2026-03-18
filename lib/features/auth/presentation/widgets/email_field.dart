import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final FocusNode? focusNode; // <--- Agregado
  final Function(String)? onSubmitted; // <--- Agregado

  const EmailField({
    super.key,
    required this.controller,
    this.errorText,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode, // Conecta el nodo
      onFieldSubmitted: onSubmitted, // Conecta la acción
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next, // Muestra botón "Siguiente"
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined, size: 20),
        hintText: 'ejemplo@correo.com',
        errorText: errorText,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC62828)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade200),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}