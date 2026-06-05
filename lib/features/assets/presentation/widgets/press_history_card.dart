import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/press_history.dart';

class PressHistoryCard extends StatelessWidget {
  final PressHistory item;
  final VoidCallback onDetailsPressed;      // Ahora usado para Descarga Directa
  final VoidCallback onPdfPreviewPressed;
  final VoidCallback onPrintPressed;

  const PressHistoryCard({
    super.key,
    required this.item,
    required this.onDetailsPressed,       // Mantener nombre por compatibilidad, pero es Descarga
    required this.onPdfPreviewPressed,
    required this.onPrintPressed,
  });

  static const Color primaryRed = Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 8, 
            offset: const Offset(0, 2)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(item.state),
              Text(item.folio, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryRed)),
            ],
          ),
          const SizedBox(height: 12),
          Text("${item.model} - ${item.type}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Serie: ${item.serie} | Volts: ${item.voltz}", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 15),
          _buildInfoRow(Icons.calendar_today, DateFormat('yyyy-MM-dd').format(item.inspectionDate)),
          const SizedBox(height: 15),
          Divider(color: Colors.grey.shade100),
          // En PressHistoryCard.dart - método _footer()
  Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    // 1. Botón para Vista Previa (opcional)
    IconButton(
      onPressed: onPdfPreviewPressed, 
      icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
      tooltip: "Vista Previa",
    ),
    // 2. Botón para Imprimir
    IconButton(
      onPressed: onPrintPressed, 
      icon: const Icon(Icons.print_outlined, color: Colors.teal),
      tooltip: "Imprimir",
    ),
    // 3. CAMBIO: El botón del Ojo ahora es DESCARGA DIRECTA
    IconButton(
      onPressed: onDetailsPressed, // <-- Esta función ejecutará la descarga
      icon: const Icon(Icons.download, color: primaryRed),
      tooltip: "Descargar PDF",
    ),
  ],
)
        ],
      ),
    );
  }

  Widget _buildStatusChip(String state) {
    final bool isCompleted = state.toUpperCase().contains('COMPLETED') || state.toUpperCase().contains('FINALIZADO');
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(
        isCompleted ? 'COMPLETADO' : 'EN PROCESO',
        style: TextStyle(
          color: isCompleted ? Colors.green.shade700 : Colors.orange.shade800,
          fontSize: 10, 
          fontWeight: FontWeight.bold
        )
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}