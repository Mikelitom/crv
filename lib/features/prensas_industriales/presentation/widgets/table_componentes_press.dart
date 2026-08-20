import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/component_item.dart';

// Paleta de colores institucional Reprosisa
const Color kRedReprosisa = Color(0xFFC62828);
const Color kHeaderGray = Color(0xFFF8FAFC); 
const Color kBorderSuave = Color(0xFFE2E8F0); 
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
      if (constraints.maxWidth < 1100) {
        return _buildResponsiveMobileTabletList(); 
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
          dataRowMaxHeight: 120,
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(kHeaderGray),
          columns: const [
            DataColumn(label: _HeaderLabel('CANTID.')),
            DataColumn(label: _HeaderLabel('UNIDAD')),
            DataColumn(label: _HeaderLabel('DESCRIPCIÓN DEL COMPONENTE')),
            DataColumn(label: _HeaderLabel('CONDICIÓN')),
            DataColumn(label: _HeaderLabel('OBSERVACIONES')), 
            DataColumn(label: _HeaderLabel('EVID. (A / D)')),
          ],
          rows: widget.items.map((item) => DataRow(
            cells: [
              DataCell(_qtyField(item)),
              DataCell(Text(item.measureUnit, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
              DataCell(SizedBox(
                width: 250,
                child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, color: kTextDark))
              )),
              DataCell(_desktopStatus(item)), 
              DataCell(_desktopNoteField(item)), 
              DataCell(_evidenceDual(item, 35, true)),
            ],
          )).toList(),
        ),
      ),
    );
  }

  // --- DISEÑO ADAPTADO PARA MÓVIL Y TABLET SIN DESBORDAMIENTOS ---
  Widget _buildResponsiveMobileTabletList() {
    return Column(
      children: widget.items.asMap().entries.map((entry) {
        final item = entry.value;
        bool hasNote = item.observation.isNotEmpty;
        bool isGood = item.status == "GOOD";
        bool isBad = item.status == "BAD";

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isGood ? Colors.green.withOpacity(0.4) : (isBad ? kRedReprosisa.withOpacity(0.4) : kBorderSuave),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TÍTULO DEL COMPONENTE
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isGood ? Colors.green : (isBad ? kRedReprosisa : Colors.blueGrey.shade400),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: kTextDark,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. FILA DE CANTIDAD Y UNIDAD
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("CANTIDAD", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                          const SizedBox(height: 6),
                          _qtyField(item),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("UNIDAD", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kBorderSuave, width: 1.2),
                            ),
                            child: Center(
                              child: Text(
                                item.measureUnit,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: kTextDark),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. CONDICIÓN (BUENO / MALO)
                const Text("CONDICIÓN", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                const SizedBox(height: 6),
                _modernConditionSelector(item),
                
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEDF2F7)),
                const SizedBox(height: 14),

                // 4. PIE DE TARJETA CON WRAP PARA EVITAR OVERFLOW EN TABLETS/MÓVILES PEQUEÑOS
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _showNote(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: hasNote ? kRedReprosisa.withOpacity(0.06) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: hasNote ? kRedReprosisa : kBorderSuave,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              hasNote ? Icons.speaker_notes_rounded : Icons.edit_note_rounded,
                              size: 15,
                              color: hasNote ? kRedReprosisa : kTextDark,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              hasNote ? "VER NOTA" : "AGREGAR NOTA",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: hasNote ? kRedReprosisa : kTextDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("EVIDENCIA", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                        const SizedBox(width: 6),
                        _evidenceDual(item, 34, false),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _desktopNoteField(ComponentItem item) {
    return SizedBox(
      width: 250,
      child: TextField(
        onChanged: (v) => item.observation = v,
        controller: TextEditingController(text: item.observation)..selection = TextSelection.collapsed(offset: item.observation.length),
        maxLines: 2,
        minLines: 1,
        style: const TextStyle(fontSize: 13, color: kTextDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Nota...",
          hintStyle: TextStyle(color: Colors.blueGrey.withOpacity(0.6), fontSize: 13),
          filled: true,
          fillColor: kHeaderGray.withOpacity(0.4), 
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kBorderSuave.withOpacity(0.3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kRedReprosisa, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _modernConditionSelector(ComponentItem item) {
    return Row(
      children: [
        _condBtn(item, "GOOD", "BUENO", Colors.green),
        const SizedBox(width: 10),
        _condBtn(item, "BAD", "MALO", kRedReprosisa),
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
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSel ? color : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSel ? color : kBorderSuave, 
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label, 
              style: TextStyle(
                fontSize: 10, 
                fontWeight: FontWeight.w900, 
                color: isSel ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _qtyField(ComponentItem item) => SizedBox(
    width: double.infinity,
    child: TextField(
      onChanged: (v) {
        final parsed = int.tryParse(v);
        setState(() => item.quantity = parsed);
      },
      textAlign: TextAlign.center, 
      keyboardType: TextInputType.number,
      controller: TextEditingController(
        text: (item.quantity == null || item.quantity == 0) ? "" : item.quantity.toString(),
      )..selection = TextSelection.collapsed(
          offset: (item.quantity == null || item.quantity == 0) ? 0 : item.quantity.toString().length,
        ),
      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
      decoration: InputDecoration(
        hintText: "0", 
        filled: true, 
        fillColor: const Color(0xFFF8FAFC), 
        isDense: true, 
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorderSuave, width: 1.2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kRedReprosisa, width: 1.5)),
      ),
    ),
  );

  Widget _evidenceDual(ComponentItem item, double size, bool showLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHorizontalSection("A", item.evidenceBefore, true, size, item),
          const SizedBox(width: 6),
          _buildHorizontalSection("D", item.evidenceAfter, false, size, item),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection(String label, List<EvidenceFile> files, bool isBefore, double size, ComponentItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(width: 3),
        ...files.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => _showFullImage(file.bytes),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(file.bytes, fit: BoxFit.cover, width: size, height: size),
                  ),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      if (isBefore) {
                        item.evidenceBefore.removeAt(index);
                      } else {
                        item.evidenceAfter.removeAt(index);
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 7, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        GestureDetector(
          onTap: () => _pick(item, isBefore),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: kHeaderGray,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBorderSuave, width: 1.2),
            ),
            child: Icon(Icons.add_a_photo_rounded, size: 14, color: kRedReprosisa.withOpacity(0.9)),
          ),
        ),
      ],
    );
  }

  // --- POPUP DE NOTAS CON FONDO COMPLETAMENTE BLANCO ---
  void _showNote(ComponentItem item) {
    final ctrl = TextEditingController(text: item.observation);
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Notas del Componente", 
          style: TextStyle(fontWeight: FontWeight.w900, color: kTextDark, fontSize: 16),
        ),
        content: TextField(
          controller: ctrl, 
          maxLines: 4, 
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: "Escriba las observaciones aquí...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderSuave),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderSuave),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kRedReprosisa, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("CANCELAR", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedReprosisa,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ), 
            onPressed: () { 
              setState(() => item.observation = ctrl.text); 
              Navigator.pop(context); 
            }, 
            child: const Text("GUARDAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
          if (isBefore) {
            item.evidenceBefore.add(ev);
          } else {
            item.evidenceAfter.add(ev);
          }
        });
      }
    }
  }

  Widget _desktopStatus(ComponentItem item) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _stBtn(item, "GOOD", Colors.green, Icons.check, "BUENO"),
      const SizedBox(width: 10),
      _stBtn(item, "BAD", kRedReprosisa, Icons.close, "MALO"),
    ],
  );

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