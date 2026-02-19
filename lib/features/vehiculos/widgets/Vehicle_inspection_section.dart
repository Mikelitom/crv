import 'package:flutter/material.dart';
import '../models/inspection_vehicle_model.dart';

class VehicleInspectionSection extends StatefulWidget {
  final String title;
  final List<InspectionItemModel> items;

  const VehicleInspectionSection({super.key, required this.title, required this.items});

  @override
  State<VehicleInspectionSection> createState() => _VehicleInspectionSectionState();
}

class _VehicleInspectionSectionState extends State<VehicleInspectionSection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 1000) {
        return _buildMobileTable();
      }
      return _buildDesktopTable();
    });
  }

  // MODO MÓVIL: TABLA COMPACTA (B, M, RO, RA)
  Widget _buildMobileTable() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _mobileHeaderTitle(),
          Container(
            color: const Color(0xFFF1F4F9),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text("Componente", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(child: Center(child: Text("B", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("M", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("RO", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text("RA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
                Expanded(flex: 2, child: Center(child: Text("Acciones", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          ...widget.items.map((item) => Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(item.description, style: const TextStyle(fontSize: 10))),
                Expanded(child: Center(child: _buildRadio(item, 0))),
                Expanded(child: Center(child: _buildRadio(item, 1))),
                Expanded(child: Center(child: _buildRadio(item, 2))),
                Expanded(child: Center(child: _buildRadio(item, 3))),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionIcon(Icons.comment, Colors.grey.shade500),
                      const SizedBox(width: 4),
                      _actionIcon(Icons.camera_alt, const Color(0xFFC62828)),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  // MODO DESKTOP: TABLA QUE ABARCA TODO EL ESPACIO
  Widget _buildDesktopTable() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F4F9)),
                columns: const [
                  DataColumn(label: Text('Componente', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Expanded(child: Center(child: Text('Buena')))),
                  DataColumn(label: Expanded(child: Center(child: Text('Mala')))),
                  DataColumn(label: Expanded(child: Center(child: Text('Reposición')))),
                  DataColumn(label: Expanded(child: Center(child: Text('Reparación')))),
                  DataColumn(label: Text('Observaciones')),
                  DataColumn(label: Expanded(child: Center(child: Text('Evidencia')))),
                ],
                rows: widget.items.map((item) => DataRow(cells: [
                  DataCell(Text(item.description)),
                  DataCell(Center(child: _buildRadio(item, 0))),
                  DataCell(Center(child: _buildRadio(item, 1))),
                  DataCell(Center(child: _buildRadio(item, 2))),
                  DataCell(Center(child: _buildRadio(item, 3))),
                  DataCell(Container(width: 200, child: TextField(decoration: InputDecoration(hintText: "Escribir...", border: InputBorder.none)))),
                  DataCell(Center(child: _actionIcon(Icons.camera_alt, const Color(0xFFC62828)))),
                ])).toList(),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRadio(InspectionItemModel item, int val) {
    return InkWell(
      onTap: () => setState(() => item.status = val),
      child: Container(
        width: 18, height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: item.status == val ? const Color(0xFFC62828) : Colors.grey.shade400, width: 2),
        ),
        child: item.status == val ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFC62828)))) : null,
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  Widget _mobileHeaderTitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text("Marque según condición: B, M, RO, RA", style: TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }
}