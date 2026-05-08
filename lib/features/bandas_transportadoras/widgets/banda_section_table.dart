import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/entities/banda_template.dart';
import '../presentation/provider/banda_inspection_providers.dart';

class BandaSectionTable extends ConsumerStatefulWidget {
  final String sectionId;
  final String sectionTitle;
  final int sectionNumber;
  final List<BandaComponent> items;

  const BandaSectionTable({
    super.key,
    required this.sectionId,
    required this.sectionTitle,
    required this.sectionNumber,
    required this.items,
  });

  @override
  ConsumerState<BandaSectionTable> createState() => _BandaSectionTableState();
}

class _BandaSectionTableState extends ConsumerState<BandaSectionTable> {
  final ImagePicker _picker = ImagePicker();
  final Color _kRed = const Color(0xFFB71C1C);
  final Color _kLabelBg = const Color(0xFFF1F5F9);
  final Color _kBorder = const Color(0xFFCCCCCC);

  Future<void> _captureImage(BandaComponent item, bool isBefore) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      final evidence = EvidenceFile(bytes: bytes, type: 'image', mimeType: 'image/jpeg');
      ref.read(bandaInspectionProvider.notifier).addEvidence(widget.sectionId, item.id, evidence, isBefore);
    }
  }

  void _viewImage(Uint8List bytes) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            InteractiveViewer(child: Image.memory(bytes)),
            Positioned(top: 10, right: 10, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    return Column(
      children: [
        _buildInstitutionalHeader(),
        const SizedBox(height: 12),
        isMobile ? _buildMobileStack() : _buildDesktopTable(),
      ],
    );
  }

  Widget _buildInstitutionalHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _kBorder)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _kRed, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sección ${widget.sectionNumber}: ${widget.sectionTitle}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text("${widget.items.length} componentes a evaluar", style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStack() {
    return Column(
      children: widget.items.map((item) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(border: Border.all(color: _kBorder), borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: _cellBox(label: "DIMENSIÓN", child: _buildDimInput(item))),
                  Expanded(flex: 2, child: _cellBox(label: "ACCESORIO", child: Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)))),
                ],
              ),
            ),
            _cellBox(label: "OBSERVACIONES", child: _buildRadios(item)),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(flex: 2, child: _cellBox(label: "ACCIONES Y\nRECOMENDACIONES", child: _buildObsInput(item))),
                  Expanded(child: _cellBox(label: "EVIDENCIA\nFOTOGRÁFICA", child: _buildMobileEvidButtons(item))),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _cellBox({required String label, required Widget child}) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: _kBorder, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: _kLabelBg,
            child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900)),
          ),
          Padding(padding: const EdgeInsets.all(8), child: Center(child: child)),
        ],
      ),
    );
  }

  Widget _buildRadios(BandaComponent item) {
    return Wrap(
      children: item.options.map((opt) => SizedBox(
        width: 140,
        child: RadioListTile<String>(
          title: Text(opt.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          value: opt.id, groupValue: item.selectedOptionId, activeColor: _kRed,
          onChanged: (v) => ref.read(bandaInspectionProvider.notifier).updateComponentOption(widget.sectionId, item.id, v!),
          dense: true, contentPadding: EdgeInsets.zero,
        ),
      )).toList(),
    );
  }

  Widget _buildDimInput(BandaComponent item) {
    return TextField(
      textAlign: TextAlign.center,
      onChanged: (v) => ref.read(bandaInspectionProvider.notifier).updateComponentDimension(widget.sectionId, item.id, v),
      decoration: const InputDecoration(hintText: "0", border: InputBorder.none, isDense: true),
    );
  }

  Widget _buildObsInput(BandaComponent item) {
    return TextField(
      maxLines: null, style: const TextStyle(fontSize: 11),
      onChanged: (v) => ref.read(bandaInspectionProvider.notifier).updateComponentObservation(widget.sectionId, item.id, v),
      decoration: const InputDecoration(hintText: "Nota...", border: InputBorder.none, isDense: true),
    );
  }

  Widget _buildMobileEvidButtons(BandaComponent item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _camBtn(item.evidenceBefore, () => _captureImage(item, true)),
        const SizedBox(width: 5),
        _camBtn(item.evidenceAfter, () => _captureImage(item, false)),
      ],
    );
  }

  Widget _camBtn(List<EvidenceFile> files, VoidCallback onTap) {
    bool hasData = files.isNotEmpty;
    return GestureDetector(
      onTap: hasData ? () => _viewImage(files.first.bytes) : onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: hasData ? _kRed : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _kRed, width: 1.5),
        ),
        child: Icon(Icons.camera_alt_outlined, size: 20, color: hasData ? Colors.white : _kRed),
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _kBorder), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildTableHead(),
          ...widget.items.map((item) => _buildDesktopRow(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHead() {
    return Container(
      color: _kLabelBg, padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: const [
          Expanded(flex: 4, child: Center(child: Text("ACCESORIO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 5, child: Center(child: Text("OBSERVACIONES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 1, child: Center(child: Text("DIM.", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 5, child: Center(child: Text("RECOMENDACIONES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 2, child: Center(child: Text("EVID.", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(BandaComponent item) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _kBorder.withOpacity(0.5)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 4, child: _cell(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
            Expanded(flex: 5, child: _cell(child: _buildRadios(item))),
            Expanded(flex: 1, child: _cell(child: _buildDimInput(item))),
            Expanded(flex: 5, child: _cell(child: _buildObsInput(item))),
            Expanded(flex: 2, child: _buildMobileEvidButtons(item)),
          ],
        ),
      ),
    );
  }

  Widget _cell({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border(right: BorderSide(color: _kBorder.withOpacity(0.5)))),
      alignment: Alignment.center, child: child,
    );
  }
}