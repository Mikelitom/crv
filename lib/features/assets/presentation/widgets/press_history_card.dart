import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/press_history.dart';

class PressHistoryCard extends StatefulWidget {
  final List<PressHistory> versions;
  final Function(String) onDetailsPressed;
  final Function(String) onPdfPreviewPressed;
  final Function(String) onPrintPressed;

  const PressHistoryCard({
    super.key,
    required this.versions,
    required this.onDetailsPressed,
    required this.onPdfPreviewPressed,
    required this.onPrintPressed,
  });

  @override
  State<PressHistoryCard> createState() => _PressHistoryCardState();
}

class _PressHistoryCardState extends State<PressHistoryCard> {
  late PressHistory selected;

  static const Color primaryRed = Color(0xFFC62828);
  static const Color backgroundGrey = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    selected = widget.versions.firstWhere(
      (v) => v.isCurrent == true,
      orElse: () => widget.versions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
          // Fila superior: Estado y Selector de Versión (Esquina Superior Responsiva)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(selected.state),
              Flexible(child: _versionDropdown()),
            ],
          ),
          const SizedBox(height: 16),

          // Encabezado principal: Icono, Modelo y Tipo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.precision_manufacturing_rounded, color: primaryRed, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${selected.model} - ${selected.type}".toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w900, 
                        color: Colors.black87
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Serie: ${selected.serie} • Tamaño: ${selected.size} • Volts: ${selected.voltz}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.grey.shade600
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Área
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Área: ${selected.area.toUpperCase()}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contenedor de información (Fecha y Evidencias) - Responsivo
          _infoContainer(),
          const SizedBox(height: 16),

          Divider(color: Colors.grey.shade300, thickness: 1.5),
          const SizedBox(height: 4),

          // Pie de página adaptativo
          _footer(context),
        ],
      ),
    );
  }

  Widget _infoContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundGrey, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1)
      ),
      child: Row(
        children: [
          Expanded(
            child: _infoRow(Icons.calendar_today, DateFormat('yyyy-MM-dd').format(selected.inspectionDate)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _infoRow(Icons.image_outlined, "${selected.evidencesCount} evidencias"),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    final nameWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.person_outline, size: 18, color: Colors.black45),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            selected.responsibleName.isNotEmpty ? selected.responsibleName : "Sin responsable", 
            style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w800, fontSize: 11.5), 
            overflow: TextOverflow.ellipsis
          ),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 2,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        _versionChip("Folio: ${selected.folio}", primaryRed),
        const SizedBox(width: 2),
        IconButton(
          onPressed: () => widget.onPdfPreviewPressed(selected.versionId), 
          icon: const Icon(Icons.picture_as_pdf, size: 20, color: primaryRed),
          tooltip: "Vista Previa",
          splashRadius: 18,
          constraints: const BoxConstraints(minWidth: 32, maxWidth: 36),
          padding: EdgeInsets.zero,
        ),
        IconButton(
          onPressed: () => widget.onPrintPressed(selected.versionId), 
          icon: const Icon(Icons.print_outlined, size: 20, color: primaryRed),
          tooltip: "Imprimir",
          splashRadius: 18,
          constraints: const BoxConstraints(minWidth: 32, maxWidth: 36),
          padding: EdgeInsets.zero,
        ),
        IconButton(
          onPressed: () => widget.onDetailsPressed(selected.versionId), 
          icon: const Icon(Icons.download, size: 20, color: primaryRed),
          tooltip: "Descargar PDF",
          splashRadius: 18,
          constraints: const BoxConstraints(minWidth: 32, maxWidth: 36),
          padding: EdgeInsets.zero,
        ),
      ],
    );

    if (isMobile) {
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
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    constraints: const BoxConstraints(maxWidth: 120),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade300, width: 1.2)
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<PressHistory>(
        isExpanded: true,
        value: selected, 
        icon: const Icon(Icons.history, color: primaryRed, size: 14),
        items: widget.versions.map((v) => DropdownMenuItem(
          value: v, 
          child: Text("Versión v${v.versionNumber}", overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10.5))
        )).toList(),
        onChanged: (v) => setState(() => selected = v!),
      ),
    ),
  );

  Widget _buildStatusChip(String state) {
    final bool isCompleted = state.toUpperCase().contains('COMPLETED') || state.toUpperCase().contains('FINALIZADO');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isCompleted ? Colors.green.shade200 : Colors.orange.shade200)
      ),
      child: Text(
        isCompleted ? 'COMPLETADO' : 'EN PROCESO',
        style: TextStyle(
          color: isCompleted ? Colors.green.shade800 : Colors.orange.shade900,
          fontSize: 9.5, 
          fontWeight: FontWeight.w900
        )
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
            style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w700)
          ),
        ),
      ],
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