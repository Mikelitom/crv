import 'package:flutter/material.dart';

class ServiceOrdersCard extends StatelessWidget {
  const ServiceOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Órdenes de servicio", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("OS-2026-005"),
          subtitle: const Text("Taller: Toyota Mérida"),
          trailing: const Text("En Proceso", style: TextStyle(color: Colors.blue)),
        ),
      ]),
    );
  }
}