import 'package:flutter/material.dart';
import '../model/banda_inspection_model.dart';

class BandaSectionTable extends StatefulWidget {
  final String sectionTitle;
  final int sectionNumber;
  final List<BandaComponentItem> items;

  const BandaSectionTable({
    super.key,
    required this.sectionTitle,
    required this.sectionNumber,
    required this.items,
  });

  @override
  State<BandaSectionTable> createState() => _BandaSectionTableState();
}

class _BandaSectionTableState extends State<BandaSectionTable> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;

      // Animación de entrada premium
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        ),
        child: _buildAdaptiveContent(width),
      );
    });
  }

  Widget _buildAdaptiveContent(double width) {
    // Breakpoints: Móvil (<650), Tablet (650-1050), Laptop (>1050)
    if (width < 650) {
      return _buildMobileLayout();
    }
    // Para Tablet y Laptop usamos la misma base pero con anchos flexibles
    return _buildExpandedTableLayout(width);
  }

  // --- DISEÑO TABLET / LAPTOP (TOTALMENTE FLEXIBLE) ---
  Widget _buildExpandedTableLayout(double width) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: _premiumDecoration(),
      child: Column(
        children: [
          _buildHeader(),
          // Encabezado de la tabla
          Container(
            color: const Color(0xFFF1F4F9),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: const [
                Expanded(flex: 2, child: _TableHeader("ACCESORIOS")),
                Expanded(flex: 3, child: _TableHeader("OBSERVACIONES")),
                Expanded(flex: 1, child: _TableHeader("DIMEN.")),
                Expanded(flex: 4, child: _TableHeader("ACCIONES Y RECOMENDACIONES")),
                SizedBox(width: 80, child: _TableHeader("EVID.")),
              ],
            ),
          ),
          // Filas de datos
          ...widget.items.map((item) => Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: Text(item.accessory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                Expanded(flex: 3, child: _buildRadios(item)),
                Expanded(flex: 1, child: _buildSmallInput()),
                Expanded(flex: 4, child: _buildLargeInput()),
                SizedBox(
                  width: 80,
                  child: Center(child: _CircleActionBtn(icon: Icons.camera_alt, onTap: () {})),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  // --- DISEÑO MÓVIL: TARJETAS ENTRELAZADAS ---
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader(),
        ...widget.items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: _premiumDecoration(),
          child: Column(
            children: [
              Row(
                children: [
                  _gridBlock("DIMENSIÓN", "0", flex: 1, isInput: true),
                  _gridBlock("ACCESORIO", item.accessory, flex: 2, isBold: true),
                ],
              ),
              _mobileLabel("OBSERVACIONES"),
              Padding(padding: const EdgeInsets.all(15), child: _buildRadios(item)),
              _mobileLabel("ACCIONES Y RECOMENDACIONES"),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Escribir...",
                    filled: true, fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              _fullWidthPhotoBtn(),
            ],
          ),
        )).toList(),
      ],
    );
  }

  // --- COMPONENTES ATÓMICOS ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Color(0xFFFBFBFB), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFC62828), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.settings, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SECCIÓN ${widget.sectionNumber}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
              Text(widget.sectionTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1C1E))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadios(BandaComponentItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.observationOptions.map((opt) => RadioListTile<String>(
        title: Text(opt, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        value: opt,
        groupValue: item.selectedObservation,
        activeColor: const Color(0xFFC62828),
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: (v) => setState(() => item.selectedObservation = v),
      )).toList(),
    );
  }

  Widget _buildSmallInput() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: "0", filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none))),
  );

  Widget _buildLargeInput() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextField(maxLines: 2, decoration: InputDecoration(hintText: "Escribir recomendaciones...", filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none))),
  );

  BoxDecoration _premiumDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))],
  );

  Widget _gridBlock(String label, String value, {int flex = 1, bool isBold = false, bool isInput = false}) => Expanded(
    flex: flex,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100)),
      child: Column(children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 6),
        isInput ? const SizedBox(height: 20, child: TextField(textAlign: TextAlign.center, decoration: InputDecoration(border: InputBorder.none, hintText: "0"))) : Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
      ]),
    ),
  );

  Widget _mobileLabel(String text) => Container(width: double.infinity, padding: const EdgeInsets.all(8), color: Colors.grey.shade50, child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)));

  Widget _fullWidthPhotoBtn() => Container(
    width: double.infinity, padding: const EdgeInsets.all(12),
    child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.camera_alt), label: const Text("SUBIR FOTO"), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
  );
}

// --- CELDAS AUXILIARES ---
class _TableHeader extends StatelessWidget {
  final String label;
  const _TableHeader(this.label);
  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF444444))),
  );
}

class _CircleActionBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _CircleActionBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: const Color(0xFFC62828).withOpacity(0.1), shape: BoxShape.circle),
    child: Icon(icon, color: const Color(0xFFC62828), size: 20),
  );
}