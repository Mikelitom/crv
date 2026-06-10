import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/client_history.dart';

class ClientHistoryCard extends StatefulWidget {
  final List<ClientHistory> versions;
  final Function(String) onPdfView;
  final Function(String) onDownload;
  final Function(String) onPrint;

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

  @override
  void initState() {
    super.initState();
    selected = widget.versions.firstWhere((v) => v.isCurrent, orElse: () => widget.versions.first);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _badge(selected.state),
            const SizedBox(height: 12),
            Text(selected.conveyorName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            Text("FOLIO: ${selected.folio} | v${selected.versionNumber}", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.grey)),
            Text("${selected.mineName} • ${selected.areaName}", style: const TextStyle(color: Colors.blueGrey, fontSize: 13)),
          ])),
          _versionSelector()
        ])),
        const Divider(height: 1),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Row(children: [
          _info("INSPECTOR", selected.inspectorName),
          const SizedBox(width: 15),
          _info("FECHA", DateFormat('dd/MM/yy').format(selected.inspectionDate)),
          const SizedBox(width: 15),
          _info("EVIDENCIAS", "${selected.evidencesCount} adjuntos"),
          const Spacer(),
          Row(children: [
            _actionBtn(Icons.picture_as_pdf, Colors.redAccent, () => widget.onPdfView(selected.versionId)),
            _actionBtn(Icons.download, Colors.grey.shade600, () => widget.onDownload(selected.versionId)),
            _actionBtn(Icons.print, Colors.grey.shade600, () => widget.onPrint(selected.versionId)),
          ])
        ])),
      ]),
    );
  }

  Widget _versionSelector() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
    child: DropdownButtonHideUnderline(child: DropdownButton<ClientHistory>(
      value: selected, icon: const Icon(Icons.history, color: Colors.redAccent, size: 16),
      items: widget.versions.map((v) => DropdownMenuItem(value: v, child: Text("v${v.versionNumber}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)))).toList(),
      onChanged: (v) => setState(() => selected = v!),
    )),
  );

  Widget _info(String l, String v) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(l, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
    const SizedBox(height: 2),
    Text(v, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
  ]);

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) => IconButton(
    icon: Icon(icon, size: 18), color: color, onPressed: onTap, constraints: const BoxConstraints(minWidth: 36)
  );

  Widget _badge(String state) {
    Color c;
    String txt;
    switch (state.toUpperCase()) {
      case "COMPLETED": c = Colors.green; txt = "COMPLETADO"; break;
      case "IN_PROGRESS": c = Colors.amber.shade700; txt = "EN PROCESO"; break;
      default: c = Colors.redAccent; txt = "PENDIENTE";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(txt, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: c))
    );
  }
}