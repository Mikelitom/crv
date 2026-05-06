import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/vehicle_inspection_provider.dart';
import '../../data/models/component_vehicle_model.dart';

// Definición de colores ajustada
const _kRedAccent = Color(0xFFE53935);
const _kRedDeep = Color(0xFFB71C1C);
const _kRedSoft = Color(0xFFFFF1F0);
const _kHeaderBg = Color(0xFFFFFDFD); 
const _kBgSoft = Color(0xFFFBFBFD);
const _kBorder = Color(0xFFEAECEF);
const _kTextDark = Color(0xFF1A1C1E); // Negro más sólido y legible
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
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
                    0: FlexColumnWidth(2.0), // Componente
                    1: FlexColumnWidth(1.0), // Bueno
                    2: FlexColumnWidth(1.0), // Malo
                    3: FlexColumnWidth(1.0), // Reposición
                    4: FlexColumnWidth(1.0), // Reparación
                    5: FlexColumnWidth(1.3), // Notas
                    6: FlexColumnWidth(1.5), // Evidencia
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
      decoration: BoxDecoration(
        color: _kHeaderBg,
        border: const Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          const Icon(Icons.analytics_rounded, color: _kTextGrey, size: 24),
          const SizedBox(width: 16),
          Text(
            widget.title.toUpperCase(),
            style: const TextStyle(
              color: _kTextDark,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              letterSpacing: 2.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _kRedAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
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
        _headerCell('BUENO'),
        _headerCell('MALO'),
        _headerCell('REPO.'),
        _headerCell('REPA.'),
        _headerCell('OBSERVACIONES'),
        _headerCell('EVID.'),
      ],
    );
  }

  Widget _headerCell(String label, {TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 28, right: 12),
      child: Text(
        label,
        textAlign: align,
        style: const TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.w900, 
          color: _kTextDark, // Letra negra para las cabeceras
          letterSpacing: 0.9
        ),
      ),
    );
  }

  TableRow _buildRow(ComponentVehicleModel item) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder, width: 0.8)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28, right: 12),
          child: Text(
            item.description,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kTextDark),
          ),
        ),
        _buildSelectionDot(item, 'good'),
        _buildSelectionDot(item, 'bad'),
        _buildSelectionDot(item, 'reposition'),
        _buildSelectionDot(item, 'reparation'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: _buildInput(item),
        ),
        _buildCameraBtn(item),
      ],
    );
  }

  Widget _buildSelectionDot(ComponentVehicleModel item, String code) {
    final state = ref.watch(vehicleInspectionProvider);
    final option = state.templateOptions.firstWhere((opt) => opt['code'] == code, orElse: () => {'id': null});
    final bool isSelected = item.selectedOptionId == option['id'];

    return GestureDetector(
      onTap: () => setState(() => item.selectedOptionId = option['id']),
      child: Container(
        height: 65,
        color: Colors.transparent, 
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 24 : 22,
            height: isSelected ? 24 : 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? _kRedAccent : Colors.white,
              border: Border.all(
                // Borde más marcado para que no se pierda el círculo
                color: isSelected ? _kRedAccent : Colors.grey.shade400, 
                width: isSelected ? 7 : 2.5,
              ),
              boxShadow: isSelected 
                ? [BoxShadow(color: _kRedAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] 
                : [],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(ComponentVehicleModel item) {
    return TextField(
      onChanged: (v) => item.observations = v,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _kTextDark),
      decoration: InputDecoration(
        hintText: "Nota...",
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        filled: true,
        fillColor: _kBgSoft,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kRedAccent, width: 1)),
      ),
    );
  }

  Widget _buildCameraBtn(ComponentVehicleModel item) {
    return Center(
      child: IconButton(
        onPressed: () => _openMediaMenu(item),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kRedAccent, width: 1.5), // Borde rojo
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
            ],
          ),
          child: const Icon(Icons.add_a_photo_rounded, color: _kRedAccent, size: 18), // Icono rojo
        ),
      ),
    );
  }

  void _openMediaMenu(ComponentVehicleModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: _kBorder, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 30),
            const Text("ADJUNTAR EVIDENCIA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.2, color: _kTextDark)),
            const SizedBox(height: 30),
            _menuTile(Icons.camera_rounded, "Cámara en vivo", _kRedAccent, () async {
              Navigator.pop(context);
              final XFile? file = await _picker.pickImage(source: ImageSource.camera);
              if (file != null) { /* Tu lógica de guardado */ }
            }),
            const SizedBox(height: 15),
            _menuTile(Icons.image_search_rounded, "Galería de imágenes", Colors.blueGrey, () async {
              Navigator.pop(context);
              final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
              if (file != null) { /* Tu lógica de guardado */ }
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: _kBgSoft,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 20),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _kTextDark)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}