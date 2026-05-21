import 'package:flutter/material.dart';
import 'asset_detail_modal.dart';

class CatalogMobileCard extends StatelessWidget {
  final dynamic item;
  final String type;
  final Color primaryRed;

  const CatalogMobileCard({
    super.key,
    required this.item,
    required this.type,
    required this.primaryRed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE5E7EB))),
      child: ExpansionTile(
        iconColor: primaryRed,
        leading: Icon(
          type == "cliente" ? Icons.business_rounded : (type == "vehiculo" ? Icons.directions_car_rounded : Icons.precision_manufacturing_rounded),
          color: primaryRed,
          size: 22,
        ),
        title: Text(
          type == "cliente" ? (item.name ?? "-") : (type == "vehiculo" ? (item.plate ?? "-") : (item.serie ?? "-")),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoRow("Estatus del Activo:", item.operationState ?? 'Disponible'),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AssetDetailModal(item: item, type: type, primaryRed: primaryRed),
                        );
                      },
                      icon: const Icon(Icons.visibility, size: 16, color: Color(0xFF2E7D32)),
                      label: const Text("Mas Detalles", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                    ),
                    TextButton(onPressed: () {}, child: const Text("Editar")),
                    TextButton(onPressed: () {}, child: Text("Borrar", style: TextStyle(color: primaryRed))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value ?? "-", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF111827))),
        ],
      ),
    );
  }
}