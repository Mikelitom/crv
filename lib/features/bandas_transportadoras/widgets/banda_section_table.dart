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
  final Color _kBorder = const Color(0xFFE2E8F0);

  // --- LÓGICA DE IMAGEN ---
  Future<void> _handleImageSelection(BandaComponent item, bool isBefore) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? photo = await _picker.pickImage(source: source, imageQuality: 50);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      final evidence = EvidenceFile(bytes: bytes, type: 'image', mimeType: 'image/jpeg');
      ref.read(bandaInspectionProvider.notifier).addEvidence(widget.sectionId, item.id, evidence, isBefore);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    return Column(
      children: [
        _buildInstitutionalHeader(), // El header con el botón dentro
        const SizedBox(height: 16),
        isMobile ? _buildMobileList() : _buildDesktopTable(),
      ],
    );
  }

  // --- HEADER CON BOTÓN DE VOLVER INTEGRADO ---
  Widget _buildInstitutionalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
      ),
      child: Row(
        children: [
          // Icono decorativo de sección
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _kRed.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.settings_suggest_rounded, color: _kRed, size: 24),
          ),
          const SizedBox(width: 16),
          // Título de la sección
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SECCIÓN ${widget.sectionNumber}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                ),
                Text(
                  widget.sectionTitle.toUpperCase(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          ),
          // BOTÓN DE VOLVER INTEGRADO (TIPO AL DE LA IMAGEN)
          _buildBackActionBtn(),
        ],
      ),
    );
  }

  Widget _buildBackActionBtn() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _kRed,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: _kRed.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
      ),
    );
  }

  // --- DISEÑO DE EVIDENCIAS (MINIATURA + ELIMINAR) ---
  Widget _buildEvidenceThumbnail(BandaComponent item, bool isBefore) {
    final files = isBefore ? item.evidenceBefore : item.evidenceAfter;
    final bool hasData = files.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => hasData ? _viewImage(files.first.bytes) : _handleImageSelection(item, isBefore),
          child: Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: hasData ? _kRed : Colors.grey.shade300, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: hasData 
                ? Image.memory(files.first.bytes, fit: BoxFit.cover)
                : Icon(Icons.camera_alt_outlined, size: 20, color: Colors.grey.shade400),
            ),
          ),
        ),
        if (hasData)
          Positioned(
            top: -6, right: -6,
            child: GestureDetector(
              onTap: () => ref.read(bandaInspectionProvider.notifier).removeEvidence(widget.sectionId, item.id, isBefore),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: _kRed,
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  // --- TABLA DESKTOP ---
  Widget _buildDesktopTable() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _kBorder), borderRadius: BorderRadius.circular(16)),
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
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: const [
          Expanded(flex: 4, child: Center(child: Text("ACCESORIO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 5, child: Center(child: Text("OBSERVACIONES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 1, child: Center(child: Text("DIM.", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 5, child: Center(child: Text("RECOMENDACIONES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
          Expanded(flex: 2, child: Center(child: Text("EVID. (A/D)", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(BandaComponent item) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: _kBorder.withOpacity(0.5)))),
        child: Row(
          children: [
            Expanded(flex: 4, child: _cell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(flex: 5, child: _cell(_buildRadios(item))),
            Expanded(flex: 1, child: _cell(_buildDimInput(item))),
            Expanded(flex: 5, child: _cell(_buildObsInput(item))),
            Expanded(flex: 2, child: _cell(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEvidenceThumbnail(item, true),
                const SizedBox(width: 8),
                _buildEvidenceThumbnail(item, false),
              ],
            ))),
          ],
        ),
      ),
    );
  }

  // --- MÓVIL ---
  Widget _buildMobileList() {
    return Column(
      children: widget.items.map((item) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _kBorder), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFF8F9FA),
              width: double.infinity,
              child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.center),
            ),
            _buildRadios(item),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: _buildDimInput(item)),
                  const SizedBox(width: 16),
                  _buildEvidenceThumbnail(item, true),
                  const SizedBox(width: 8),
                  _buildEvidenceThumbnail(item, false),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildObsInput(item),
            ),
          ],
        ),
      )).toList(),
    );
  }

  // --- AUXILIARES ---
  Widget _cell(Widget child) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(border: Border(right: BorderSide(color: _kBorder.withOpacity(0.5)))),
    alignment: Alignment.center, child: child,
  );

  Widget _buildRadios(BandaComponent item) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: item.options.map((opt) => SizedBox(
        width: 130,
        child: RadioListTile<String>(
          title: Text(opt.label, style: const TextStyle(fontSize: 11)),
          value: opt.id, groupValue: item.selectedOptionId, activeColor: _kRed,
          onChanged: (v) => ref.read(bandaInspectionProvider.notifier).updateComponentOption(widget.sectionId, item.id, v!),
          dense: true, contentPadding: EdgeInsets.zero,
        ),
      )).toList(),
    );
  }

  Widget _buildDimInput(BandaComponent item) => TextField(
    textAlign: TextAlign.center,
    keyboardType: TextInputType.number,
    onChanged: (v) => ref.read(bandaInspectionProvider.notifier).updateComponentDimension(widget.sectionId, item.id, v),
    decoration: InputDecoration(hintText: "Dim.", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
  );

  Widget _buildObsInput(BandaComponent item) => TextField(
    maxLines: 2,
    onChanged: (v) => ref.read(bandaInspectionProvider.notifier).updateComponentObservation(widget.sectionId, item.id, v),
    decoration: InputDecoration(hintText: "Nota...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
  );

  void _viewImage(Uint8List bytes) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            InteractiveViewer(child: Center(child: Image.memory(bytes))),
            Positioned(top: 10, right: 10, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
          ],
        ),
      ),
    );
  }
}