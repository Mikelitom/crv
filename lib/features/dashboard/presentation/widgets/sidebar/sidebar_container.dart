import 'package:flutter/material.dart';

class SidebarContainer extends StatelessWidget {
  final Widget child;

  const SidebarContainer({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.grey.shade100,
      child: SafeArea(child: child)
    );
  }
}