import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/vehicle_inspection_provider.dart';
import '../../data/models/component_vehicle_model.dart';

const _kRedAccent = Color(0xFFC62828);
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return _buildMobileView();
      }
      return _buildDesktopTable();
    });
  }

  // ==========================================
  // VISTA MÓVIL: CORRECCIÓN DE OVERFLOW
  // ==========================================
  Widget _buildMobileView() {
    return Container(
      // Reducción de márgenes laterales para ganar espacio
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title.toUpperCase(), 
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: _kTextDark)),
                const Text("Marque según condición:", style: TextStyle(fontSize: 11, color: _kTextGrey)),
                const Text("BUENO | MALO | REPOSICIÓN | REPARACIÓN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _kRedAccent)),
              ],
            ),
          ),
          const Divider(height: 1),
          // Cabecera compacta con proporciones ajustadas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            color: _kBgSoft,
            child: const Row(
              children: [
                Expanded(flex: 28, child: Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                )),
                Expanded(flex: 11, child: Text("B", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                Expanded(flex: 11, child: Text("M", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                Expanded(flex: 11, child: Text("RE", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                Expanded(flex: 11, child: Text("RA", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                Expanded(flex: 28, child: Text("Acc.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
              ],
            ),
          ),
          ...widget.items.map((item) => _buildMobileRow(item)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMobileRow(ComponentVehicleModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _kBorder, width: 0.5))),
      child: Row(
        children: [
          // Texto que se ajusta automáticamente
          Expanded(
            flex: 28, 
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                item.description, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, height: 1.1)
              ),
            )
          ),
          _buildMobileSelectionDot(item, 'good'),
          _buildMobileSelectionDot(item, 'bad'),
          _buildMobileSelectionDot(item, 'reposition'),
          _buildMobileSelectionDot(item, 'reparation'),
          // Botones de acción pegados a la derecha
          Expanded(
            flex: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionIcon(Icons.chat_bubble_outline_rounded, () => _showNoteDialog(item), hasValue: item.observations.isNotEmpty),
                const SizedBox(width: 4),
                _actionIcon(Icons.camera_alt_outlined, () => _openMediaMenu(item, true), hasValue: item.evidenceBefore.isNotEmpty),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap, {bool hasValue = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: hasValue ? _kRedAccent.withOpacity(0.08) : Colors.white, 
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _kRedAccent, 
            width: hasValue ? 1.5 : 1.0
          ),
        ),
        child: Icon(
          icon, 
          color: _kRedAccent, 
          size: 13, // Icono ligeramente más pequeño
        ),
      ),
    );
  }

  Widget _buildMobileSelectionDot(ComponentVehicleModel item, String code) {
    final state = ref.watch(vehicleInspectionProvider);
    final option = state.templateOptions.firstWhere((opt) => opt['code'] == code, orElse: () => {'id': null});
    final bool isSelected = item.selectedOptionId == option['id'];
    return Expanded(
      flex: 11,
      child: GestureDetector(
        onTap: () => setState(() => item.selectedOptionId = option['id']),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            width: 16, height: 16, // Tamaño reducido para evitar desborde
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? _kRedAccent : Colors.grey.shade400, width: 1.2),
              color: isSelected ? _kRedAccent : Colors.transparent,
            ),
            child: isSelected ? const Icon(Icons.check, size: 9, color: Colors.white) : null,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // VISTA DESKTOP (MANTENIDA)
  // ==========================================
  Widget _buildDesktopTable() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            _buildPremiumHeader(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 40),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2.0), 1: FlexColumnWidth(0.5), 2: FlexColumnWidth(0.5),
                    3: FlexColumnWidth(0.5), 4: FlexColumnWidth(0.5), 5: FlexColumnWidth(1.3), 6: FlexColumnWidth(1.5),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [_buildFancyHeader(), ...widget.items.map((item) => _buildRow(item))],
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
          const Icon(Icons.analytics_rounded, color: _kTextGrey),
          const SizedBox(width: 16),
          Text(widget.title.toUpperCase(), style: const TextStyle(color: _kTextDark, fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: 2.5)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: _kRedAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Text("CHECKLIST", style: TextStyle(color: _kRedAccent, fontSize: 10, fontWeight: FontWeight.bold)),
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
        _headerCell('B'), _headerCell('M'), _headerCell('RO'), _headerCell('RA'),
        _headerCell('OBSERVACIONES'), _headerCell('EVID (A/D)'),
      ],
    );
  }

  Widget _headerCell(String label, {TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Text(label, textAlign: align, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _kTextDark)),
    );
  }

  TableRow _buildRow(ComponentVehicleModel item) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _kBorder, width: 0.8))),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(item.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ),
        _buildSelectionDot(item, 'good'),
        _buildSelectionDot(item, 'bad'),
        _buildSelectionDot(item, 'reposition'),
        _buildSelectionDot(item, 'reparation'),
        Padding(padding: const EdgeInsets.all(12), child: _buildInput(item)),
        _evidenceDual(item, 44),
      ],
    );
  }

  Widget _buildSelectionDot(ComponentVehicleModel item, String code) {
    final state = ref.watch(vehicleInspectionProvider);
    final option = state.templateOptions.firstWhere((opt) => opt['code'] == code, orElse: () => {'id': null});
    final bool isSelected = item.selectedOptionId == option['id'];
    return GestureDetector(
      onTap: () => setState(() => item.selectedOptionId = option['id']),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 22, height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? _kRedAccent : Colors.white,
            border: Border.all(color: isSelected ? _kRedAccent : Colors.grey.shade400, width: isSelected ? 7 : 2),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(ComponentVehicleModel item) {
    return TextField(
      onChanged: (v) => item.observations = v,
      decoration: InputDecoration(hintText: "Nota...", filled: true, fillColor: _kBgSoft, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }

  Widget _evidenceDual(ComponentVehicleModel item, double size) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _mediaBox(item.evidenceBefore, () => _openMediaMenu(item, true), () => setState(() => item.evidenceBefore = []), size),
      const SizedBox(width: 8),
      _mediaBox(item.evidenceAfter, () => _openMediaMenu(item, false), () => setState(() => item.evidenceAfter = []), size),
    ],
  );

  Widget _mediaBox(List<EvidenceFile> files, VoidCallback onAdd, VoidCallback onDelete, double size) {
    bool hasData = files.isNotEmpty;
    return GestureDetector(
      onTap: hasData ? () => _showFullImage(files.first.bytes) : onAdd,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: _kBgSoft, borderRadius: BorderRadius.circular(10), 
          border: Border.all(color: hasData ? _kRedAccent : _kBorder, width: 1.5)
        ),
        child: hasData
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(files.first.bytes, fit: BoxFit.cover, width: size, height: size)),
                  Positioned(top: -6, right: -6, child: GestureDetector(onTap: onDelete, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle), child: const Icon(Icons.close, size: 10, color: Colors.white)))),
                ],
              )
            : Center(child: Icon(Icons.camera_alt_outlined, color: Colors.grey.shade400, size: 18)),
      ),
    );
  }

  void _showNoteDialog(ComponentVehicleModel item) {
    final TextEditingController controller = TextEditingController(text: item.observations);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.description),
        content: TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: "Nota...", border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(onPressed: () { setState(() => item.observations = controller.text); Navigator.pop(context); }, child: const Text("Guardar")),
        ],
      ),
    );
  }

  void _openMediaMenu(ComponentVehicleModel item, bool isBefore) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            _evidenceDual(item, 80),
            const Divider(),
            ListTile(leading: const Icon(Icons.camera_alt, color: _kRedAccent), title: const Text("Cámara"), onTap: () => _handleImage(item, ImageSource.camera, isBefore)),
            ListTile(leading: const Icon(Icons.photo_library, color: _kRedAccent), title: const Text("Galería"), onTap: () => _handleImage(item, ImageSource.gallery, isBefore)),
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

  void _showFullImage(Uint8List bytes) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black,
      pageBuilder: (context, _, __) => InteractiveViewer(child: Image.memory(bytes)),
    );
  }
}