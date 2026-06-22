import 'dart:typed_data';
import 'dart:io';
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
  final Color _kBorder = const Color.fromARGB(255, 209, 219, 231);

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

  if (source == null) return; // Si el usuario cancela, no hacemos nada

  try {
    final XFile? photo = await _picker.pickImage(source: source, imageQuality: 50);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      final evidence = EvidenceFile(bytes: bytes, type: 'image', mimeType: 'image/jpeg');
      ref.read(bandaInspectionProvider.notifier).addEvidence(widget.sectionId, item.id, evidence, isBefore);
    }
  } catch (e) {
    debugPrint("Error al abrir cámara/galería: $e");
    // Opcional: mostrar un SnackBar aquí informando que no se pudo acceder
  }
}
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInstitutionalHeader(),
          _buildTableHead(),
          ...widget.items
              .map(
                (item) => MediaQuery.of(context).size.width > 800
                    ? _buildDesktopRow(item)
                    : _buildMobileList(item),
              )
              .toList(),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.settings_suggest_rounded, color: _kRed, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SECCIÓN ${widget.sectionNumber}",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  widget.sectionTitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
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
          boxShadow: [
            BoxShadow(
              color: _kRed.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
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
              child: Text(
                "ACCESORIO",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                "OBSERVACIONES",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "DIMENSIONES",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                "ACCIONES Y RECOMENDACIONES",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "EVID. (A/D)",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(BandaComponent item) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _kBorder.withOpacity(0.5))),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _cell(
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(flex: 4, child: _cell(_buildCheckboxes(item))),
            Expanded(flex: 2, child: _cell(_buildDimInput(item))),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _buildObsInput(item),
              ),
            ),
          Expanded(
              flex: 3,
              child: Container(
                // Añadimos el borde a la izquierda de la columna de evidencias
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: _kBorder.withOpacity(0.5))),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEvidenceList(item, true),
                    const Divider(height: 1, color: Color(0xFFD1DBE7)), // Línea divisoria horizontal
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
Future<void> _showImageSourceOptions(BandaComponent item, bool isBefore) async {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: Wrap(children: [
        ListTile(leading: const Icon(Icons.camera_alt), title: const Text("Tomar foto"), onTap: () { Navigator.pop(ctx); _pick(item, isBefore, ImageSource.camera); }),
        ListTile(leading: const Icon(Icons.photo_library), title: const Text("Seleccionar de galería"), onTap: () { Navigator.pop(ctx); _pick(item, isBefore, ImageSource.gallery); }),
      ]),
    ),
  );
}

Future<void> _pick(BandaComponent item, bool isBefore, ImageSource source) async {
  final XFile? photo = await _picker.pickImage(source: source, imageQuality: 50);
  if (photo != null) {
    final bytes = await photo.readAsBytes();
    ref.read(bandaInspectionProvider.notifier).addEvidence(widget.sectionId, item.id, EvidenceFile(bytes: bytes, type: 'image', mimeType: 'image/jpeg'), isBefore);
  }
}
  Widget _buildMobileList(BandaComponent item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          _buildCheckboxes(item),
          _buildDimInput(item),
          _buildObsInput(item),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEvidenceList(item, true),
              const SizedBox(width: 16),
              _buildEvidenceList(item, false),
            ],
          ),
        ],
      ),
    );
  }
Widget _buildCheckboxes(BandaComponent item) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    // 1. Catálogo Fijo
    ...item.options.map((opt) {
      final isSelected = item.selectedOptionIds.contains(opt.id);
      return InkWell(
        onTap: () => ref.read(bandaInspectionProvider.notifier).toggleComponentOption(widget.sectionId, item.id, opt.id),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
          Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: isSelected ? _kRed : Colors.grey),
          const SizedBox(width: 8),
          Text(opt.label, style: TextStyle(fontSize: 11, color: isSelected ? _kRed : Colors.black87)),
        ])),
      );
    }),
    
    // 2. Custom Options (Diseño Rojo Especial)
    ...item.customOptions.map((label) {
      final isSelected = item.selectedOptionIds.contains(label);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(
            child: InkWell(
              onTap: () => ref.read(bandaInspectionProvider.notifier).toggleComponentOption(widget.sectionId, item.id, label),
              child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? _kRed : Colors.grey.shade600)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 12, color: Colors.red),
            onPressed: () => ref.read(bandaInspectionProvider.notifier).removeCustomOption(widget.sectionId, item.id, label),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          )
        ]),
      );
    }),
    
    TextButton.icon(icon: const Icon(Icons.add, size: 14), label: const Text("Otra"), onPressed: () => _showAddOptionDialog(item)),
  ]);
}
  void _showAddOptionDialog(BandaComponent item) {
    final controller = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(title: const Text("Nueva opción"), content: TextField(controller: controller), actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
      ElevatedButton(onPressed: () { if(controller.text.isNotEmpty) ref.read(bandaInspectionProvider.notifier).addCustomOption(widget.sectionId, item.id, controller.text); Navigator.pop(context); }, child: const Text("Guardar"))
    ]));
  }

  

Widget _buildEvidenceList(BandaComponent item, bool isBefore) {
    final files = isBefore ? item.evidenceBefore : item.evidenceAfter;
    return Column(children: [
        Text(isBefore ? "A" : "D", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
        Wrap(spacing: 4, runSpacing: 4, children: [
          ...files.asMap().entries.map((e) => _buildMini(e.value, item, isBefore, e.key)),
          GestureDetector(onTap: () => _handleImageSelection(item, isBefore), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.add_a_photo, size: 14, color: Colors.grey)))
        ])
    ]);
  }

Widget _buildMini(EvidenceFile f, BandaComponent item, bool isBefore, int idx) {
    return GestureDetector(
      onTap: () => _viewImage(f.bytes), // 1. Un toque abre la imagen en grande
      child: Stack(
        clipBehavior: Clip.none, // IMPORTANTE: Permite que la X se vea fuera del borde
        children: [
          // La miniatura de la foto
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(image: MemoryImage(f.bytes), fit: BoxFit.cover),
            ),
          ),
          // 2. El botón de borrar es un componente independiente
          Positioned(
            right: -4, top: -4,
            child: GestureDetector(
              onTap: () => ref.read(bandaInspectionProvider.notifier).removeEvidence(widget.sectionId, item.id, isBefore, idx),
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
      border: Border(right: BorderSide(color: _kBorder.withOpacity(0.5))),
    ),
    alignment: Alignment.center,
    child: child,
  );

  Widget _buildDimInput(BandaComponent item) => TextFormField(
    key: ValueKey('dim_${item.id}'),
    initialValue: item.dimentions == '0' ? '' : item.dimentions,
    textAlign: TextAlign.center,
    onChanged: (v) => ref
        .read(bandaInspectionProvider.notifier)
        .updateComponentDimension(widget.sectionId, item.id, v),
    decoration: const InputDecoration(
      hintText: "Dim.",
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(8),
    ),
  );

  Widget _buildObsInput(BandaComponent item) => TextFormField(
    key: ValueKey('obs_${item.id}'),
    initialValue: item.observation,
    maxLines: 2,
    onChanged: (v) => ref
        .read(bandaInspectionProvider.notifier)
        .updateComponentObservation(widget.sectionId, item.id, v),
    decoration: const InputDecoration(
      hintText: "...",
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(8),
    ),
  );

  void _viewImage(Uint8List bytes) {
    showDialog(
      context: context,
      builder: (_) =>
          Dialog(child: InteractiveViewer(child: Image.memory(bytes))),
    );
  }
}
