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
      ),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(24), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _badge(selected.state),
            const SizedBox(height: 12),
            Text("FOLIO: ${selected.folio}".toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: Colors.grey)),
            Text(selected.clientName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            Text("${selected.mineName} • ${selected.areaName}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ])),
          _versionSelector()
        ])),
        const Divider(height: 1),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), child: Row(children: [
          Expanded(child: _info("INSPECTOR", selected.inspectorName)),
          Expanded(child: _info("MATERIAL", selected.material)),
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
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
    child: DropdownButtonHideUnderline(child: DropdownButton<ClientHistory>(
      value: selected, icon: const Icon(Icons.history, color: Colors.redAccent, size: 18),
      items: widget.versions.map((v) => DropdownMenuItem(value: v, child: Text("v${v.versionNumber}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))).toList(),
      onChanged: (v) => setState(() => selected = v!),
    )),
  );

  Widget _info(String l, String v) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(l, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
    const SizedBox(height: 4),
    Text(v, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
  ]);

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) => IconButton(
    icon: Icon(icon, size: 20), color: color, onPressed: onTap, constraints: const BoxConstraints(minWidth: 40)
  );

  Widget _badge(String state) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: state == "COMPLETED" ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
    child: Text(state == "COMPLETED" ? "COMPLETADO" : "EN PROCESO", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.redAccent))
  );
}