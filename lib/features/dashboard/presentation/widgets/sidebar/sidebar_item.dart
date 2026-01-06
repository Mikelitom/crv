import 'package:flutter/material.dart';
import 'sidebar_badge.dart';

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
            ? theme.colorScheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? theme.colorScheme.primary : Colors.grey.shade600
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: 
                    isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                    ? theme.colorScheme.primary
                    : Colors.grey.shade800
                )
              )
            ),
            if (badgeCount != null && badgeCount! > 0)
              SizedBox(
                width: 24,
                height: 24,
                child: SidebarBadge(count: badgeCount!)
              )
          ],
        ),
      ),
    );
  }
}
