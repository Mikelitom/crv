import 'package:flutter/material.dart';

class HistoryStatusPanel extends StatelessWidget {
  const HistoryStatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 40, offset: const Offset(0, 20))
        ],
      ),
      child: Column(
        children: [
          _buildStatusItem(Icons.verified_user_rounded, "Cuenta Verificada", "Nivel Administrador", const Color(0xFF43A047)),
          const Divider(height: 40, color: Color(0xFFF1F3F5)),
          _buildStatusItem(Icons.history_toggle_off_rounded, "Último Acceso", "Hoy, 10:45 AM", const Color(0xFFC62828)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _miniStat("12", "Servicios"),
              _miniStat("04", "Pendientes"),
              _miniStat("98%", "Eficiencia"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _miniStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }
}