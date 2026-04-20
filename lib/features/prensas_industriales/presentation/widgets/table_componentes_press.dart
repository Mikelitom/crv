import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para atajos de teclado
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/component_item.dart';

const Color kRedReprosisa = Color(0xFFC62828);

class PrensaInspectionTable extends StatefulWidget {
  final List<ComponentItem> items;
  const PrensaInspectionTable({super.key, required this.items});

  @override
  State<PrensaInspectionTable> createState() => _PrensaInspectionTableState();
}

class _PrensaInspectionTableState extends State<PrensaInspectionTable> {
  final ImagePicker _picker = ImagePicker();
  final double _btnSize = 42.0;
  final double _colWidth = 70.0;

  // --- FUNCIÓN PARA VER IMAGEN EN GRANDE ---
  void _showFullImage(Uint8List bytes) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // InteractiveViewer permite hacer zoom con los dedos o mouse
            Center(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(bytes, fit: BoxFit.contain),
                ),
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
    // Shortcuts: Envolvemos todo en un KeyboardListener
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        // Ejemplo opcional: Si quieres que al presionar '1' se marque la primera fila como buena
        // Esto se puede expandir según tu flujo de trabajo
      },
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return _buildMobileView();
        }
        return _buildDesktopView();
      }),
    );
  }

  Widget _buildDesktopView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: DataTable(
        headingRowHeight: 85,
        dataRowMaxHeight: 100,
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
        columnSpacing: 10,
        columns: [
          DataColumn(label: _HeaderLabel('Cant.')),
          DataColumn(label: _HeaderLabel('Unid.')),
          DataColumn(label: _HeaderLabel('Descripción')),
          DataColumn(label: SizedBox(
            width: _colWidth * 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Condición", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _stLabel("Buena (1)"), // Indicador de atajo
                    _stLabel("Mala (2)"),
                    _stLabel("N/A (3)"),
                  ],
                ),
              ],
            ),
          )),
          DataColumn(label: _HeaderLabel('Observaciones')),
          DataColumn(label: _HeaderLabel('Evidencia')),
        ],
        rows: widget.items.map((item) => DataRow(cells: [
          DataCell(SizedBox(width: 40, child: TextField(onChanged: (v) => item.quantity = int.tryParse(v), textAlign: TextAlign.center, decoration: const InputDecoration(border: InputBorder.none, hintText: "0")))),
          DataCell(Text(item.measureUnit, style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(SizedBox(width: 180, child: Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)))),
          DataCell(SizedBox(
            width: _colWidth * 3,
            child: Row(
              children: [
                _statusBtnWrapper(item, "good", Icons.check, Colors.green),
                _statusBtnWrapper(item, "bad", Icons.close, kRedReprosisa),
                _statusBtnWrapper(item, "not_applicable", Icons.remove, Colors.grey),
              ],
            ),
          )),
          DataCell(SizedBox(width: 180, child: TextField(onChanged: (v) => item.observation = v, decoration: const InputDecoration(hintText: "Notas...", border: InputBorder.none)))),
          DataCell(_buildEvidenceDual(item)),
        ])).toList(),
      ),
    );
  }

  Widget _buildMobileView() {
    return Column(
      children: widget.items.map((item) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              color: const Color(0xFFE9ECF1),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(child: Center(child: Text("CANTIDAD", style: _mobileLabelStyle))),
                  Expanded(child: Center(child: Text("UNIDAD", style: _mobileLabelStyle))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(child: Center(child: Text("${item.quantity ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text(item.measureUnit, style: const TextStyle(fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
            Container(color: const Color(0xFFE9ECF1), width: double.infinity, padding: const EdgeInsets.all(8), child: Center(child: Text("DESCRIPCIÓN DEL COMPONENTE", style: _mobileLabelStyle))),
            Padding(padding: const EdgeInsets.all(12), child: Text(item.name.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(color: const Color(0xFFE9ECF1), width: double.infinity, padding: const EdgeInsets.all(8), child: Center(child: Text("CONDICIÓN", style: _mobileLabelStyle))),
                      _mobileRadio(item, "good", "BUENO"),
                      _mobileRadio(item, "bad", "MALO"),
                      _mobileRadio(item, "not_applicable", "NO APLICA"),
                    ],
                  ),
                ),
                Container(width: 1, height: 150, color: Colors.grey.shade300),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(color: const Color(0xFFE9ECF1), width: double.infinity, padding: const EdgeInsets.all(8), child: Center(child: Text("ACCIONES", style: _mobileLabelStyle))),
                      const SizedBox(height: 20),
                      _mobileActionButton(Icons.chat_bubble, () {}),
                      const SizedBox(height: 12),
                      _mobileActionButton(Icons.file_upload, () => _showMediaOptions(item, true)),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      )).toList(),
    );
  }

  TextStyle get _mobileLabelStyle => const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87);

  Widget _mobileRadio(ComponentItem item, String val, String label) {
    bool isSel = item.status == val;
    return InkWell(
      onTap: () => setState(() => item.status = val),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(isSel ? Icons.radio_button_checked : Icons.radio_button_off, size: 20, color: isSel ? kRedReprosisa : Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _mobileActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: kRedReprosisa, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _stLabel(String t) => SizedBox(width: _colWidth, child: Center(child: Text(t, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))));
  Widget _statusBtnWrapper(ComponentItem item, String val, IconData icon, Color color) => SizedBox(width: _colWidth, child: Center(child: _statusBtn(item, val, icon, color)));

  Widget _statusBtn(ComponentItem item, String val, IconData icon, Color color) {
    bool isSelected = item.status == val;
    return GestureDetector(
      onTap: () => setState(() => item.status = val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _btnSize, height: _btnSize,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : kRedReprosisa, width: 2.5),
        ),
        child: Icon(icon, size: 24, color: isSelected ? Colors.white : kRedReprosisa),
      ),
    );
  }

  Widget _buildEvidenceDual(ComponentItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _mediaBox("ANTES", item.evidenceBefore, () => _showMediaOptions(item, true)),
        const SizedBox(width: 8),
        _mediaBox("DESPUÉS", item.evidenceAfter, () => _showMediaOptions(item, false)),
      ],
    );
  }

  Widget _mediaBox(String label, List<EvidenceFile> files, VoidCallback onTap) {
    bool hasData = files.isNotEmpty;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: kRedReprosisa)),
        const SizedBox(height: 4),
        GestureDetector(
          // SI TIENE IMAGEN: Ver en grande. SI NO: Abrir opciones para subir.
          onTap: hasData ? () => _showFullImage(files.first.bytes) : onTap,
          child: Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kRedReprosisa, width: 1.5),
            ),
            child: hasData 
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(files.first.bytes, fit: BoxFit.cover, width: 48, height: 48),
                    ),
                    // Iconito para borrar rápido si te equivocas
                    Positioned(
                      top: 0, right: 0,
                      child: GestureDetector(
                        onTap: () => setState(() => files.clear()),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              : const Icon(Icons.add_a_photo_rounded, size: 18, color: kRedReprosisa),
          ),
        ),
      ],
    );
  }

  void _showMediaOptions(ComponentItem item, bool isBefore) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const Text("AÑADIR EVIDENCIA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 24),
              _minimalOptionBtn(icon: Icons.camera_alt_rounded, label: "TOMAR FOTO", onTap: () { Navigator.pop(context); _pick(item, isBefore, ImageSource.camera); }),
              const SizedBox(height: 12),
              _minimalOptionBtn(icon: Icons.photo_library_rounded, label: "SELECCIONAR DE GALERÍA", onTap: () { Navigator.pop(context); _pick(item, isBefore, ImageSource.gallery); }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _minimalOptionBtn({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
        child: Row(
          children: [
            Icon(icon, color: kRedReprosisa, size: 24),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Future<void> _pick(ComponentItem item, bool isBefore, ImageSource source) async {
    final file = await _picker.pickMedia(imageQuality: 50);
    if (file != null) {
      final bytes = await file.readAsBytes();
      final isVid = file.path.toLowerCase().endsWith('.mp4');
      setState(() {
        final ev = EvidenceFile(bytes: bytes, type: isVid ? "video" : "image", mimeType: isVid ? "video/mp4" : "image/jpeg");
        if (isBefore) item.evidenceBefore = [ev]; else item.evidenceAfter = [ev];
      });
    }
  }
}

class _HeaderLabel extends StatelessWidget {
  final String label;
  const _HeaderLabel(this.label);
  @override
  Widget build(BuildContext context) => Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E), fontSize: 13));
}