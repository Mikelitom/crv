import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class HistoryStatusPanel extends StatelessWidget {
  final User user;

  const HistoryStatusPanel({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatusItem(
            Icons.verified_user_rounded,
            "Cuenta Verificada",
            "Nivel ${user.role[0]}",
            const Color(0xFF43A047),
          ),
          const Divider(height: 40, color: Color(0xFFF1F3F5)),
          _buildStatusItem(
            Icons.history_toggle_off_rounded,
            "Último Acceso",
            user.lastLogin?.toString() ?? "N/A",
            const Color(0xFFC62828),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
