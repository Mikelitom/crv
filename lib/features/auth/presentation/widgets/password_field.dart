import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final FocusNode? focusNode; // <--- Esto es clave
  final Function(String)? onSubmitted; // <--- Esto es clave

  const PasswordField({
    super.key,
    required this.controller,
    this.errorText,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode, // <--- Usamos widget. para acceder al nodo
      onFieldSubmitted: widget.onSubmitted, // <--- Usamos widget. para acceder a la acción
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => obscureText = !obscureText),
        ),
        errorText: widget.errorText,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}