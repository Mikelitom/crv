import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/component_item.dart';

// Paleta de colores institucional Reprosisa
const Color kRedReprosisa = Color(0xFFC62828);
const Color kHeaderGray = Color(0xFFF1F5F9); 
const Color kBorderSuave = Color(0xFFD1D9E0); 
const Color kTextDark = Color(0xFF0F172A);

class PrensaInspectionTable extends StatefulWidget {
  final List<ComponentItem> items;
  const PrensaInspectionTable({super.key, required this.items});

  @override
  State<PrensaInspectionTable> createState() => _PrensaInspectionTableState();
}

class _PrensaInspectionTableState extends State<PrensaInspectionTable> {
  final ImagePicker _picker = ImagePicker();

  void _showFullImage(Uint8List bytes) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(bytes, fit: BoxFit.contain),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 900) {
        return _buildHighDesignMobileList(); 
      }
      return _buildDesktopTable();
    });
  }

  Widget _buildDesktopTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderSuave, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable(
          headingRowHeight: 56,
          dataRowMaxHeight: 95,
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(kHeaderGray),
          columns: const [
            DataColumn(label: _HeaderLabel('CANTID.')),
            DataColumn(label: _HeaderLabel('UNIDAD')),
            DataColumn(label: _HeaderLabel('DESCRIPCIÓN DEL COMPONENTE')),
            DataColumn(label: _HeaderLabel('CONDICIÓN')),
            DataColumn(label: _HeaderLabel('EVIDENCIA (A / D)')),
          ],
          rows: widget.items.map((item) => DataRow(
            cells: [
              DataCell(_qtyField(item)),
              DataCell(Text(item.measureUnit, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
              DataCell(SizedBox(
                width: 350,
                child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, color: kTextDark))
              )),
              DataCell(_desktopStatus(item)), 
              DataCell(_evidenceDual(item, 44, true)),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildHighDesignMobileList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorderSuave, width: 1.2),
      ),
      child: Column(
        children: widget.items.asMap().entries.map((entry) {
          final item = entry.value;
          bool isLast = entry.key == widget.items.length - 1;

          return Container(
            decoration: BoxDecoration(
              border: isLast ? null : const Border(bottom: BorderSide(color: kBorderSuave, width: 1.5)),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: kHeaderGray,
                    borderRadius: entry.key == 0 ? const BorderRadius.vertical(top: Radius.circular(18)) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DESCRIPCIÓN DEL COMPONENTE", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.blueGrey)),
                      const SizedBox(height: 4),
                      Text(item.name.toUpperCase(), 
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: kTextDark, letterSpacing: 0.5)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _infoColumn("CANTIDAD", _qtyField(item)),
                          const SizedBox(width: 12),
                          _infoColumn("UNIDAD", _unitLabel(item.measureUnit)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("CONDICIÓN", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.blueGrey)),
                          const SizedBox(height: 8),
                          _modernConditionSelector(item),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: kHeaderGray.withOpacity(0.3),
                    borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(18)) : null,
                    border: const Border(top: BorderSide(color: kHeaderGray, width: 1.5)),
                  ),
                  child: Row(
                    children: [
                      _noteActionBtn(item),
                      const Spacer(),
                      const Text("FOTOS (A / D)", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                      const SizedBox(width: 12),
                      _evidenceDual(item, 40, false),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _infoColumn(String title, Widget content) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.blueGrey)),
        const SizedBox(height: 6),
        content,
      ],
    ),
  );

  Widget _unitLabel(String unit) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: kHeaderGray.withOpacity(0.5), 
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: kBorderSuave.withOpacity(0.5))
    ),
    child: Center(child: Text(unit, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
  );

  Widget _noteActionBtn(ComponentItem item) {
    bool hasNote = item.observation.isNotEmpty;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showNote(item),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: hasNote ? kRedReprosisa : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hasNote ? kRedReprosisa : kBorderSuave, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_note_rounded, color: hasNote ? Colors.white : kTextDark, size: 18),
              const SizedBox(width: 8),
              Text("NOTAS", style: TextStyle(color: hasNote ? Colors.white : kTextDark, fontSize: 10, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernConditionSelector(ComponentItem item) {
    return Row(
      children: [
        _condBtn(item, "GOOD", "BUENO", Colors.green),
        const SizedBox(width: 8),
        _condBtn(item, "BAD", "MALO", kRedReprosisa),
        const SizedBox(width: 8),
        _condBtn(item, "NOT_APPLICABLE", "N/A", Colors.blueGrey),
      ],
    );
  }

  Widget _condBtn(ComponentItem item, String val, String label, Color color) {
    bool isSel = item.status == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => item.status = val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSel ? color : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSel ? color : kBorderSuave, width: 1.2),
          ),
          child: Center(child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isSel ? Colors.white : Colors.black54))),
        ),
      ),
    );
  }

  Widget _qtyField(ComponentItem item) => TextField(
    onChanged: (v) => setState(() => item.quantity = int.tryParse(v)),
    textAlign: TextAlign.center, keyboardType: TextInputType.number,
    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
    decoration: InputDecoration(
      hintText: "0", filled: true, fillColor: Colors.white, isDense: true, 
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorderSuave, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kRedReprosisa, width: 2.0)),
    ),
  );

  Widget _evidenceDual(ComponentItem item, double size, bool showLabel) => Row(
    children: [
      _mediaBox("A", item.evidenceBefore, () => _pick(item, true), () => setState(() => item.evidenceBefore = []), size),
      const SizedBox(width: 8),
      _mediaBox("D", item.evidenceAfter, () => _pick(item, false), () => setState(() => item.evidenceAfter = []), size),
    ],
  );

  Widget _mediaBox(String label, List<EvidenceFile> files, VoidCallback onAdd, VoidCallback onDelete, double size) {
    bool hasData = files.isNotEmpty;
    return GestureDetector(
      onTap: hasData ? () => _showFullImage(files.first.bytes) : onAdd,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10), 
          border: Border.all(color: hasData ? kRedReprosisa : kBorderSuave, width: 1.5)
        ),
        child: hasData
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(files.first.bytes, fit: BoxFit.cover, width: size, height: size)),
                  Positioned(top: -6, right: -6, child: GestureDetector(onTap: onDelete, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle), child: const Icon(Icons.close, size: 10, color: Colors.white)))),
                ],
              )
            : Icon(Icons.camera_alt_rounded, size: 18, color: kRedReprosisa.withOpacity(0.6)),
      ),
    );
  }

  void _showNote(ComponentItem item) {
    final ctrl = TextEditingController(text: item.observation);
    showDialog(context: context, builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Notas del Componente", style: TextStyle(fontWeight: FontWeight.w900)),
      content: TextField(controller: ctrl, maxLines: 4, decoration: const InputDecoration(hintText: "Escriba las observaciones aquí...", border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRedReprosisa), 
          onPressed: () { setState(() => item.observation = ctrl.text); Navigator.pop(context); }, 
          child: const Text("GUARDAR", style: TextStyle(color: Colors.white)))
      ]
    ));
  }

  Future<void> _pick(ComponentItem item, bool isBefore) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.camera_alt, color: kRedReprosisa), title: const Text("Cámara"), onTap: () => Navigator.pop(context, ImageSource.camera)),
        ListTile(leading: const Icon(Icons.photo_library, color: kRedReprosisa), title: const Text("Galería"), onTap: () => Navigator.pop(context, ImageSource.gallery)),
      ])),
    );
    if (source != null) {
      final file = await _picker.pickImage(source: source, imageQuality: 50);
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          final ev = EvidenceFile(bytes: bytes, type: "image", mimeType: "image/jpeg");
          if (isBefore) item.evidenceBefore = [ev]; else item.evidenceAfter = [ev];
        });
      }
    }
  }

  Widget _desktopStatus(ComponentItem item) => Row(children: [
    _stBtn(item, "GOOD", Colors.green, Icons.check, "BUENO"),
    const SizedBox(width: 10),
    _stBtn(item, "BAD", kRedReprosisa, Icons.close, "MALO"),
    const SizedBox(width: 10),
    _stBtn(item, "NOT_APPLICABLE", Colors.grey, Icons.remove, "N/A"),
  ]);

  Widget _stBtn(ComponentItem item, String val, Color c, IconData i, String l) {
    bool isSel = item.status == val;
    return GestureDetector(
      onTap: () => setState(() => item.status = val), 
      child: Row(children: [
        CircleAvatar(radius: 14, backgroundColor: isSel ? c : kHeaderGray, child: Icon(i, size: 14, color: isSel ? Colors.white : Colors.grey)), 
        const SizedBox(width: 6), 
        Text(l, style: TextStyle(fontSize: 10, fontWeight: isSel ? FontWeight.w900 : FontWeight.normal, color: isSel ? c : Colors.black54))
      ])
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String label;
  const _HeaderLabel(this.label);
  @override
  Widget build(BuildContext context) => Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.blueGrey, fontSize: 10));
}