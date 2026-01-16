import 'package:flutter/material.dart';

class AppTableCell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppTableCell({
    super.key,
    required this.child,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return child;
    }

    return InkWell(
      onTap: onTap,
      child: child
    );
  }
}