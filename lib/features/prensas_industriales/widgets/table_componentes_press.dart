import 'package:flutter/material.dart';
import '../Models/prensa_inspection_model.dart';

class PrensaInspectionTable extends StatefulWidget {
  final List<PrensaComponentItem> items;
  const PrensaInspectionTable({super.key, required this.items});

  @override
  State<PrensaInspectionTable> createState() => _PrensaInspectionTableState();
}

class _PrensaInspectionTableState extends State<PrensaInspectionTable> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // MODO MÓVIL: Bloques apilados idénticos a la foto
        if (constraints.maxWidth < 700) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainTitle(), 
              const SizedBox(height: 10),
              ...widget.items.map((item) => _buildMobileBlock(item)).toList(),
            ],
          );
        }
        // MODO LAPTOP: Tabla centrada y profesional
        return _buildDesktopLayout();
      },
    );
  }

  // --- ESTRUCTURA MÓVIL CALCADA DE LA FOTO ---
  Widget _buildMobileBlock(PrensaComponentItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Column(
        children: [
          // FILA 1: CANTIDAD | UNIDAD
          _mobileHeaderRow(["CANTIDAD", "UNIDAD"]),
          Row(
            children: [
              Expanded(child: _buildInputCenter(initialValue: item.cantidad, onChanged: (v) => item.cantidad = v)),
              Expanded(child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade400))),
                child: Text(item.unidad, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
              )),
            ],
          ),

          // FILA 2: DESCRIPCIÓN DEL COMPONENTE
          _mobileHeaderRow(["DESCRIPCIÓN DEL COMPONENETE"]),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
            child: Text(item.descripcion, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),

          // FILA 3: CONDICIÓN | ACCIONES
          _mobileHeaderRow(["CONDICIÓN", "ACCIONES"]),
          Row(
            children: [
              // Lado Izquierdo: Radios
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade400))),
                  child: Column(
                    children: [
                      _mobileRadio(item, 0, "BUENO"),
                      _mobileRadio(item, 1, "MALO"),
                      _mobileRadio(item, 2, "NO APLICA"),
                    ],
                  ),
                ),
              ),
              // Lado Derecho: Botones y Miniatura Centrados
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (item.evidenciaPath != null) _buildMiniature(item.evidenciaPath!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _actionBtn(Icons.comment, Colors.grey.shade500, () => print("Nota")),
                          const SizedBox(width: 10),
                          _actionBtn(Icons.camera_alt, const Color(0xFFC62828), () => print("Cámara")),
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
    );
  }

  // --- HELPERS CELULAR ---
  Widget _mobileHeaderRow(List<String> labels) {
    return Row(
      children: labels.map((l) => Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE), // Gris exacto
            border: Border.all(color: Colors.grey.shade400, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(child: Text(l, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        ),
      )).toList(),
    );
  }

  Widget _buildInputCenter({required String initialValue, required Function(String) onChanged}) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      child: TextField(
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
      ),
    );
  }

  Widget _mobileRadio(PrensaComponentItem item, int val, String text) {
    return InkWell(
      onTap: () => setState(() => item.estado = val),
      child: Row(
        children: [
          Radio<int>(
            value: val, 
            groupValue: item.estado, 
            onChanged: (v) => setState(() => item.estado = v),
            activeColor: const Color(0xFFC62828),
          ),
          Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildMiniature(String path) {
    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (_) => Dialog(child: Image.asset(path))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        width: 45, height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green, width: 2),
          image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
        ),
      ),
    );
  }

  // --- VISTA DESKTOP (TABLA ALINEADA Y SEPARADA) ---
  Widget _buildDesktopLayout() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainTitle(),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25), // Margen izquierdo pedido
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 100),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F4F9)),
                  dataRowMaxHeight: 90,
                  columns: _buildDesktopColumns(),
                  rows: widget.items.map((item) => _buildDesktopRow(item)).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<DataColumn> _buildDesktopColumns() {
    return const [
      DataColumn(label: Center(child: Text('Cant.'))),
      DataColumn(label: Center(child: Text('Unidad'))),
      DataColumn(label: Text('Descripción')),
      DataColumn(label: Center(child: Text('Buenas'))),
      DataColumn(label: Center(child: Text('Malas'))),
      DataColumn(label: Center(child: Text('N/A'))),
      DataColumn(label: Text('Observaciones')),
      DataColumn(label: Center(child: Text('Evidencia'))),
    ];
  }

  DataRow _buildDesktopRow(PrensaComponentItem item) {
    return DataRow(
      cells: [
        DataCell(Center(child: _buildInputCenter(initialValue: item.cantidad, onChanged: (v)=> item.cantidad = v))),
        DataCell(Center(child: Text(item.unidad, style: const TextStyle(fontWeight: FontWeight.bold)))),
        DataCell(SizedBox(width: 240, child: Text(item.descripcion))),
        DataCell(Center(child: _buildCheck(item, 0))),
        DataCell(Center(child: _buildCheck(item, 1))),
        DataCell(Center(child: _buildCheck(item, 2))),
        DataCell(_buildInputCenter(initialValue: item.observaciones, onChanged: (v)=> item.observaciones = v)),
        DataCell(Center(child: _buildEvidenceBtnDesktop(item))),
      ],
    );
  }

  Widget _buildCheck(PrensaComponentItem item, int val) {
    return Checkbox(value: item.estado == val, onChanged: (v)=> setState(()=> item.estado = v! ? val : null), activeColor: const Color(0xFFC62828));
  }

  Widget _buildEvidenceBtnDesktop(PrensaComponentItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (item.evidenciaPath != null) _buildMiniature(item.evidenciaPath!),
        _actionBtn(Icons.camera_alt, const Color(0xFFC62828), () {}),
      ],
    );
  }

  Widget _buildMainTitle() {
    return const Padding(
      padding: EdgeInsets.all(28.0),
      child: Text("Lista de Verificación de componentes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}