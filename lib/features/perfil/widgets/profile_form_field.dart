import 'package:flutter/material.dart';

class ProfileFormField extends StatelessWidget {
  final String label;
  final String initialValue;
  final IconData icon;

  const ProfileFormField({super.key, required this.label, required this.initialValue, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500),
          prefixIcon: Icon(icon, color: const Color(0xFFC62828), size: 22),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFF1F3F5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
          ),
        ),
      ),
    );
  }
}