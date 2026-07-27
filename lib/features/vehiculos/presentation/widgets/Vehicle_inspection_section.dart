import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/vehicle_inspection_provider.dart';
import '../../data/models/component_vehicle_model.dart';

const Color _kRed = Color(0xFFC62828);
const Color _kBorder = Color.fromARGB(255, 209, 219, 231);
const Color _kSurface = Color(0xFFF1F5F9); 
const Color _kText = Color.fromARGB(255, 29, 29, 29);

class VehicleInspectionSection extends ConsumerStatefulWidget {
  final String title;
  final List<ComponentVehicleModel> items;

  const VehicleInspectionSection({
    super.key, 
    required this.title, 
    required this.items,
  });

  @override
  ConsumerState<VehicleInspectionSection> createState() => _VehicleInspectionSectionState();
}

class _VehicleInspectionSectionState extends ConsumerState<VehicleInspectionSection> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleImageSelection(ComponentVehicleModel item, bool isBefore) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: _kRed),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: _kRed),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final evidence = EvidenceFile(
          bytes: bytes,
          type: 'image',
          mimeType: 'image/jpeg',
          fileName: photo.name,
        );
        setState(() {
          if (isBefore) {
            item.evidenceBefore.add(evidence);
          } else {
            item.evidenceAfter.add(evidence);
          }
        });
      }
    } catch (e) {
      debugPrint("Error al abrir cámara/galería: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInstitutionalHeader(),
          if (isDesktop) _buildTableHead(),
          ...widget.items.map(
            (item) => isDesktop ? _buildDesktopRow(item) : _buildMobileList(item),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car_rounded, color: _kRed, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
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
          Expanded(
            flex: 3,
            child: Center(
              child: Text("COMPONENTE", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Text("ESTADO (B / M / RE / RA)", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Text("OBSERVACIONES", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text("EVID. (A/D)", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(ComponentVehicleModel item) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _kBorder.withValues(alpha: 0.5))),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _cell(
                Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
            Expanded(flex: 4, child: _cell(_buildCheckboxes(item))),
            Expanded(flex: 4, child: _cell(_buildObsInput(item))),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: _kBorder.withValues(alpha: 0.5))),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEvidenceList(item, true),
                    const Divider(height: 1, color: Color(0xFFD1DBE7)),
                    _buildEvidenceList(item, false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(ComponentVehicleModel item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.description,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: _kText),
          ),
          const SizedBox(height: 10),
          _buildCheckboxes(item),
          const SizedBox(height: 10),
          _buildInputMobile("Observaciones", _buildObsInput(item)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEvidenceList(item, true),
              const SizedBox(width: 30),
              _buildEvidenceList(item, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputMobile(String label, Widget input) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: input,
      ),
    ],
  );

  Widget _buildCheckboxes(ComponentVehicleModel item) {
    final state = ref.watch(vehicleInspectionProvider);
    
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: state.templateOptions.map((opt) {
        final bool isSelected = item.selectedOptionId == opt['id'];
        return InkWell(
          onTap: () => setState(() => item.selectedOptionId = opt['id']),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 16,
                  color: isSelected ? _kRed : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  opt['name'] ?? opt['code'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? _kRed : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEvidenceList(ComponentVehicleModel item, bool isBefore) {
    final files = isBefore ? item.evidenceBefore : item.evidenceAfter;
    return Column(
      children: [
        Text(
          isBefore ? "A" : "D",
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            ...files.asMap().entries.map(
              (e) => _buildMini(e.value, item, isBefore, e.key),
            ),
            GestureDetector(
              onTap: () => _handleImageSelection(item, isBefore),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _kBorder),
                ),
                child: const Icon(Icons.add_a_photo, size: 14, color: _kRed),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMini(EvidenceFile f, ComponentVehicleModel item, bool isBefore, int idx) {
    return GestureDetector(
      onTap: () => _viewImage(f.bytes),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: MemoryImage(f.bytes),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: -4,
            top: -4,
            child: GestureDetector(
              onTap: () => setState(() {
                if (isBefore) {
                  item.evidenceBefore.removeAt(idx);
                } else {
                  item.evidenceAfter.removeAt(idx);
                }
              }),
              child: const CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, size: 10, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(Widget child) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border(right: BorderSide(color: _kBorder.withValues(alpha: 0.5))),
    ),
    alignment: Alignment.center,
    child: child,
  );

  Widget _buildObsInput(ComponentVehicleModel item) => TextFormField(
    key: ValueKey('obs_${item.id}'),
    initialValue: item.observations,
    maxLines: 2,
    style: const TextStyle(fontSize: 11),
    onChanged: (v) => item.observations = v,
    decoration: const InputDecoration(
      hintText: "Escribe una observación...",
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(8),
    ),
  );

  void _viewImage(Uint8List bytes) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(bytes),
          ),
        ),
      ),
    );
  }
}