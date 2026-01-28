import 'package:flutter/material.dart';

class ProfileSecurityCard extends StatelessWidget {
  const ProfileSecurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 25, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          _buildOption(Icons.lock_open_rounded, "Cambiar Contraseña", "Seguridad nivel alto"),
          const Divider(height: 32, color: Color(0xFFF1F3F5)),
          _buildOption(Icons.phonelink_lock_rounded, "Dispositivos vinculados", "3 activos"),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, String sub) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFC62828).withOpacity(0.08),
          child: Icon(icon, color: const Color(0xFFC62828), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ],
    );
  }
}