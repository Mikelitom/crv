import 'package:flutter/material.dart';

class SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          Icon(Icons.factory, size: 28),
          SizedBox(width: 12),
          Text(
            'Reprosisa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )
          )
        ]
      ),
    );
  }
}