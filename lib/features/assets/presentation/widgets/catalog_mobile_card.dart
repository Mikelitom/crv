import 'package:flutter/material.dart';

class CatalogMobileCard extends StatelessWidget {
  final dynamic item;
  final String type;
  final Color primaryRed;
  final Function(dynamic) onDetailsPressed;

  const CatalogMobileCard({
    super.key,
    required this.item,
    required this.type,
    required this.primaryRed,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final String estado = type == "vehiculo" 
        ? (item.toString().contains('estado') ? item.estado : "Disponible") 
        : (item.toString().contains('estado') ? item.estado : "Pendiente");

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        side: const BorderSide(color: Color(0xFFE5E7EB))
      ),
      child: ExpansionTile(
        iconColor: primaryRed,
        leading: Icon(
          type == "cliente" ? Icons.business_rounded : (type == "vehiculo" ? Icons.directions_car_rounded : Icons.precision_manufacturing_rounded),
          color: primaryRed,
          size: 22,
        ),
        trailing: type != "cliente" ? _buildStatusBadge(estado) : null,
        title: Text(
          type == "cliente" ? (item.name ?? "-") : (type == "vehiculo" ? (item.plate ?? "-") : (item.serie ?? "-")),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (type == "cliente") ...[
                  _infoRow("Compañía", item.company),
                  _infoRow("RFC SAT", item.toString().contains('rfc') && item.rfc != null ? item.rfc : "SIN RFC"),
                  _infoRow("Teléfono", item.phone),
                  _infoRow("Email", item.email),
                ] else if (type == "vehiculo") ...[
                  _infoRow("Marca / Modelo", "${item.brand} ${item.model}"),
                  _infoRow("Año", item.year?.toString()),
                  _infoRow("Ubicación", "Planta Reprosisa"),
                ] else ...[
                  _infoRow("Tipo / Modelo", "${item.type} / ${item.model}"),
                  _infoRow("Voltaje", item.voltz),
                  _infoRow("Tamaño", item.size),
                ],
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (type != "cliente")
                      TextButton.icon(
                        onPressed: () => onDetailsPressed(item),
                        icon: const Icon(Icons.visibility, size: 16, color: Color(0xFF2E7D32)),
                        label: const Text("Expediente", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                      ),
                    TextButton(onPressed: () {}, child: const Text("Editar", style: TextStyle(fontWeight: FontWeight.bold))),
                    TextButton(onPressed: () {}, child: Text("Borrar", style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case "Disponible":
      case "En Curso":
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case "En Uso":
      case "Pendiente":
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        break;
      case "En Taller":
      case "En Mantenimiento":
      case "Atrasado":
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFEF6C00);
        break;
      default:
        bgColor = const Color(0xFFF5F5F5);
        textColor = const Color(0xFF616161);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.3),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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