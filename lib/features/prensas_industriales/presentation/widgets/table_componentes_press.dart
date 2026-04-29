import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/component_item.dart';

const Color kRedReprosisa = Color(0xFFC62828);
const Color kHeaderGray = Color(0xFFF1F3F4);
const Color kBorderColor = Color(0xFFDDE1E6);

class PrensaInspectionTable extends StatefulWidget {
  final List<ComponentItem> items;
  const PrensaInspectionTable({super.key, required this.items});

  @override
  State<PrensaInspectionTable> createState() => _PrensaInspectionTableState();
}

class _PrensaInspectionTableState extends State<PrensaInspectionTable> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 800) {
        return _buildUnifiedMobileTable(); // Vista integrada y moderna
      }
      return _buildDesktopTable();
    });
  }

  // --- VISTA ESCRITORIO ---
  Widget _buildDesktopTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DataTable(
          headingRowHeight: 65,
          dataRowMaxHeight: 85,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
          columns: const [
            DataColumn(label: Text("CANT.", style: TextStyle(fontWeight: FontWeight.w900))),
            DataColumn(label: Text("UNID.", style: TextStyle(fontWeight: FontWeight.w900))),
            DataColumn(label: Text("DESCRIPCIÓN", style: TextStyle(fontWeight: FontWeight.w900))),
            DataColumn(label: Text("CONDICIÓN", style: TextStyle(fontWeight: FontWeight.w900))),
            DataColumn(label: Text("EVIDENCIA", style: TextStyle(fontWeight: FontWeight.w900))),
          ],
          rows: widget.items.map((item) => DataRow(cells: [
            DataCell(_qtyInput(item)),
            DataCell(Text(item.measureUnit, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600))),
            DataCell(_desktopStatus(item)),
            DataCell(_evidenceDual(item, 40)),
          ])).toList(),
        ),
      ),
    );
  }

  // --- VISTA MÓVIL INTEGRADA (UN COMPONENTE SOBRE OTRO) ---
  Widget _buildUnifiedMobileTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
      ),
      child: Column(
        children: widget.items.asMap().entries.map((entry) {
          final item = entry.value;
          bool isLast = entry.key == widget.items.length - 1;

          return Container(
            decoration: BoxDecoration(
              border: isLast ? null : const Border(bottom: BorderSide(color: kBorderColor, width: 1.5)),
            ),
            child: Column(
              children: [
                // Cabecera del ítem: Cantidad y Unidad
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: kHeaderGray.withOpacity(0.5),
                  child: Row(
                    children: [
                      const Text("CANT:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                      const SizedBox(width: 8),
                      Expanded(child: _qtyInput(item, isSmall: true)),
                      const SizedBox(width: 16),
                      const Text("UNID:", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                      const SizedBox(width: 8),
                      Text(item.measureUnit, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                    ],
                  ),
                ),
                // Descripción
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    item.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1A1C1E)),
                  ),
                ),
                // Condición y Acciones
                IntrinsicHeight(
                  child: Row(
                    children: [
                      // Panel Izquierdo: Radio Buttons de Condición
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _subHeader("CONDICIÓN"),
                            _mobileRadio(item, "good", "BUENO", Colors.green),
                            _mobileRadio(item, "bad", "MALO", kRedReprosisa),
                            _mobileRadio(item, "not_applicable", "N/A", Colors.grey),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1, thickness: 1, color: kBorderColor),
                      // Panel Derecho: Acciones Mejoradas Visualmente
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _subHeader("ACCIONES"),
                            const Spacer(),
                            // Botón de Observación Estilizado
                            _prettyActionBtn(Icons.chat_bubble_outline_rounded, "NOTA", () => _showNoteModal(item)),
                            const SizedBox(height: 12),
                            // Botones de Fotos Compactos y Bonitos
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _evidenceDual(item, 38, showLabel: true),
                            ),
                          ],
                        ),
                      ),
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

  // --- COMPONENTES DE DISEÑO ---

  Widget _subHeader(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 4),
    decoration: const BoxDecoration(color: kHeaderGray),
    child: Center(child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueGrey))),
  );

  Widget _prettyActionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kRedReprosisa,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: kRedReprosisa.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _mobileRadio(ComponentItem item, String val, String label, Color color) {
    bool isSel = item.status == val;
    return InkWell(
      onTap: () => setState(() => item.status = val),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(isSel ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: 20, color: isSel ? color : Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.w900 : FontWeight.bold, color: isSel ? color : Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _qtyInput(ComponentItem item, {bool isSmall = false}) {
    return SizedBox(
      width: isSmall ? 80 : 50,
      height: 35,
      child: TextField(
        onChanged: (v) => item.quantity = int.tryParse(v),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        decoration: InputDecoration(
          hintText: "0",
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: kBorderColor)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: kRedReprosisa)),
        ),
      ),
    );
  }

  Widget _evidenceDual(ComponentItem item, double size, {bool showLabel = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _mediaBox(showLabel ? "A" : "", item.evidenceBefore, () => _pick(item, true), size),
        const SizedBox(width: 8),
        _mediaBox(showLabel ? "D" : "", item.evidenceAfter, () => _pick(item, false), size),
      ],
    );
  }

  Widget _mediaBox(String label, List<EvidenceFile> files, VoidCallback onTap, double size) {
    bool hasData = files.isNotEmpty;
    return Column(
      children: [
        if (label.isNotEmpty) Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.grey)),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: hasData ? kRedReprosisa : kBorderColor, width: 1.5),
            ),
            child: hasData
                ? ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.memory(files.first.bytes, fit: BoxFit.cover))
                : const Icon(Icons.add_a_photo_outlined, size: 18, color: kRedReprosisa),
          ),
        ),
      ],
    );
  }

  void _showNoteModal(ComponentItem item) {
    final ctrl = TextEditingController(text: item.observation);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Observaciones", style: TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(controller: ctrl, maxLines: 3, decoration: const InputDecoration(hintText: "Escribe aquí...", border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kRedReprosisa),
            onPressed: () { setState(() => item.observation = ctrl.text); Navigator.pop(context); },
            child: const Text("GUARDAR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _desktopStatus(ComponentItem item) {
    return Row(
      children: [
        _stCircle(item, "good", Colors.green, Icons.check),
        const SizedBox(width: 8),
        _stCircle(item, "bad", kRedReprosisa, Icons.close),
      ],
    );
  }

  Widget _stCircle(ComponentItem item, String val, Color c, IconData i) {
    bool isSel = item.status == val;
    return GestureDetector(
      onTap: () => setState(() => item.status = val),
      child: CircleAvatar(radius: 16, backgroundColor: isSel ? c : kHeaderGray, child: Icon(i, size: 14, color: isSel ? Colors.white : Colors.grey)),
    );
  }

  Future<void> _pick(ComponentItem item, bool isBefore) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        final ev = EvidenceFile(bytes: bytes, type: "image", mimeType: "image/jpeg");
        if (isBefore) item.evidenceBefore = [ev]; else item.evidenceAfter = [ev];
      });
    }
  }
}