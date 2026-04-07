import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/update_press_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdatePressDialog extends ConsumerStatefulWidget {
  final Press press;

  const UpdatePressDialog({super.key, required this.press});

  @override
  ConsumerState<UpdatePressDialog> createState() => _UpdatePressDialogState();
}

class _UpdatePressDialogState extends ConsumerState<UpdatePressDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController typeController;
  late TextEditingController modelController;
  late TextEditingController voltzController;
  late TextEditingController serieController;
  late TextEditingController sizeController;

  bool _success = false;

  @override
  void initState() {
    super.initState();

    typeController = TextEditingController(text: widget.press.type);
    modelController = TextEditingController(text: widget.press.model);
    voltzController = TextEditingController(text: widget.press.voltz);
    serieController = TextEditingController(text: widget.press.serie);
    sizeController = TextEditingController(text: widget.press.size);

    ref.listenManual(updatePressProvider, (previous, next) async {
      if (!mounted) return;

      if (next.status == Status.success) {
        setState(() {
          _success = true;
        });

        ref.read(pressListProvider.notifier).loadPress();

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;
        Navigator.pop(context, true);
      }

      if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error ?? "Error al actualizar prensa"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updatePressProvider);
    final pressState = ref.read(pressListProvider);

    return BaseAssetDialog(
      title: _success ? "" : "Editar prensa",
      onConfirm: _success
          ? null
          : () async {
              if (!_formKey.currentState!.validate()) return;

              final press = CreatePressParams(
                type: typeController.text.trim(),
                model: modelController.text.trim(),
                voltz: voltzController.text.trim(),
                serie: serieController.text.trim(),
                size: sizeController.text.trim(),
              );

              await ref
                  .read(updatePressProvider.notifier)
                  .update(widget.press.id, press);
            },
      isLoading: state.status == Status.loading && !_success,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _success ? _buildSuccessState() : _buildForm(pressState),
        ),
      ],
    );
  }

  Widget _buildForm(PressListState pressState) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey("form"),
        children: [
          buildField(
            typeController,
            "Tipo",
            "Hidráulica / Mecánica",
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "El tipo es obligatorio";
              }
              return null;
            },
          ),

          buildField(
            modelController,
            "Modelo",
            "HS-500",
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "El modelo es obligatorio";
              }
              return null;
            },
          ),

          buildField(
            voltzController,
            "Volts",
            "220V",
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "El voltaje es obligatorio";
              }

              final regex = RegExp(r'^[0-9]+V$');
              if (!regex.hasMatch(value)) {
                return "Formato inválido (ej: 220V)";
              }

              return null;
            },
          ),

          buildField(
            serieController,
            "Número de Serie",
            "SN-2026-X",
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "La serie es obligatoria";
              }

              if (value.trim() != widget.press.serie) {
                final exists = pressState.press.any(
                  (p) => p.serie == serieController.text.trim(),
                );

                if (exists) return "Numero de serie ya registrado";
              }

              return null;
            },
          ),

          buildField(
            sizeController,
            "Tamaño",
            "5 tons",
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "El tamaño es obligatorio";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// SUCCESS UI (igual que client)
  Widget _buildSuccessState() {
    return SizedBox(
      key: const ValueKey("success"),
      height: 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: _success ? 1 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Prensa registrada",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
