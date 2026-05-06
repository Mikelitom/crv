import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/vehicle_inspection_provider.dart';
import '../../data/models/component_vehicle_model.dart';

const _kRedAccent = Color(0xFFE53935);
const _kRedDeep = Color(0xFFB71C1C);
const _kHeaderBg = Color(0xFFFFFDFD); 
const _kBgSoft = Color(0xFFFBFBFD);
const _kBorder = Color(0xFFEAECEF);
const _kTextDark = Color(0xFF1A1C1E);
const _kTextGrey = Color(0xFF5F6368); 

class VehicleInspectionSection extends ConsumerStatefulWidget {
  final String title;
  final List<ComponentVehicleModel> items;

  const VehicleInspectionSection({super.key, required this.title, required this.items});

  @override
  ConsumerState<VehicleInspectionSection> createState() => _VehicleInspectionSectionState();
}

class _VehicleInspectionSectionState extends ConsumerState<VehicleInspectionSection> {
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 15))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumHeader(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 40),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2.0),
                    1: FlexColumnWidth(1.0),
                    2: FlexColumnWidth(1.0),
                    3: FlexColumnWidth(1.0),
                    4: FlexColumnWidth(1.0),
                    5: FlexColumnWidth(1.3),
                    6: FlexColumnWidth(1.5),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _buildFancyHeader(),
                    ...widget.items.map((item) => _buildRow(item)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(color: _kHeaderBg, border: Border(bottom: BorderSide(color: _kBorder))),
      child: Row(
        children: [
          const Icon(Icons.analytics_rounded, color: _kTextGrey, size: 24),
          const SizedBox(width: 16),
          Text(widget.title.toUpperCase(), style: const TextStyle(color: _kTextDark, fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: 2.5)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: _kRedAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Text("CHECKLIST", style: TextStyle(color: _kRedDeep, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  TableRow _buildFancyHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: _kBgSoft),
      children: [
        _headerCell('COMPONENTE', align: TextAlign.start),
        _headerCell('BUENO'), _headerCell('MALO'), _headerCell('REPO.'), _headerCell('REPA.'),
        _headerCell('OBSERVACIONES'), _headerCell('EVID (A/D)'),
      ],
    );
  }

  Widget _headerCell(String label, {TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 28, right: 12),
      child: Text(label, textAlign: align, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _kTextDark, letterSpacing: 0.9)),
    );
  }

  TableRow _buildRow(ComponentVehicleModel item) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _kBorder, width: 0.8))),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28, right: 12),
          child: Text(item.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kTextDark)),
        ),
        _buildSelectionDot(item, 'good'),
        _buildSelectionDot(item, 'bad'),
        _buildSelectionDot(item, 'reposition'),
        _buildSelectionDot(item, 'reparation'),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), child: _buildInput(item)),
        _evidenceDual(item, 44),
      ],
    );
  }

  Widget _evidenceDual(ComponentVehicleModel item, double size) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _mediaBox("A", item.evidenceBefore, () => _openMediaMenu(item, true), () => setState(() => item.evidenceBefore = []), size),
      const SizedBox(width: 8),
      _mediaBox("D", item.evidenceAfter, () => _openMediaMenu(item, false), () => setState(() => item.evidenceAfter = []), size),
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
          border: Border.all(color: hasData ? _kRedAccent : _kBorder, width: 1.5)
        ),
        child: hasData
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(files.first.bytes, fit: BoxFit.cover, width: size, height: size)),
                  Positioned(top: -6, right: -6, child: GestureDetector(onTap: onDelete, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle), child: const Icon(Icons.close, size: 10, color: Colors.white)))),
                ],
              )
            : Center(child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _kRedAccent))),
      ),
    );
  }

  Widget _buildSelectionDot(ComponentVehicleModel item, String code) {
    final state = ref.watch(vehicleInspectionProvider);
    final option = state.templateOptions.firstWhere((opt) => opt['code'] == code, orElse: () => {'id': null});
    final bool isSelected = item.selectedOptionId == option['id'];

    return GestureDetector(
      onTap: () => setState(() => item.selectedOptionId = option['id']),
      child: Container(height: 65, color: Colors.transparent, child: Center(child: AnimatedContainer(duration: const Duration(milliseconds: 300), width: isSelected ? 24 : 22, height: isSelected ? 24 : 22, decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? _kRedAccent : Colors.white, border: Border.all(color: isSelected ? _kRedAccent : Colors.grey.shade400, width: isSelected ? 7 : 2.5), boxShadow: isSelected ? [BoxShadow(color: _kRedAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : [])))),
    );
  }

  Widget _buildInput(ComponentVehicleModel item) {
    return TextField(
      onChanged: (v) => item.observations = v,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _kTextDark),
      decoration: InputDecoration(hintText: "Nota...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 11), filled: true, fillColor: _kBgSoft, isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kRedAccent, width: 1))),
    );
  }

  void _openMediaMenu(ComponentVehicleModel item, bool isBefore) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: _kBorder, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 30),
            Text("EVIDENCIA ${isBefore ? 'ANTES' : 'DESPUÉS'}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: _kTextDark)),
            const SizedBox(height: 30),
            _menuTile(Icons.camera_rounded, "Cámara", _kRedAccent, () => _handleImage(item, ImageSource.camera, isBefore)),
            const SizedBox(height: 15),
            _menuTile(Icons.image_search_rounded, "Galería", Colors.blueGrey, () => _handleImage(item, ImageSource.gallery, isBefore)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImage(ComponentVehicleModel item, ImageSource src, bool isBefore) async {
    Navigator.pop(context);
    final file = await _picker.pickImage(source: src, imageQuality: 50);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        final ev = EvidenceFile(bytes: bytes, type: "image", mimeType: "image/jpeg");
        if (isBefore) item.evidenceBefore = [ev]; else item.evidenceAfter = [ev];
      });
    }
  }

  Widget _menuTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Container(padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24), decoration: BoxDecoration(color: _kBgSoft, borderRadius: BorderRadius.circular(20), border: Border.all(color: _kBorder)), child: Row(children: [Icon(icon, color: color), const SizedBox(width: 20), Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _kTextDark)), const Spacer(), const Icon(Icons.chevron_right_rounded, color: Colors.black26)])));
  }
}