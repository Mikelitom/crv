import 'package:flutter/material.dart';

class CatalogoDataTable extends StatelessWidget {
  final List<String> columnLabels;
  final String emptyMessage;
  final IconData emptyIcon;

  const CatalogoDataTable({
    super.key,
    required this.columnLabels,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEFF1)),
      ),
      child: Column(
        children: [
          // Header de la Tabla
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: columnLabels.map((label) => Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF455A64),
                  ),
                ),
              )).toList(),
            ),
          ),
          // Cuerpo - Placeholder de carga
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(emptyIcon, size: 48, color: const Color(0xFFFDECEA)),
                  const SizedBox(height: 12),
                  Text(
                    emptyMessage,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}