import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatefulWidget {
  final List<dynamic> versions; // Recibe todas las versiones de este folio (ej. v1, v2)
  final VoidCallback onDownloadPressed;
  final VoidCallback onPrintPressed;
  final VoidCallback onPdfPreviewPressed;

  const HistoryCard({
    super.key,
    required this.versions,
    required this.onDownloadPressed,
    required this.onPrintPressed,
    required this.onPdfPreviewPressed,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  late dynamic selected;

  static const Color primaryRed = Color(0xFFC62828);
  static const Color backgroundGrey = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    // Selecciona la versión actual (isCurrent) por defecto al inicializar
    selected = widget.versions.firstWhere(
      (v) => v.isCurrent == true,
      orElse: () => widget.versions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Manejo seguro de la lista de evidencias del elemento seleccionado
    final List<String> paths = (selected.evidencePaths is List) ? List<String>.from(selected.evidencePaths) : [];
    
    // Propiedades del vehículo
    final String brand = selected.brand ?? '';
    final String model = selected.model ?? '';
    final String year = selected.year?.toString() ?? '';
    final String plate = selected.plate ?? '';
    final String unit = selected.unit?.toString() ?? '';
    final String vehicleType = selected.vehicleType ?? '';
    final String folio = selected.folio ?? '';
    final bool requiresService = selected.requiresService ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: Estado, Alerta y Selector de Versión más compacto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _statusChip(selected.state ?? ''),
                    if (requiresService) _serviceWarningChip(),
                  ],
                ),
              ),
              _versionDropdown(),
            ],
          ),
          const SizedBox(height: 14),

          // Encabezado principal del vehículo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping_rounded, color: primaryRed, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$brand $model $year".toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w900, 
                        color: Colors.black87
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Placa: $plate • Unidad: $unit • Tipo: $vehicleType",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.grey.shade600
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Notas / Observaciones generales
          Text(
            (selected.generalNotes != null && selected.generalNotes.toString().trim().length > 1)
                ? selected.generalNotes.toString()
                : "Sin observaciones adicionales registradas.",
            style: const TextStyle(
              fontSize: 12.5, 
              height: 1.4, 
              fontWeight: FontWeight.w500, 
              color: Colors.black54
            ),
          ),
          const SizedBox(height: 12),

          // Contenedor de información (Kilometraje y Fecha)
          _infoContainer(),
          const SizedBox(height: 12),

          // Sección de evidencias
          _evidenceSection(paths),
          const SizedBox(height: 6),

          Divider(color: Colors.grey.shade300, thickness: 1.5),
          const SizedBox(height: 4),

          // Pie de página adaptativo (Móvil vs Escritorio)
          _footer(context, folio),
        ],
      ),
    );
  }

  Widget _infoContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundGrey, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1)
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 6,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 130, 
            child: _infoRow(Icons.speed_outlined, '${selected.mileage ?? 0} KM'),
          ),
          SizedBox(
            width: 140,
            child: _infoRow(
              Icons.calendar_today_outlined, 
              selected.inspectionDate != null ? DateFormat('yyyy-MM-dd').format(selected.inspectionDate) : '-'
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w700, fontSize: 12.5)
          ),
        ),
      ],
    );
  }

  Widget _evidenceSection(List<String> paths) {
    return Row(
      children: [
        Icon(Icons.image_outlined, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        const Text(
          'EVIDENCIA FOTOGRÁFICA', 
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w900, fontSize: 10.5)
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: primaryRed.withOpacity(0.08), 
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryRed.withOpacity(0.25))
          ),
          child: Text(
            "${paths.length} adjuntos", 
            style: const TextStyle(color: primaryRed, fontSize: 9.5, fontWeight: FontWeight.w900)
          ),
        ),
      ],
    );
  }

  Widget _footer(BuildContext context, String folio) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    final nameWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.person_outline, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            selected.responsibleName ?? "Sin responsable", 
            style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w800, fontSize: 10), 
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final actionsWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: _versionChip("Folio: $folio", primaryRed),
        ),
        const SizedBox(width: 2),
        IconButton(
          onPressed: widget.onPdfPreviewPressed, 
          icon: const Icon(Icons.picture_as_pdf, size: 20, color: primaryRed),
          splashRadius: 16,
          constraints: const BoxConstraints(minWidth: 32, maxWidth: 36),
          padding: EdgeInsets.zero,
        ),
        IconButton(
          onPressed: widget.onDownloadPressed, 
          icon: const Icon(Icons.file_download_outlined, size: 20, color: primaryRed),
          splashRadius: 16,
          constraints: const BoxConstraints(minWidth: 32, maxWidth: 36),
          padding: EdgeInsets.zero,
        ),
        IconButton(
          onPressed: widget.onPrintPressed, 
          icon: const Icon(Icons.print_outlined, size: 20, color: primaryRed),
          splashRadius: 16,
          constraints: const BoxConstraints(minWidth: 32, maxWidth: 36),
          padding: EdgeInsets.zero,
        ),
      ],
    );

    if (isMobile) {
      // En móvil: Nombre arriba, Folio + Acciones abajo
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nameWidget,
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: actionsWidget,
          ),
        ],
      );
    } else {
      // En escritorio: Todo en una línea (Responsable izq, Folio+Acciones der)
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: nameWidget),
          actionsWidget,
        ],
      );
    }
  }

  Widget _versionDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    constraints: const BoxConstraints(maxWidth: 110), 
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300, width: 1)
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<dynamic>(
        isExpanded: true,
        value: selected, 
        icon: const Icon(Icons.history, color: primaryRed, size: 14),
        items: widget.versions.map((v) => DropdownMenuItem(
          value: v, 
          child: Text("Versión v${v.versionNumber}", overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10))
        )).toList(),
        onChanged: (v) => setState(() => selected = v!),
      ),
    ),
  );

  Widget _statusChip(String state) {
    final bool isCompleted = state.toUpperCase().contains('COMPLETED') || state.toUpperCase().contains('FINALIZADO');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50, 
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isCompleted ? Colors.green.shade200 : Colors.orange.shade200)
      ),
      child: Text(
        isCompleted ? 'COMPLETADO' : 'EN PROCESO', 
        style: TextStyle(
          fontSize: 8.5, 
          fontWeight: FontWeight.w900, 
          color: isCompleted ? Colors.green.shade800 : Colors.orange.shade900
        ),
      ),
    );
  }

  Widget _serviceWarningChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primaryRed.withOpacity(0.3), width: 1)
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 9, color: primaryRed),
          SizedBox(width: 3),
          Text(
            "REQUIERE SERVICIO", 
            style: TextStyle(color: primaryRed, fontSize: 8, fontWeight: FontWeight.w900)
          ),
        ],
      ),
    );
  }

  Widget _versionChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25))
      ),
      child: Text(
        text, 
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 9)
      ),
    );
  }
}