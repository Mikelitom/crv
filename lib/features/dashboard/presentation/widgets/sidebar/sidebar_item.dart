import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final int? badgeCount;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.badgeCount
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: _buildBadge(),
      onTap: onTap,
    );
  }

  Widget? _buildBadge() {
    if (badgeCount == null || badgeCount! <= 0) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(
          badgeCount! > 99 ? '99+' : badgeCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}