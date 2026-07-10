import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/type_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/create_vehicle_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/type_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateVehicleDialog extends ConsumerStatefulWidget {
  const CreateVehicleDialog({super.key});

  @override
  ConsumerState<CreateVehicleDialog> createState() => _CreateVehicleDialogState();
}

class _CreateVehicleDialogState extends ConsumerState<CreateVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  String? selectedTypeId;
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final licensePlateController = TextEditingController();
  final unitController = TextEditingController();

  bool _success = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, maxWidth: 800);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(createVehicleProvider, (previous, next) async {
      if (!mounted) return;
      if (next.status == Status.success) {
        setState(() => _success = true);
        ref.read(vehicleListProvider.notifier).loadVehicles();
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      }
      if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? "Error al registrar vehículo"), backgroundColor: Colors.red),
        );
      }
    });
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    licensePlateController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createVehicleProvider);
    final typeState = ref.watch(typeListProvider);
    final vehicleState = ref.read(vehicleListProvider);

    return BaseAssetDialog(
      title: _success ? "" : "Registrar nuevo vehículo",
      isLoading: (state.status == Status.loading || typeState.status == Status.loading) && !_success,
      onConfirm: _success ? null : () async {
        if (!_formKey.currentState!.validate() || selectedTypeId == null) return;
        final vehicle = CreateVehicleParams(
          typeId: selectedTypeId!,
          brand: brandController.text.trim(),
          model: modelController.text.trim(),
          unit: int.tryParse(unitController.text.trim()) ?? 0,
          year: int.tryParse(yearController.text.trim()) ?? 0,
          plate: licensePlateController.text.trim(),
          image: _imageFile,
        );
        await ref.read(createVehicleProvider.notifier).create(vehicle);
      },
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _success ? _buildSuccessState() : _buildForm(typeState, vehicleState),
        ),
      ],
    );
  }

  Widget _buildForm(TypeListState typeState, VehicleListState vehicleState) {
    return Form(
      key: _formKey,
      child: Column(key: const ValueKey("form"), children: [
        Center(
          child: GestureDetector(
            onTap: () => _showImageSourceDialog(),
            child: Container(
              height: 100, width: 100,
              decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
              child: _imageFile != null 
                  ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(_imageFile!, fit: BoxFit.cover))
                  : const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: selectedTypeId,
          decoration: _inputDecoration("Seleccionar tipo"),
          items: typeState.types.map((t) => DropdownMenuItem(value: t.id.toString(), child: Text(t.name))).toList(),
          onChanged: (v) => setState(() => selectedTypeId = v),
          validator: (v) => v == null ? "Seleccione un tipo" : null,
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _customBuildField(brandController, "Marca", "Toyota")),
          const SizedBox(width: 16),
          Expanded(child: _customBuildField(unitController, "Unidad", "101", keyboardType: TextInputType.number)),
        ]),
        _customBuildField(modelController, "Modelo", "Corolla"),
        Row(children: [
          Expanded(child: _customBuildField(yearController, "Año", "2026", keyboardType: TextInputType.number, validator: (v) {
             final y = int.tryParse(v!);
             return (y == null || y < 1900 || y > 2027) ? "Año inválido" : null;
          })),
          const SizedBox(width: 16),
          Expanded(child: _customBuildField(licensePlateController, "Placas", "ABC1234", validator: (v) {
             final exists = vehicleState.vehicles.any((vh) => vh.plate.toUpperCase() == v!.toUpperCase());
             if (exists) return "Ya registrada";
             if (v!.length < 6 || v.length > 7) return "Mínimo 6, máximo 7";
             return null;
          })),
        ]),
      ]),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(context: context, builder: (ctx) => SafeArea(child: Wrap(children: [
      ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Cámara'), onTap: () { _pickImage(ImageSource.camera); Navigator.pop(ctx); }),
      ListTile(leading: const Icon(Icons.photo_library), title: const Text('Galería'), onTap: () { _pickImage(ImageSource.gallery); Navigator.pop(ctx); }),
    ])));
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint, filled: true, fillColor: const Color(0xFFF8F9FA),
    contentPadding: const EdgeInsets.all(18),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
  );

  Widget _buildSuccessState() => SizedBox(height: 220, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.check_circle, size: 80, color: Colors.green),
    const SizedBox(height: 16),
    const Text("Vehículo registrado", style: TextStyle(fontWeight: FontWeight.bold))
  ])));

  Widget _customBuildField(TextEditingController controller, String label, String hint, {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ?? (v) => v!.isEmpty ? "Obligatorio" : null,
        decoration: _inputDecoration(hint),
      ),
      const SizedBox(height: 16),
    ]);
  }
}