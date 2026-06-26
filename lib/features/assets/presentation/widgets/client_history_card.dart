import 'package:crv_reprosisa/core/utils/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/client_history.dart';

class ClientHistoryCard extends StatefulWidget {
  final List<ClientHistory> versions;
  final Function(String) onPdfView;
final Future<void> Function(String) onDownload;
final Future<void> Function(String) onPrint;

  const ClientHistoryCard({
    super.key,
    required this.versions,
    required this.onPdfView,
    required this.onDownload,
    required this.onPrint,
  });

  @override
  State<ClientHistoryCard> createState() => _ClientHistoryCardState();
}

class _ClientHistoryCardState extends State<ClientHistoryCard> {
  late ClientHistory selected;
  
  bool _isDownloading = false;
  bool _isPrinting = false;

  static const Color primaryRed = Color(0xFFC62828);
  static const Color backgroundGrey = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    selected = widget.versions.firstWhere(
      (v) => v.isCurrent,
      orElse: () => widget.versions.first,
    );
  }

Future<void> _handleDownload(String versionId) async {
    LoadingOverlay.show(context, "Descargando reporte...");
    try {
      await widget.onDownload(versionId);
    } catch (e) {
      debugPrint("Error al descargar: $e");
    } finally {
      if (mounted) LoadingOverlay.hide(context);
    }
  }

  Future<void> _handlePrint(String versionId) async {
    LoadingOverlay.show(context, "Preparando impresión...");
    try {
      await widget.onPrint(versionId);
    } catch (e) {
      debugPrint("Error al imprimir: $e");
    } finally {
      if (mounted) LoadingOverlay.hide(context);
    }
  }
Future<void> _handleViewPdf(String versionId) async {
  LoadingOverlay.show(context, "Generando vista previa...");
  
  try {
    // Es vital que el await sea directo aquí
    await widget.onPdfView(versionId);
  } catch (e) {
    debugPrint("Error al ver PDF: $e");
    // Opcional: mostrar un SnackBar de error aquí
  } finally {
    // Esto asegura que siempre se oculte, incluso si hay error
    if (mounted) {
      LoadingOverlay.hide(context);
    }
  }
}
@override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _badge(selected.state),
              Flexible(child: _versionSelector()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.business_rounded, color: primaryRed, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected.conveyorName.toUpperCase(),
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
                      "Compañía: ${selected.clientCompany} • Cliente: ${selected.clientName}",
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
          Row(
            children: [
              const Icon(Icons.landscape_rounded, size: 16, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${selected.mineName} • ${selected.areaName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (selected.material.isNotEmpty || selected.granulometry.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)
              ),
              child: Text(
                "Material: ${selected.material} | Granulometría: ${selected.granulometry}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.grey.shade700),
              ),
            ),
            const SizedBox(height: 14),
          ],
          
          // --- AQUÍ INTEGRADO EL CAMBIO DE COMENTARIOS ---
          if (selected.comment != null && selected.comment!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text("COMENTARIOS DEL REPORTE", 
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500)),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: Text(
                selected.comment!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade800, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 14),
          ],
          
          _infoContainer(),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300, thickness: 1.5),
          const SizedBox(height: 4),
          _footer(selected.folio, selected.versionNumber),
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
          Expanded(child: _infoRow(Icons.person_outline, selected.inspectorName)),
          const SizedBox(width: 6),
          Expanded(child: _infoRow(Icons.calendar_today_outlined, DateFormat('dd/MM/yyyy').format(selected.inspectionDate))),
          const SizedBox(width: 6),
          Expanded(child: _infoRow(Icons.image_outlined, "${selected.evidencesCount} adjuntos")),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.5, color: Colors.grey.shade800, fontWeight: FontWeight.w700)
          ),
        ),
      ],
    );
  }

  Widget _footer(String folio, int version) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _versionChip("Folio: $folio (v$version)", primaryRed),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionBtn(
              Icons.picture_as_pdf, 
              primaryRed, 
              () => widget.onPdfView(selected.versionId)
            ),
            // Botón de descarga con indicador visual de carga
            _isDownloading 
                ? const SizedBox(
                    width: 36, 
                    height: 36, 
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: primaryRed),
                    ),
                  )
                : _actionBtn(
                    Icons.download, 
                    primaryRed, 
                    () => _handleDownload(selected.versionId)
                  ),
            // Botón de impresión con indicador visual de carga
            _isPrinting 
                ? const SizedBox(
                    width: 36, 
                    height: 36, 
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: primaryRed),
                    ),
                  )
                : _actionBtn(
                    Icons.print, 
                    primaryRed, 
                    () => _handlePrint(selected.versionId)
                  ),
          ],
        ),
      ],
    );
  }

  Widget _versionSelector() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade300, width: 1.2)
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<ClientHistory>(
        value: selected,
        icon: const Icon(Icons.history, color: primaryRed, size: 18),
        items: widget.versions
            .map(
              (v) => DropdownMenuItem(
                value: v,
                child: Text(
                  "Versión v${v.versionNumber}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => selected = v!),
      ),
    ),
  );

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) => IconButton(
    icon: Icon(icon, size: 22),
    color: color,
    onPressed: onTap,
    constraints: const BoxConstraints(minWidth: 36, maxWidth: 40),
    splashRadius: 20,
    padding: EdgeInsets.zero,
  );

  Widget _badge(String state) {
    Color c;
    String txt;
    switch (state.toUpperCase()) {
      case "COMPLETED":
        c = Colors.green.shade700;
        txt = "COMPLETADO";
        break;
      case "IN_PROGRESS":
        c = Colors.amber.shade800;
        txt = "EN PROCESO";
        break;
      default:
        c = primaryRed;
        txt = "PENDIENTE";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: c.withOpacity(0.25), width: 1.2)
      ),
      child: Text(
        txt,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: c, letterSpacing: 0.5),
      ),
    );
  }

  Widget _versionChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25))
      ),
      child: Text(
        text, 
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 10)
      ),
    );
  }
}