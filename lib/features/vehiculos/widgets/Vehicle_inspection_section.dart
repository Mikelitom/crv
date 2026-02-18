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
      if (constraints.maxWidth < 800) {
        return _buildMobileView(); // MODO BLOQUES CELULAR
      }
      return _buildDesktopView(context); // MODO TABLA LAPTOP
    });
  }

  // --- VISTA CELULAR (BLOQUES TAL CUAL TU FOTO) ---
  Widget _buildMobileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
        ),
        ...widget.items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            children: [
              _mobileHeader("DESCRIPCIÓN DEL COMPONENTE"),
              _mobileDataCell(Text(item.description, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
              _mobileHeaderRow(["CONDICIÓN", "ACCIONES"]),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _mobileRadio(item, 0, "BUENO"),
                        _mobileRadio(item, 1, "MALO"),
                        _mobileRadio(item, 2, "REPOSICIÓN"),
                        _mobileRadio(item, 3, "REPARACIÓN"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade400))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (item.imagePath != null) _buildMiniature(item.imagePath!),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _actionIcon(Icons.comment, Colors.grey),
                              const SizedBox(width: 8),
                              _actionIcon(Icons.camera_alt, Colors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  // --- VISTA LAPTOP (TABLA CON MARGEN IZQUIERDO Y CABECERA GRIS) ---
  Widget _buildDesktopView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(24), child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25), // El margen izquierdo que pediste
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F4F9)), // Encabezado Gris
                dataRowMaxHeight: 80,
                columns: const [
                  DataColumn(label: Text('Componente')),
                  DataColumn(label: Center(child: Text('Bueno'))),
                  DataColumn(label: Center(child: Text('Malo'))),
                  DataColumn(label: Center(child: Text('Rep.'))),
                  DataColumn(label: Text('Observaciones')),
                  DataColumn(label: Center(child: Text('Foto'))),
                ],
                rows: widget.items.map((item) => DataRow(cells: [
                  DataCell(Text(item.description)),
                  DataCell(Center(child: _buildCheck(item, 0))),
                  DataCell(Center(child: _buildCheck(item, 1))),
                  DataCell(Center(child: _buildCheck(item, 2))),
                  DataCell(SizedBox(width: 200, child: TextField(decoration: InputDecoration(hintText: "Escribir...", border: InputBorder.none)))),
                  DataCell(Center(child: _actionIcon(Icons.camera_alt, Colors.red))),
                ])).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS REUTILIZABLES ---
  Widget _mobileHeader(String text) => Container(width: double.infinity, color: const Color(0xFFEEEEEE), padding: const EdgeInsets.all(8), child: Center(child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))));
  
  Widget _mobileDataCell(Widget child) => Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))), child: child);

  Widget _mobileHeaderRow(List<String> labels) => Row(children: labels.map((l) => Expanded(child: _mobileHeader(l))).toList());

  Widget _mobileRadio(InspectionItemModel item, int val, String text) {
    return RadioListTile<int>(
      visualDensity: VisualDensity.compact,
      title: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
      value: val, groupValue: item.status, onChanged: (v) => setState(() => item.status = v),
      activeColor: Colors.red,
    );
  }

  Widget _actionIcon(IconData icon, Color color) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: Colors.white, size: 20));

  Widget _buildMiniature(String path) => Container(margin: const EdgeInsets.only(bottom: 5), width: 40, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover)));

  Widget _buildCheck(InspectionItemModel item, int val) => Checkbox(value: item.status == val, activeColor: Colors.red, onChanged: (v) => setState(() => item.status = v! ? val : null));
}