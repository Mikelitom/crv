import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/component_item.dart';

class PrensaInspectionTable extends StatefulWidget {
  final List<ComponentItem> items;
  const PrensaInspectionTable({super.key, required this.items});

  @override
  State<PrensaInspectionTable> createState() => _PrensaInspectionTableState();
}

class _PrensaInspectionTableState extends State<PrensaInspectionTable> {
  final ImagePicker _picker = ImagePicker();
  late List<FocusNode> _qtyFocusNodes;
  late List<FocusNode> _obsFocusNodes;

  @override
  void initState() {
    super.initState();
    _qtyFocusNodes = List.generate(widget.items.length, (index) => FocusNode());
    _obsFocusNodes = List.generate(widget.items.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in _qtyFocusNodes) node.dispose();
    for (var node in _obsFocusNodes) node.dispose();
    super.dispose();
  }

  void _nextFocus(int index, bool isQty) {
    if (isQty) {
      _obsFocusNodes[index].requestFocus();
    } else if (index + 1 < widget.items.length) {
      _qtyFocusNodes[index + 1].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _showPickerOptions(ComponentItem item) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Color(0xFFC62828)),
              title: const Text('Cámara'),
              onTap: () { Navigator.pop(context); _pickImage(item, ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFC62828)),
              title: const Text('Galería'),
              onTap: () { Navigator.pop(context); _pickImage(item, ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ComponentItem item, ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(source: source, imageQuality: 40);
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() => item.evidences = [bytes]);
      }
    } catch (e) {
      debugPrint("Error cámara: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text("Lista de Verificación de Componentes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ),
              isMobile ? _buildMobileList() : _buildDesktopTable(constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(double maxWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: maxWidth),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.grey.shade100),
          child: DataTable(
            headingRowHeight: 60,
            dataRowMaxHeight: 85,
            headingRowColor: WidgetStateProperty.all(const Color(0xFFFBFBFC)),
            columns: const [
              DataColumn(label: _HeaderLabel('Cant.')),
              DataColumn(label: _HeaderLabel('Unidad')),
              DataColumn(label: _HeaderLabel('Descripción')),
              DataColumn(label: _HeaderLabel('Condición')),
              DataColumn(label: _HeaderLabel('Observaciones')),
              DataColumn(label: _HeaderLabel('Evidencia')),
            ],
            rows: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              return DataRow(cells: [
                DataCell(SizedBox(width: 45, child: _buildQtyInput(item, index))),
                DataCell(Text(item.measureUnit, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(SizedBox(width: 250, child: Text(item.name, style: const TextStyle(fontSize: 12)))),
                DataCell(_buildStatusButtons(item)),
                DataCell(SizedBox(width: 200, child: _buildObsInput(item, index))),
                DataCell(_buildEvidenceLogic(item)),
              ]);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade100))),
          child: Column(
            children: [
              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 60, child: _buildQtyInput(item, index)),
                  _buildStatusButtons(item),
                  _buildEvidenceLogic(item),
                ],
              ),
              _buildObsInput(item, index),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEvidenceLogic(ComponentItem item) {
    if (item.evidences.isNotEmpty) {
      return GestureDetector(
        onTap: () => showDialog(context: context, builder: (_) => Dialog(child: InteractiveViewer(child: Image.memory(item.evidences.first)))),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 55, height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC62828), width: 2),
                image: DecorationImage(image: MemoryImage(item.evidences.first), fit: BoxFit.cover),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => item.evidences.clear()),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
    return ElevatedButton(
      onPressed: () => _showPickerOptions(item),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC62828),
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
    );
  }

  Widget _buildQtyInput(ComponentItem item, int index) {
    return TextField(
      focusNode: _qtyFocusNodes[index],
      keyboardType: TextInputType.number,
      onSubmitted: (_) => _nextFocus(index, true),
      onChanged: (v) => item.quantity = int.tryParse(v),
      textAlign: TextAlign.center,
      decoration: const InputDecoration(hintText: "—", border: InputBorder.none),
    );
  }

  Widget _buildObsInput(ComponentItem item, int index) {
    return TextField(
      focusNode: _obsFocusNodes[index],
      onSubmitted: (_) => _nextFocus(index, false),
      onChanged: (v) => item.observaciones = v,
      decoration: const InputDecoration(hintText: "Notas...", border: InputBorder.none),
    );
  }

  Widget _buildStatusButtons(ComponentItem item) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _stIcon(item, 0, Icons.check_circle, Colors.green),
      _stIcon(item, 1, Icons.cancel, Colors.red),
      _stIcon(item, 2, Icons.remove_circle, Colors.grey),
    ]);
  }

  Widget _stIcon(ComponentItem item, int val, IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon, color: item.estado == val ? color : Colors.grey.shade200, size: 28),
      onPressed: () => setState(() => item.estado = val),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String label;
  const _HeaderLabel(this.label);
  @override
  Widget build(BuildContext context) { return Text(label, style: const TextStyle(fontWeight: FontWeight.w900)); }
}