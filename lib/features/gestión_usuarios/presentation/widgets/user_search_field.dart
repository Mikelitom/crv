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
    return SizedBox(
      width: width,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Buscar por nombre o correo...",
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC62828)),
          suffixIcon: query.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: onClear)
            : null,
          filled: true, 
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: BorderSide.none
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}