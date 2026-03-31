import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/create_press_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_list_notifier_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/widgets/base_asset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePressDialog extends ConsumerStatefulWidget {
  const CreatePressDialog({super.key});

  @override
  ConsumerState<CreatePressDialog> createState() => _CreatePressDialogState();
}

class _CreatePressDialogState extends ConsumerState<CreatePressDialog> {
  final _formKey = GlobalKey<FormState>();

  final typeController = TextEditingController();
  final modelController = TextEditingController();
  final voltzController = TextEditingController();
  final serieController = TextEditingController();
  final sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(createPressProvider, (previous, next) {
      if (!mounted) return;

      if (next.status == Status.success) {
        ref.read(pressListProvider.notifier).loadPress();
        Navigator.pop(context);
      }

      if (next.status == Status.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? "Error al registrar prensa")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPressProvider);

    return BaseAssetDialog(
      title: "Registrar nueva prensa",
      onConfirm: () async {
        if (!_formKey.currentState!.validate()) return;

        final press = CreatePressParams(
          type: typeController.text,
          model: modelController.text,
          voltz: voltzController.text,
          serie: serieController.text,
          size: sizeController.text,
        );

        await ref.read(createPressProvider.notifier).create(press);
      },
      isLoading: state.status == Status.loading,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              buildField(
                typeController,
                "Tipo",
                "Hidraulica / Mecanica",
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
        ),
      ],
    );
  }
}
