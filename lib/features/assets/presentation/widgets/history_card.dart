import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onDetailsPressed;
  final VoidCallback onDownloadPressed;
  final VoidCallback onPrintPressed;
  final VoidCallback onPdfPreviewPressed;

  const HistoryCard({
    super.key,
    required this.item,
    required this.onDetailsPressed,
    required this.onDownloadPressed,
    required this.onPrintPressed,
    required this.onPdfPreviewPressed,
  });

  static const Color primaryRed = Color(0xFFC62828);
  static const Color backgroundGrey = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    // Manejo seguro de la lista de evidencias
    final List<String> paths = (item.evidencePaths is List) ? List<String>.from(item.evidencePaths) : [];
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusChip(item.state),
              _versionChip(item.folio),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            (item.generalNotes != null && item.generalNotes.toString().trim().length > 1)
                ? item.generalNotes.toString()
                : "Sin observaciones adicionales registradas.",
            style: const TextStyle(
              fontSize: 15, 
              height: 1.6, 
              fontWeight: FontWeight.w500, 
              color: Colors.black87
            ),
          ),
          const SizedBox(height: 20),
          _infoContainer(),
          const SizedBox(height: 20),
          _evidenceSection(paths),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade200, thickness: 1.2),
          const SizedBox(height: 12),
          _footer(),
        ],
      ),
    );
  }

  Widget _infoContainer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: backgroundGrey, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: _infoRow(Icons.speed_outlined, '${item.mileage ?? 0} KM')),
          const SizedBox(width: 8),
          Expanded(child: _infoRow(Icons.calendar_today_outlined, DateFormat('yyyy-MM-dd').format(item.inspectionDate))),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _evidenceSection(List<String> paths) {
    return Row(
      children: [
        Icon(Icons.image_outlined, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        const Text(
          'EVIDENCIA FOTOGRÁFICA', 
          style: TextStyle(color: Color(0xFF555555), fontWeight: FontWeight.w800, fontSize: 11)
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 12, 
          backgroundColor: Colors.grey.shade200, 
          child: Text(
            "${paths.length}", 
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)
          )
        ),
      ],
    );
  }

  Widget _footer() {
    return Row(
      children: [
        Icon(Icons.person_outline, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.responsibleName ?? "Sin responsable", 
            style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600, fontSize: 13), 
            overflow: TextOverflow.ellipsis
          )
        ),
        IconButton(
          onPressed: onDetailsPressed, 
          icon: const Icon(Icons.remove_red_eye_outlined, size: 20, color: primaryRed)
        ),
        IconButton(
          onPressed: onPdfPreviewPressed, // Conectado correctamente
          icon: const Icon(Icons.picture_as_pdf, size: 20, color: Colors.blue)
        ),
        IconButton(
          onPressed: onDownloadPressed, 
          icon: const Icon(Icons.file_download_outlined, size: 20, color: Colors.indigo)
        ),
        IconButton(
          onPressed: onPrintPressed, 
          icon: const Icon(Icons.print_outlined, size: 20, color: Colors.teal)
        ),
      ],
    );
  }

  Widget _statusChip(String state) {
    final bool isCompleted = state.toUpperCase().contains('COMPLETED') || state.toUpperCase().contains('FINALIZADO');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50, 
        borderRadius: BorderRadius.circular(30)
      ),
      child: Text(
        isCompleted ? 'COMPLETADO' : 'EN PROCESO', 
        style: TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.w900, 
          color: isCompleted ? Colors.green.shade700 : Colors.orange.shade800
        )
      ),
    );
  }

  Widget _versionChip(String folio) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE), 
        borderRadius: BorderRadius.circular(30)
      ),
      child: Text(
        folio, 
        style: const TextStyle(color: primaryRed, fontWeight: FontWeight.w900, fontSize: 10)
      ),
    );
  }
}