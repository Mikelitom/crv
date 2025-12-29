import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final int? badgeCount;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
            ? theme.colorScheme.primary.withValues()
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8)
        ),
      ),
    )
  }

  
}
