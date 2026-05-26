import 'package:flutter/material.dart';

class PressEditModal extends StatefulWidget {
  final dynamic item; // Tu objeto PressModel
  final Function(Map<String, dynamic>) onSave;

  const PressEditModal({super.key, required this.item, required this.onSave});

  @override
  State<PressEditModal> createState() => _PressEditModalState();
}

class _PressEditModalState extends State<PressEditModal> {
  late TextEditingController _serieController;
  late TextEditingController _sizeController;
  late TextEditingController _modelController;
  late TextEditingController _voltsController;

  @override
  void initState() {
    super.initState();
    _serieController = TextEditingController(text: widget.item.serie);
    _sizeController = TextEditingController(text: widget.item.size);
    _modelController = TextEditingController(text: widget.item.model);
    _voltsController = TextEditingController(text: widget.item.volts);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Actualizar Prensa"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField("Serie", _serieController, Icons.numbers),
            _buildTextField("Tamaño", _sizeController, Icons.aspect_ratio),
            _buildTextField("Modelo", _modelController, Icons.precision_manufacturing),
            _buildTextField("Voltaje", _voltsController, Icons.electric_bolt),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () {
            widget.onSave({
              "serie": _serieController.text,
              "size": _sizeController.text,
              "model": _modelController.text,
              "volts": _voltsController.text,
            });
            Navigator.pop(context);
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
      ),
    );
  }
}